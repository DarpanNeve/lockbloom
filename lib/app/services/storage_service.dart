import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  SharedPreferences? _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  // Secure Storage Methods (for sensitive data)
  Future<void> writeSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }

  // Regular Storage Methods (for non-sensitive data)
  Future<bool> write(String key, dynamic value) async {
    if (_prefs == null) return false;
    
    if (value is String) {
      return await _prefs!.setString(key, value);
    } else if (value is int) {
      return await _prefs!.setInt(key, value);
    } else if (value is double) {
      return await _prefs!.setDouble(key, value);
    } else if (value is bool) {
      return await _prefs!.setBool(key, value);
    } else if (value is List<String>) {
      return await _prefs!.setStringList(key, value);
    } else {
      return await _prefs!.setString(key, jsonEncode(value));
    }
  }

  T? read<T>(String key) {
    if (_prefs == null) return null;
    
    final value = _prefs!.get(key);
    if (value is T) {
      return value;
    } else if (value is String && T != String) {
      try {
        return jsonDecode(value) as T;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> remove(String key) async {
    if (_prefs == null) return false;
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    if (_prefs == null) return false;
    return await _prefs!.clear();
  }

  bool hasKey(String key) {
    if (_prefs == null) return false;
    return _prefs!.containsKey(key);
  }
}