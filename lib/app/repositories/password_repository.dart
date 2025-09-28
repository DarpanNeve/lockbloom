import 'dart:convert';
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

  /// Get all password entries
  Future<List<PasswordEntry>> getAllPasswords() async {
    print('PasswordRepository: getAllPasswords called.');
    try {
      final encryptedData = await _storageService.readSecure(_passwordsKey);
      print('PasswordRepository: Encrypted data from storage: ${encryptedData != null ? 'present' : 'null'}');

      if (encryptedData == null) {
        print('PasswordRepository: No encrypted data found, returning empty list.');
        return [];
      }

      final decryptedJson = _encryptionService.decrypt(encryptedData);
      print('PasswordRepository: Decrypted JSON length: ${decryptedJson.length}');

      final List<dynamic> passwordList = jsonDecode(decryptedJson);
      print('PasswordRepository: Decoded password list count: ${passwordList.length}');

      final List<PasswordEntry> entries = passwordList.map((json) => PasswordEntry.fromJson(json)).toList();
      print('PasswordRepository: Converted to ${entries.length} PasswordEntry objects.');
      return entries;
    } catch (e) {
      print('PasswordRepository: Error in getAllPasswords: $e');
      // If decryption fails, return empty list (data might be corrupted)
      return [];
    }
  }

  /// Save a password entry
  Future<void> savePassword(PasswordEntry entry) async {
    final passwords = await getAllPasswords();
    
    // Check if entry already exists (update) or is new (create)
    final existingIndex = passwords.indexWhere((p) => p.id == entry.id);
    
    if (existingIndex != -1) {
      // Update existing entry
      passwords[existingIndex] = entry.copyWith(updatedAt: DateTime.now());
    } else {
      // Add new entry
      passwords.add(entry.copyWith(
        id: entry.id.isEmpty ? _uuid.v4() : entry.id,
        createdAt: entry.createdAt,
        updatedAt: DateTime.now(),
      ));
    }
    
    await _savePasswordList(passwords);
  }

  /// Delete a password entry
  Future<void> deletePassword(String id) async {
    final passwords = await getAllPasswords();
    passwords.removeWhere((p) => p.id == id);
    await _savePasswordList(passwords);
  }

  /// Get a specific password entry by ID
  Future<PasswordEntry?> getPassword(String id) async {
    final passwords = await getAllPasswords();
    try {
      return passwords.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search passwords by query
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

  /// Filter passwords by tags
  Future<List<PasswordEntry>> filterPasswordsByTags(List<String> tags) async {
    final passwords = await getAllPasswords();
    if (tags.isEmpty) return passwords;
    
    return passwords.where((p) =>
        tags.any((tag) => p.tags.contains(tag))).toList();
  }

  /// Get favorite passwords
  Future<List<PasswordEntry>> getFavoritePasswords() async {
    final passwords = await getAllPasswords();
    return passwords.where((p) => p.isFavorite).toList();
  }

  /// Export passwords as encrypted JSON
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

  /// Import passwords from encrypted JSON
  Future<void> importPasswords(String encryptedData, String masterPassword) async {
    try {
      final decryptedJson = _encryptionService.decryptWithPassword(encryptedData, masterPassword);
      final Map<String, dynamic> exportData = jsonDecode(decryptedJson);

      if (exportData['version'] != '1.0') {
        throw Exception('Unsupported export version');
      }

      final List<dynamic> passwordList = exportData['passwords'];
      final importedPasswords = passwordList.map((json) => PasswordEntry.fromJson(json)).toList();

      // Merge with existing passwords (avoid duplicates by ID)
      final existingPasswords = await getAllPasswords();
      final existingIds = existingPasswords.map((p) => p.id).toSet();

      final newPasswords = importedPasswords.where((p) => !existingIds.contains(p.id)).toList();
      final allPasswords = [...existingPasswords, ...newPasswords];

      await _savePasswordList(allPasswords);
    } catch (e) {
      if (e.toString().contains('Failed to decrypt data with password')) {
        throw Exception('Invalid password or corrupted file');
      }
      throw Exception('Failed to import passwords: ${e.toString()}');
    }
  }

  /// Save the password list to secure storage
  Future<void> _savePasswordList(List<PasswordEntry> passwords) async {
    final jsonList = passwords.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final encryptedData = _encryptionService.encrypt(jsonString);
    
    await _storageService.writeSecure(_passwordsKey, encryptedData);
  }

  /// Clear all passwords (for app reset)
  Future<void> clearAllPasswords() async {
    await _storageService.deleteSecure(_passwordsKey);
  }

  /// Get password statistics
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