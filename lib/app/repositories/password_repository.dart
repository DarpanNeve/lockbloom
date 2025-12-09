import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/services/encryption_service.dart';
import 'package:lockbloom/app/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class PasswordRepository extends GetxService {
  static const String _passwordsKey = 'encrypted_passwords';
  
  final EncryptionService _encryptionService = Get.find();
  final StorageService _storageService = Get.find();
  final Uuid _uuid = const Uuid();

  List<PasswordEntry>? _passwordCache;

  Future<List<PasswordEntry>> getAllPasswords() async {
    if (_passwordCache != null) {
      return _passwordCache!;
    }

    try {
      final encryptedData = await _storageService.readSecure(_passwordsKey);

      if (encryptedData == null) {
        _passwordCache = [];
        return [];
      }

      final decryptedJson = _encryptionService.decrypt(encryptedData);
      final List<dynamic> passwordList = jsonDecode(decryptedJson);

      final List<PasswordEntry> entries = passwordList.map((json) => PasswordEntry.fromJson(json)).toList();
      _passwordCache = entries;
      return entries;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'getAllPasswords failed');
      return [];
    }
  }

  Future<void> savePassword(PasswordEntry entry) async {
    final passwords = await getAllPasswords();
    
    final existingIndex = passwords.indexWhere((p) => p.id == entry.id);
    
    if (existingIndex != -1) {
      passwords[existingIndex] = entry.copyWith(updatedAt: DateTime.now());
    } else {
      passwords.add(entry.copyWith(
        id: entry.id.isEmpty ? _uuid.v4() : entry.id,
        createdAt: entry.createdAt,
        updatedAt: DateTime.now(),
      ));
    }
    
    _passwordCache = passwords;
    await _savePasswordList(passwords);
  }

  Future<void> deletePassword(String id) async {
    final passwords = await getAllPasswords();
    passwords.removeWhere((p) => p.id == id);
    _passwordCache = passwords;
    await _savePasswordList(passwords);
  }

  Future<PasswordEntry?> getPassword(String id) async {
    final passwords = await getAllPasswords();
    try {
      return passwords.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<PasswordEntry>> searchPasswords(String query) async {
    final passwords = await getAllPasswords();
    if (query.isEmpty) return passwords;
    
    final lowerQuery = query.toLowerCase();
    return passwords.where((p) =>
        p.label.toLowerCase().contains(lowerQuery) ||
        p.username.toLowerCase().contains(lowerQuery) ||
        p.website?.toLowerCase().contains(lowerQuery) == true ||
        p.notes.toLowerCase().contains(lowerQuery) ||
        p.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))).toList();
  }

  Future<List<PasswordEntry>> filterPasswordsByTags(List<String> tags) async {
    final passwords = await getAllPasswords();
    if (tags.isEmpty) return passwords;
    
    return passwords.where((p) =>
        tags.any((tag) => p.tags.contains(tag))).toList();
  }

  Future<List<PasswordEntry>> getFavoritePasswords() async {
    final passwords = await getAllPasswords();
    return passwords.where((p) => p.isFavorite).toList();
  }

  Future<String> exportPasswords(String masterPassword) async {
    final passwords = await getAllPasswords();
    final exportData = {
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'passwords': passwords.map((p) => p.toJson()).toList(),
    };

    final exportJson = jsonEncode(exportData);
    return _encryptionService.encryptWithPassword(exportJson, masterPassword);
  }

  Future<void> importPasswords(String encryptedData, String masterPassword) async {
    try {
      final decryptedJson = _encryptionService.decryptWithPassword(encryptedData, masterPassword);
      final Map<String, dynamic> exportData = jsonDecode(decryptedJson);

      if (exportData['version'].toString() != '1.0') {
        throw Exception('Unsupported export version');
      }

      final List<dynamic> passwordList = exportData['passwords'];
      final importedPasswords = passwordList.map((json) => PasswordEntry.fromJson(json)).toList();

      final existingPasswords = await getAllPasswords();
      final existingIds = existingPasswords.map((p) => p.id).toSet();

      final newPasswords = importedPasswords.where((p) => !existingIds.contains(p.id)).toList();
      final allPasswords = [...existingPasswords, ...newPasswords];

      _passwordCache = allPasswords;
      await _savePasswordList(allPasswords);
    } catch (e, stack) {
      if (e.toString().contains('Failed to decrypt data')) {
        throw Exception('Invalid password or corrupted file');
      }
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'importPasswords failed');
      throw Exception('Failed to import passwords: ${e.toString()}');
    }
  }

  Future<void> _savePasswordList(List<PasswordEntry> passwords) async {
    final jsonList = passwords.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final encryptedData = _encryptionService.encrypt(jsonString);
    
    await _storageService.writeSecure(_passwordsKey, encryptedData);
  }

  Future<void> clearAllPasswords() async {
    _passwordCache = null;
    await _storageService.deleteSecure(_passwordsKey);
  }

  Future<Map<String, dynamic>> getPasswordStats() async {
    final passwords = await getAllPasswords();
    
    return {
      'total': passwords.length,
      'favorites': passwords.where((p) => p.isFavorite).length,
      'withWebsite': passwords.where((p) => p.website?.isNotEmpty == true).length,
      'tags': passwords.expand((p) => p.tags).toSet().length,
      'oldestEntry': passwords.isEmpty ? null : 
          passwords.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b).createdAt,
      'newestEntry': passwords.isEmpty ? null :
          passwords.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b).createdAt,
    };
  }
}