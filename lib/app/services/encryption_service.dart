import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:pointycastle/export.dart';

class EncryptionService extends GetxService {
  static const String _keyStorageKey = 'com.lockbloom.app.v1.secure_data.master_encryption_key';
  static const String _saltStorageKey = 'com.lockbloom.app.v1.secure_data.master_salt_for_key_derivation';
  static const String _keyChecksumKey = 'com.lockbloom.app.v1.secure_data.key_checksum';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Encrypter? _encrypter;
  bool _isNewKeyGenerated = false;
  
  bool get wasKeyRegenerated => _isNewKeyGenerated;

  Future<void> init() async {
    await _initializeKey();
  }

  Future<void> _initializeKey() async {
    try {
      String? keyString = await _secureStorage.read(key: _keyStorageKey);
      String? saltString = await _secureStorage.read(key: _saltStorageKey);
      String? checksumString = await _secureStorage.read(key: _keyChecksumKey);

      if (keyString == null || saltString == null) {
        await _generateNewKey();
        _isNewKeyGenerated = true;
      } else {
        final keyBytes = base64Decode(keyString);
        final expectedChecksum = _calculateChecksum(keyBytes);
        
        if (checksumString != expectedChecksum) {
          throw EncryptionException('Key integrity check failed');
        }
        
        final key = Key(keyBytes);
        _encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      }
    } catch (e) {
      if (e is EncryptionException) {
        rethrow;
      }
      await _generateNewKey();
      _isNewKeyGenerated = true;
    }
  }

  String _calculateChecksum(List<int> data) {
    int sum = 0;
    for (int byte in data) {
      sum = (sum + byte) & 0xFFFFFFFF;
    }
    return sum.toRadixString(16);
  }

  Future<void> _generateNewKey() async {
    final key = Key.fromSecureRandom(32);
    final salt = _generateSalt();
    final checksum = _calculateChecksum(key.bytes);
    
    await _secureStorage.write(
      key: _keyStorageKey,
      value: base64Encode(key.bytes),
    );
    await _secureStorage.write(
      key: _saltStorageKey,
      value: base64Encode(salt),
    );
    await _secureStorage.write(
      key: _keyChecksumKey,
      value: checksum,
    );

    _encrypter = Encrypter(AES(key, mode: AESMode.gcm));
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

  Future<void> rotateKey() async {
    await _generateNewKey();
  }

  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _keyStorageKey);
    await _secureStorage.delete(key: _saltStorageKey);
    await _secureStorage.delete(key: _keyChecksumKey);
    _encrypter = null;
    _isNewKeyGenerated = false;
  }

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