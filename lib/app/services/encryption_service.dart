import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class EncryptionService extends GetxService {
  static const String _keyStorageKey = 'encryption_key';
  static const String _saltStorageKey = 'encryption_salt';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Encrypter? _encrypter;
  IV? _iv;

  /// Initialize the encryption service
  Future<void> init() async {
    await _initializeKey();
  }

  /// Initialize or retrieve the encryption key
  Future<void> _initializeKey() async {
    try {
      String? keyString = await _secureStorage.read(key: _keyStorageKey);
      String? saltString = await _secureStorage.read(key: _saltStorageKey);

      if (keyString == null || saltString == null) {
        await _generateNewKey();
      } else {
        final key = Key(base64Decode(keyString));
        _encrypter = Encrypter(AES(key, mode: AESMode.gcm));
        _iv = IV.fromSecureRandom(12); // GCM recommended IV length
      }
    } catch (e) {
      // If there's any issue with existing keys, generate new ones
      await _generateNewKey();
    }
  }

  /// Generate a new encryption key
  Future<void> _generateNewKey() async {
    final key = Key.fromSecureRandom(32); // 256-bit key
    final salt = _generateSalt();
    
    await _secureStorage.write(
      key: _keyStorageKey,
      value: base64Encode(key.bytes),
    );
    await _secureStorage.write(
      key: _saltStorageKey,
      value: base64Encode(salt),
    );

    _encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    _iv = IV.fromSecureRandom(12);
  }

  /// Generate a random salt
  Uint8List _generateSalt() {
    final random = Random.secure();
    final salt = Uint8List(32);
    for (int i = 0; i < salt.length; i++) {
      salt[i] = random.nextInt(256);
    }
    return salt;
  }

  /// Encrypt data using AES-GCM
  String encrypt(String plaintext) {
    if (_encrypter == null) {
      throw StateError('Encryption service not initialized');
    }

    try {
      final iv = IV.fromSecureRandom(12);
      final encrypted = _encrypter!.encrypt(plaintext, iv: iv);
      
      // Combine IV and encrypted data
      final combined = <int>[
        ...iv.bytes,
        ...encrypted.bytes,
      ];
      
      return base64Encode(combined);
    } catch (e) {
      throw EncryptionException('Failed to encrypt data: $e');
    }
  }

  /// Decrypt data using AES-GCM
  String decrypt(String ciphertext) {
    if (_encrypter == null) {
      throw StateError('Encryption service not initialized');
    }

    try {
      final combined = base64Decode(ciphertext);
      
      // Extract IV and encrypted data
      final iv = IV(Uint8List.fromList(combined.take(12).toList()));
      final encryptedData = Uint8List.fromList(combined.skip(12).toList());
      
      final encrypted = Encrypted(encryptedData);
      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw EncryptionException('Failed to decrypt data: $e');
    }
  }

  /// Rotate the encryption key and re-encrypt all data
  Future<void> rotateKey() async {
    await _generateNewKey();
  }

  /// Clear all encryption keys (for app reset)
  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _keyStorageKey);
    await _secureStorage.delete(key: _saltStorageKey);
    _encrypter = null;
    _iv = null;
  }

  /// Check if encryption is properly initialized
  bool get isInitialized => _encrypter != null;
}

class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);
  
  @override
  String toString() => 'EncryptionException: $message';
}