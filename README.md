# 🔐 LockBloom - Secure Password Manager

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Play Store](https://img.shields.io/badge/Google_Play-Available-414141?style=for-the-badge&logo=google-play)](https://play.google.com/store/apps/details?id=com.dn.lockbloom)

**A modern, secure, offline-first password manager built with Flutter**

[Features](#-features) • [Security](#-security) • [Installation](#-installation) • [Screenshots](#-screenshots) • [Contributing](#-contributing)

</div>

---

## 📱 About

LockBloom is a privacy-focused password manager that keeps your credentials secure with military-grade encryption. Unlike cloud-based password managers, LockBloom stores everything locally on your device, giving you complete control over your data.

### Why LockBloom?

- **🔒 Zero-Knowledge Architecture**: Your data never leaves your device
- **🛡️ Military-Grade Encryption**: AES-256-GCM encryption for all passwords
- **👆 Biometric Security**: Fingerprint & Face ID authentication
- **🎨 Beautiful UI**: Modern Material Design 3 with dark/light themes
- **📦 Offline-First**: No internet connection required
- **🚀 Open Source**: Transparent, auditable security

---

## ✨ Features

### 🔐 Security First

- **AES-256-GCM Encryption**: All passwords encrypted client-side with authenticated encryption
- **Secure Key Storage**: Encryption keys stored in Android Keystore/iOS Keychain
- **Biometric Authentication**: Fingerprint and Face ID support with PIN fallback
- **Auto-Lock**: Configurable timeout for enhanced security
- **No Cloud Dependencies**: Fully offline - your data never leaves your device
- **Memory Protection**: Sensitive data cleared from memory when not in use

### 🎯 Password Generation

- **Cryptographically Secure**: Uses `Random.secure()` for true randomness
- **Customizable Options**:
  - Length: 8-64 characters
  - Character types: uppercase, lowercase, numbers, symbols
  - Custom character exclusions
- **Password Strength Meter**: Real-time entropy calculation and visual feedback
- **Pronounceable Passwords**: Optional human-readable password generation
- **Batch Generation**: Generate multiple passwords at once

### 📱 Modern UI/UX

- **Responsive Design**: Pixel-perfect scaling across all device sizes
- **Dark/Light Themes**: Automatic theme switching with smooth transitions
- **Material Design 3**: Latest design system with dynamic colors
- **Accessibility**: Screen reader support and WCAG-compliant contrast ratios
- **Micro-interactions**: Subtle animations for enhanced user experience
- **Haptic Feedback**: Touch feedback for important actions

### 🗃️ Password Management

- **Full CRUD Operations**: Create, read, update, and delete password entries
- **Advanced Search**: Search by label, username, website, tags, or notes
- **Tag System**: Organize passwords with custom tags and categories
- **Favorites**: Quick access to frequently used passwords
- **Secure Copy**: One-tap clipboard copy with automatic clearing (30s)
- **Password History**: Track changes to your passwords over time
- **Sorting & Filtering**: Multiple sort options and filter presets

### 💾 Data Management

- **Encrypted Export/Import**: Password-protected AES-encrypted backup files
- **Cross-Device Migration**: Easy transfer between devices
- **Automatic Backups**: Optional scheduled backups
- **Statistics Dashboard**: Insights into your password vault:
  - Total passwords
  - Password strength distribution
  - Most used tags
  - Security score

### 🔧 Additional Features

- **OTA Updates**: Powered by Shorebird for instant updates without app store delays
- **Crash Reporting**: Firebase Crashlytics for stability monitoring
- **Performance Monitoring**: Optimized for speed and efficiency
- **Multi-Language Support**: Ready for internationalization
- **Version Checker**: Automatic update notifications

---

## 🛡️ Security

### Encryption Details

| Component | Implementation |
|-----------|----------------|
| **Algorithm** | AES-256-GCM (Galois/Counter Mode) |
| **Key Size** | 256 bits |
| **IV Generation** | Cryptographically secure 96-bit nonces per encryption |
| **Key Derivation** | PBKDF2 with 100,000 iterations (for export/import) |
| **Key Storage** | Android Keystore / iOS Keychain |
| **Random Number Generator** | Dart's `Random.secure()` (platform-native CSPRNG) |

### Security Architecture

```
┌─────────────────────────────────────────────┐
│           User Interface Layer              │
│  (PIN/Biometric Authentication Required)    │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│         Encryption Service Layer            │
│  • AES-256-GCM Encryption/Decryption        │
│  • Secure Key Management                    │
│  • Random IV Generation                     │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│       Secure Storage Layer                  │
│  • flutter_secure_storage                   │
│  • Android: EncryptedSharedPreferences      │
│  • iOS: Keychain (kSecAttrAccessible...)    │
└─────────────────────────────────────────────┘
```

### Security Best Practices

✅ **Memory Management**: Sensitive data cleared from memory when possible
✅ **No Logging**: Plaintext passwords never logged or stored temporarily
✅ **Auto-lock**: Configurable session timeouts
✅ **Biometric Fallback**: PIN authentication when biometrics unavailable
✅ **Secure Clipboard**: Auto-clear after 30 seconds
✅ **Code Obfuscation**: ProGuard/R8 enabled for release builds
✅ **No Backups**: Android backup disabled to prevent unencrypted cloud backups

### Threat Model

| Threat | Protection |
|--------|------------|
| **Device Theft** | ✅ All data encrypted, requires PIN/biometric |
| **Memory Dumps** | ✅ Sensitive data minimally stored in memory |
| **Backup Extraction** | ✅ Encrypted storage, keys in secure storage |
| **Malicious Apps** | ✅ Secure storage APIs protect keys |
| **Network Interception** | ✅ No network communication (offline-only) |
| **Device Compromise** | ⚠️ Root/jailbreak may expose secure storage |
| **Physical Access** | ⚠️ PIN/biometric bypass via device exploits |

---

## 🏗️ Architecture

### Clean Architecture Pattern

```
┌─────────────────────────────────────────┐
│     UI Layer (Views/Widgets)            │
│  • Material Design 3 components         │
│  • Responsive layouts                   │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Controller Layer (GetX Controllers)    │
│  • State management                     │
│  • Business logic coordination          │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│   Service Layer (Business Logic)        │
│  • Encryption service                   │
│  • Biometric service                    │
│  • Password generation                  │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Repository Layer (Data Access)         │
│  • Password repository                  │
│  • Settings repository                  │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│    Data Layer (Models/Storage)          │
│  • Encrypted storage                    │
│  • Immutable data models                │
└─────────────────────────────────────────┘
```

### Key Technologies

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.7+ | Cross-platform UI framework |
| **Language** | Dart 3.0+ | Modern, type-safe language |
| **State Management** | GetX | Reactive state management & DI |
| **Encryption** | encrypt + pointycastle | AES-GCM encryption |
| **Secure Storage** | flutter_secure_storage | Platform secure key storage |
| **Authentication** | local_auth | Biometric authentication |
| **Responsive Design** | flutter_screenutil | Adaptive UI scaling |
| **Data Models** | freezed + json_annotation | Immutable data classes |
| **OTA Updates** | Shorebird | Code push updates |
| **Analytics** | Firebase | Crashlytics, Performance, Analytics |

---

## 🚀 Installation

### Prerequisites

- Flutter SDK ≥ 3.7.0
- Dart SDK ≥ 3.0.0
- Android Studio / Xcode for platform-specific builds
- Git

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/DarpanNeve/lockbloom.git
   cd lockbloom
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

<details>
<summary><b>Android Setup</b></summary>

The biometric permissions are already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

**For signing (release builds):**

Create `android/key.properties` (NOT committed to git):
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

</details>

<details>
<summary><b>iOS Setup</b></summary>

Face ID usage is already configured in `ios/Runner/Info.plist`:

```xml
<key>NSFaceIDUsageDescription</key>
<string>Use Face ID to authenticate and access your passwords</string>
```

No additional setup required.

</details>

---

## 🧪 Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests (if available)
flutter test integration_test/

# Test with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

- **Unit Tests**: Service layer, encryption, password generation
- **Widget Tests**: UI components and user interactions
- **Integration Tests**: End-to-end user flows

---

## 🏗️ Building for Release

### Android

```bash
# Build AAB for Play Store
flutter build appbundle --release

# Build APK (multiple ABIs)
flutter build apk --release --split-per-abi

# Using deployment script (requires service account setup)
chmod +x deploy/android_prod.sh
./deploy/android_prod.sh
```

**Note**: The deployment script expects a Google Cloud service account JSON file for Play Store deployment. Store it securely at `~/.secrets/lockbloom/service_account.json` (NOT in the project directory).

### iOS

```bash
# Build for iOS
flutter build ios --release

# Create IPA (requires Xcode)
flutter build ipa --release
```

---

## 📸 Screenshots

<div align="center">

| Home Screen | Password Detail | Password Generation |
|-------------|-----------------|---------------------|
| <img src="screenshots/home.png" width="250"/> | <img src="screenshots/detail.png" width="250"/> | <img src="screenshots/generator.png" width="250"/> |

| Settings | Dark Mode | Biometric Auth |
|----------|-----------|----------------|
| <img src="screenshots/settings.png" width="250"/> | <img src="screenshots/dark.png" width="250"/> | <img src="screenshots/biometric.png" width="250"/> |

</div>

*Note: Screenshots will be added as the app is open-sourced*

---

## 📋 Project Structure

```
lockbloom/
├── lib/
│   ├── app/
│   │   ├── controllers/          # GetX controllers
│   │   ├── data/
│   │   │   └── models/           # Data models
│   │   ├── modules/              # Feature modules (views)
│   │   ├── repositories/         # Data repositories
│   │   ├── routes/               # App routing
│   │   ├── services/             # Business logic services
│   │   └── widgets/              # Reusable widgets
│   ├── config/                   # App configuration
│   ├── firebase_options.dart     # Firebase config
│   └── main.dart                 # App entry point
├── android/                      # Android native code
├── ios/                          # iOS native code
├── assets/                       # Images, fonts, etc.
├── deploy/                       # Deployment scripts
└── test/                         # Unit & widget tests
```

---

## 🤝 Contributing

Contributions are welcome! This project follows a code of conduct. Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting a pull request.

### Development Workflow

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
   - Follow the existing architecture patterns
   - Add tests for new functionality
   - Ensure security best practices are maintained
4. **Commit your changes**
   ```bash
   git commit -m 'Add: amazing feature'
   ```
   Use conventional commit messages:
   - `Add:` for new features
   - `Fix:` for bug fixes
   - `Update:` for improvements
   - `Refactor:` for code refactoring
   - `Docs:` for documentation
5. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request**

### Code Style

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Run `flutter analyze` before committing
- Format code with `flutter format .`
- Maintain test coverage above 70%

### Security Guidelines

⚠️ **NEVER commit sensitive data:**
- Service account keys
- API keys or secrets
- Keystores or signing keys
- `.env` files with credentials

See [.gitignore](.gitignore) for excluded files.

---

## 🐛 Bug Reports & Feature Requests

Please use [GitHub Issues](https://github.com/DarpanNeve/lockbloom/issues) to report bugs or request features.

**Before submitting:**
- Search existing issues to avoid duplicates
- Use the issue templates provided
- Include as much detail as possible

### Security Issues

For security vulnerabilities, please **DO NOT** open a public issue. Instead:

- Email: darpanneve3@gmail.com
- Include detailed steps to reproduce
- Allow time for a fix before public disclosure

We take security seriously and will respond promptly to vulnerability reports.

---

## 🚧 Roadmap

### Version 2.0 (Planned)

- [ ] **Cloud Sync**: End-to-end encrypted cloud synchronization
- [ ] **Secure Sharing**: Share passwords securely between users
- [ ] **Password Auditing**: Detect weak, reused, or compromised passwords
- [ ] **Breach Monitoring**: Check passwords against known data breaches
- [ ] **2FA Integration**: TOTP code generation (Google Authenticator compatible)
- [ ] **Secure Notes**: Encrypted note storage
- [ ] **Team Vaults**: Shared password vaults for organizations

### Version 2.5 (Future)

- [ ] **Browser Extension**: Desktop browser integration (Chrome, Firefox, Edge)
- [ ] **Wear OS Support**: Smartwatch companion app
- [ ] **API Keys Management**: Secure API key storage and rotation
- [ ] **SSH Key Management**: Store and manage SSH keys
- [ ] **Autofill Service**: Android Autofill framework integration
- [ ] **Emergency Access**: Trusted contact emergency access

### Version 3.0 (Vision)

- [ ] **Password-less Authentication**: WebAuthn/FIDO2 support
- [ ] **Hardware Security Key**: YubiKey integration
- [ ] **Zero-Knowledge Sync**: Fully encrypted cloud backend
- [ ] **Family Sharing**: Secure password sharing within families
- [ ] **Desktop Apps**: Native Windows, macOS, Linux apps

---

## 📊 Statistics

<div align="center">

![GitHub stars](https://img.shields.io/github/stars/DarpanNeve/lockbloom?style=social)
![GitHub forks](https://img.shields.io/github/forks/DarpanNeve/lockbloom?style=social)
![GitHub issues](https://img.shields.io/github/issues/DarpanNeve/lockbloom)
![GitHub pull requests](https://img.shields.io/github/issues-pr/DarpanNeve/lockbloom)

</div>

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Darpan Neve

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **GetX Community** for state management patterns
- **PointyCastle** for Dart cryptography
- **Firebase** for crash reporting and analytics
- **Shorebird** for OTA update capabilities
- All **contributors** who help improve LockBloom

---

## ☕ Support the Project

If LockBloom helps keep your passwords secure, consider supporting its development!

<div align="center">

### Buy Me a Coffee

<img src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=https://buymeacoffee.com/darpanneve" alt="Buy Me a Coffee QR Code" width="250"/>

**[☕ Buy Me a Coffee](https://buymeacoffee.com/darpanneve)**

*Scan the QR code or click the link above*

---

**Other ways to support:**

[![GitHub Sponsor](https://img.shields.io/badge/Sponsor-GitHub-pink?style=for-the-badge&logo=github)](https://github.com/sponsors/DarpanNeve)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-blue?style=for-the-badge&logo=paypal)](https://paypal.me/darpanneve)

Your support helps maintain and improve LockBloom. Thank you! ❤️

</div>

---

## 📞 Connect

<div align="center">

[![GitHub](https://img.shields.io/badge/GitHub-DarpanNeve-181717?style=for-the-badge&logo=github)](https://github.com/DarpanNeve)
[![Email](https://img.shields.io/badge/Email-darpanneve3@gmail.com-EA4335?style=for-the-badge&logo=gmail)](mailto:darpanneve3@gmail.com)
[![Play Store](https://img.shields.io/badge/Play_Store-LockBloom-414141?style=for-the-badge&logo=google-play)](https://play.google.com/store/apps/details?id=com.dn.lockbloom)

</div>

---

<div align="center">

**⚡ LockBloom - Your passwords, secured and simplified.**

Made with ❤️ by [Darpan Neve](https://github.com/DarpanNeve)

⭐ Star this repo if you find it helpful!

</div>
