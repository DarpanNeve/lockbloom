# LockBloom - Secure Password Manager

A modern, secure password manager built with Flutter featuring AES-GCM encryption, biometric authentication, and a polished user interface.

## ✨ Features

### 🔐 Security First
- **AES-GCM Encryption**: All passwords encrypted client-side with 256-bit keys
- **Secure Key Storage**: Encryption keys stored in Android Keystore/iOS Keychain
- **Biometric Authentication**: Fingerprint and Face ID support
- **Auto-lock**: Configurable timeout for enhanced security
- **No Cloud Dependencies**: Fully offline, your data never leaves your device

### 🎯 Password Generation
- **Cryptographically Secure**: Uses Random.secure() for generation
- **Customizable Options**: Length (8-64), character types, exclusions
- **Password Strength Meter**: Real-time entropy calculation and feedback
- **Pronounceable Passwords**: Optional human-readable password generation

### 📱 Modern UI/UX
- **Responsive Design**: Pixel-perfect scaling with ScreenUtil
- **Dark/Light Themes**: Automatic theme switching with smooth transitions
- **Material Design 3**: Latest design system with dynamic colors
- **Accessibility**: Screen reader support and proper contrast ratios
- **Micro-interactions**: Subtle animations for enhanced user experience

### 🗃️ Password Management
- **CRUD Operations**: Create, read, update, delete password entries
- **Advanced Search**: Search by label, username, website, tags, or notes
- **Tag System**: Organize passwords with custom tags
- **Favorites**: Quick access to frequently used passwords
- **Secure Copy**: One-tap clipboard copy with auto-clear

### 💾 Data Management
- **Encrypted Export/Import**: Password-protected backup files
- **Migration Support**: Future-ready for cloud sync capabilities
- **Password History**: Optional tracking of password changes
- **Statistics**: Insights into your password vault

## 🏗️ Architecture

### Clean Architecture Pattern
```
UI Layer (Views/Widgets)
    ↓
Controller Layer (GetX Controllers)
    ↓
Service Layer (Business Logic)
    ↓
Repository Layer (Data Access)
    ↓
Data Layer (Models/Storage)
```

### Key Components
- **GetX**: State management and dependency injection
- **ScreenUtil**: Responsive design system
- **flutter_secure_storage**: Secure key storage
- **encrypt**: AES-GCM encryption implementation
- **local_auth**: Biometric authentication
- **freezed**: Immutable data models

## 🔧 Setup & Installation

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio / Xcode for platform-specific builds

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lockbloom
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Platform Setup**

   **Android:**
   - Add biometric permissions to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.USE_FINGERPRINT" />
   <uses-permission android:name="android.permission.USE_BIOMETRIC" />
   ```

   **iOS:**
   - Add Face ID usage description to `ios/Runner/Info.plist`:
   ```xml
   <key>NSFaceIDUsageDescription</key>
   <string>Use Face ID to authenticate and access your passwords</string>
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Test with coverage
flutter test --coverage
```

### Test Structure
- **Unit Tests**: Service layer, encryption, password generation
- **Widget Tests**: UI components and user interactions
- **Integration Tests**: End-to-end user flows

## 🚀 Building for Release

### Android APK
```bash
flutter build apk --release --split-per-abi
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🔒 Security Considerations

### Encryption Details
- **Algorithm**: AES-256-GCM (Galois/Counter Mode)
- **Key Derivation**: Secure random 256-bit keys
- **IV Generation**: Cryptographically secure 96-bit IVs per encryption
- **Key Storage**: Platform secure storage (Keychain/Keystore)

### Security Best Practices
- **Memory Management**: Sensitive data cleared from memory when possible
- **No Logging**: Plaintext passwords never logged or stored temporarily
- **Auto-lock**: Configurable session timeouts
- **Biometric Fallback**: PIN authentication when biometrics unavailable

### Threat Model
- ✅ **Device Theft**: Data encrypted, requires PIN/biometric
- ✅ **Memory Dumps**: Sensitive data minimally stored in memory  
- ✅ **Backup Extraction**: Encrypted storage, keys in secure storage
- ✅ **Malicious Apps**: Secure storage APIs protect keys
- ⚠️ **Device Compromise**: Root/jailbreak may expose secure storage
- ⚠️ **Physical Access**: PIN/biometric bypass via device exploits

## 📋 Requirements Met

### Functional Requirements ✅
- [x] Cryptographically secure password generation
- [x] AES-GCM client-side encryption
- [x] Secure storage with biometric authentication
- [x] CRUD operations for password entries
- [x] Search and filtering capabilities
- [x] Export/import encrypted backups
- [x] Responsive UI with theme support

### Non-Functional Requirements ✅
- [x] Offline-first architecture
- [x] Clean separation of concerns
- [x] Comprehensive error handling
- [x] Memory-efficient implementation
- [x] Platform security compliance
- [x] Accessibility support

### Security Requirements ✅
- [x] Random.secure() for password generation
- [x] AES-GCM encryption with secure key storage
- [x] Memory clearing best practices
- [x] No plaintext logging
- [x] Configurable security settings
- [x] Biometric authentication integration

## 🚧 Future Enhancements

### Planned Features
- **Cloud Sync**: Encrypted synchronization across devices
- **Secure Sharing**: Share passwords securely between users  
- **Password Auditing**: Weak/reused password detection
- **Breach Monitoring**: Check passwords against known breaches
- **Secure Notes**: Encrypted note storage
- **2FA Integration**: TOTP code generation

### Technical Improvements
- **Background Sync**: Automatic cloud synchronization
- **Wear OS Support**: Smartwatch companion app
- **Browser Extension**: Desktop browser integration
- **API Keys Management**: Secure API key storage
- **Team Vaults**: Shared password vaults for organizations

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow the existing architecture patterns
- Add tests for new functionality
- Update documentation for API changes
- Ensure security best practices are maintained
- Use conventional commit messages

## 🐛 Bug Reports

Please use the [GitHub Issues](https://github.com/your-repo/lockbloom/issues) page to report bugs or request features.

### Security Issues
For security-related issues, please email [security@yourcompany.com] instead of using public issues.

---

**⚡ LockBloom - Your passwords, secured and simplified.**