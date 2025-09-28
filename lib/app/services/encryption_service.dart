import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:pointycastle/export.dart';

class EncryptionService extends GetxService {
  static const String _keyStorageKey = 'com.lockbloom.app.v1.secure_data.master_encryption_key';
  static const String _saltStorageKey = 'com.lockbloom.app.v1.secure_data.master_salt_for_key_derivation';
  
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

  /// Derive key from password using PBKDF2
  Uint8List _deriveKeyFromPassword(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, 100000, 32)); // 100,000 iterations, 32 bytes key
    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }

  /// Encrypt data with password-based encryption for export
  String encryptWithPassword(String plaintext, String password) {
    try {
      // Generate random salt for this encryption
      final salt = _generateSalt();
      final derivedKey = _deriveKeyFromPassword(password, salt);

      // Create temporary encrypter with derived key
      final key = Key(derivedKey);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      // Generate random IV
      final iv = IV.fromSecureRandom(12);
      final encrypted = encrypter.encrypt(plaintext, iv: iv);

      // Combine salt, IV and encrypted data
      final combined = <int>[
        ...salt,           // 32 bytes salt
        ...iv.bytes,       // 12 bytes IV
        ...encrypted.bytes, // encrypted data
      ];

      return base64Encode(combined);
    } catch (e) {
      throw EncryptionException('Failed to encrypt data with password: $e');
    }
  }

  /// Decrypt data with password-based encryption for import
  String decryptWithPassword(String ciphertext, String password) {
    try {
      final combined = base64Decode(ciphertext);

      if (combined.length < 44) { // 32 + 12 = minimum size
        throw EncryptionException('Invalid encrypted data format');
      }

      // Extract salt, IV and encrypted data
      final salt = Uint8List.fromList(combined.take(32).toList());
      final iv = IV(Uint8List.fromList(combined.skip(32).take(12).toList()));
      final encryptedData = Uint8List.fromList(combined.skip(44).toList());

      // Derive key from password and salt
      final derivedKey = _deriveKeyFromPassword(password, salt);

      // Create temporary encrypter with derived key
      final key = Key(derivedKey);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

      final encrypted = Encrypted(encryptedData);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw EncryptionException('Failed to decrypt data with password: $e');
    }
  }
}

class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);
  
  @override
  String toString() => 'EncryptionException: $message';
}