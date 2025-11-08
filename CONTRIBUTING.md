# Contributing to LockBloom

Thank you for your interest in contributing to LockBloom! This document provides guidelines and instructions for contributing to the project.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Code Style Guidelines](#code-style-guidelines)
- [Security Guidelines](#security-guidelines)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Project Structure](#project-structure)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of experience level, gender, gender identity and expression, sexual orientation, disability, personal appearance, body size, race, ethnicity, age, religion, or nationality.

### Our Standards

**Examples of encouraged behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Examples of unacceptable behavior:**
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

---

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** ≥ 3.7.0 ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK** ≥ 3.0.0 (comes with Flutter)
- **Git** for version control
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Verify Installation

```bash
flutter doctor -v
```

This command checks your environment and displays a report of the status of your Flutter installation.

---

## Development Setup

### 1. Fork the Repository

Click the "Fork" button at the top right of the [LockBloom repository](https://github.com/DarpanNeve/lockbloom) to create your own copy.

### 2. Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/lockbloom.git
cd lockbloom
```

### 3. Add Upstream Remote

```bash
git remote add upstream https://github.com/DarpanNeve/lockbloom.git
```

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>
```

### 6. Platform-Specific Setup

<details>
<summary><b>Android Setup</b></summary>

**Biometric Permissions** (already configured):
```xml
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

**For Release Builds:**
You'll need your own signing key. Create `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=/path/to/your/keystore.jks
```

**Generate a keystore:**
```bash
keytool -genkey -v -keystore ~/lockbloom-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias lockbloom
```

</details>

<details>
<summary><b>iOS Setup</b></summary>

**Face ID Permissions** (already configured):
```xml
<key>NSFaceIDUsageDescription</key>
<string>Use Face ID to authenticate and access your passwords</string>
```

**For Development:**
- Open `ios/Runner.xcworkspace` in Xcode
- Select your development team
- Update bundle identifier if needed

</details>

---

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

1. **Bug Fixes**: Fix issues reported in GitHub Issues
2. **New Features**: Implement features from the roadmap or propose new ones
3. **Documentation**: Improve README, code comments, or documentation
4. **Tests**: Add unit tests, widget tests, or integration tests
5. **Performance**: Optimize existing code for better performance
6. **Security**: Enhance security measures or fix vulnerabilities

### Finding Issues to Work On

- Browse [GitHub Issues](https://github.com/DarpanNeve/lockbloom/issues)
- Look for issues labeled `good first issue` for beginners
- Check issues labeled `help wanted` for areas needing contribution

### Proposing New Features

Before implementing a major feature:

1. **Check existing issues** to avoid duplicates
2. **Open a new issue** describing:
   - The problem it solves
   - Proposed solution
   - Alternative approaches considered
   - Implementation plan
3. **Wait for feedback** from maintainers before starting work

---

## Code Style Guidelines

### Dart/Flutter Style

Follow the official [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide:

- **Style**: [Effective Dart: Style](https://dart.dev/guides/language/effective-dart/style)
- **Documentation**: [Effective Dart: Documentation](https://dart.dev/guides/language/effective-dart/documentation)
- **Usage**: [Effective Dart: Usage](https://dart.dev/guides/language/effective-dart/usage)
- **Design**: [Effective Dart: Design](https://dart.dev/guides/language/effective-dart/design)

### Code Formatting

**Always format your code before committing:**

```bash
# Format all Dart files
flutter format .

# Format specific file
flutter format lib/app/services/encryption_service.dart
```

### Linting

**Run the analyzer to check for issues:**

```bash
# Run analyzer
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

### Naming Conventions

- **Classes**: `PascalCase` (e.g., `PasswordController`, `EncryptionService`)
- **Functions/Variables**: `camelCase` (e.g., `generatePassword`, `isAuthenticated`)
- **Constants**: `lowerCamelCase` (e.g., `defaultTimeout`, `maxPasswordLength`)
- **Private members**: Prefix with `_` (e.g., `_encryptionKey`, `_validateInput()`)
- **File names**: `snake_case` (e.g., `password_controller.dart`, `encryption_service.dart`)

### Documentation

**Document all public APIs:**

```dart
/// Generates a cryptographically secure password.
///
/// The [length] must be between 8 and 64 characters.
/// Returns a [String] containing the generated password.
///
/// Throws [ArgumentError] if [length] is invalid.
String generatePassword({
  required int length,
  bool includeUppercase = true,
  bool includeLowercase = true,
  bool includeNumbers = true,
  bool includeSymbols = true,
}) {
  // Implementation
}
```

---

## Security Guidelines

### ⚠️ CRITICAL: Never Commit Sensitive Data

**DO NOT commit:**
- ❌ API keys, tokens, or secrets
- ❌ Service account files (`service_account.json`)
- ❌ Keystores or signing certificates (`.jks`, `.keystore`)
- ❌ Private keys (`.pem`, `.p12`, `.key`)
- ❌ Environment files with credentials (`.env`)
- ❌ Database credentials or connection strings

**Before committing, always check:**

```bash
# Review your changes
git diff

# Check for common secrets
git diff | grep -iE '(api[_-]?key|secret|password|token|credential|private[_-]?key)'
```

### Security Best Practices

When working on security-sensitive code:

1. **Encryption**:
   - Use `Random.secure()` for cryptographic operations
   - Never hardcode encryption keys
   - Use platform secure storage (Keystore/Keychain)

2. **Authentication**:
   - Implement constant-time comparisons for sensitive data
   - Use biometric authentication properly
   - Implement rate limiting for authentication attempts

3. **Memory Safety**:
   - Clear sensitive data from memory when not needed
   - Avoid logging sensitive information

4. **Input Validation**:
   - Validate all user inputs
   - Sanitize data before storage
   - Use parameterized queries if using databases

### Reporting Security Vulnerabilities

**DO NOT open public issues for security vulnerabilities.**

Instead, email: **darpanneve3@gmail.com** with:
- Detailed description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We will respond within 48 hours and work on a fix before public disclosure.

---

## Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) for clear commit history:

### Format

```
<type>: <subject>

<body (optional)>

<footer (optional)>
```

### Types

- **Add**: New feature or functionality
- **Fix**: Bug fix
- **Update**: Improvements to existing features
- **Refactor**: Code restructuring without functional changes
- **Docs**: Documentation changes
- **Test**: Adding or updating tests
- **Chore**: Maintenance tasks (dependencies, build, etc.)
- **Style**: Code formatting, no functional changes
- **Perf**: Performance improvements
- **Security**: Security-related changes

### Examples

```bash
# Good commits
Add: implement password strength meter
Fix: resolve biometric authentication crash on Android 14
Update: improve password generation algorithm performance
Refactor: extract encryption logic into separate service
Docs: update README with installation instructions
Test: add unit tests for encryption service
Security: implement constant-time PIN comparison

# Bad commits
fixed stuff
updated code
changes
WIP
```

### Subject Line Rules

- Use imperative mood ("Add feature" not "Added feature")
- First letter lowercase after type prefix
- No period at the end
- Keep under 72 characters

### Body (optional but recommended for complex changes)

- Explain **what** and **why**, not **how**
- Wrap at 72 characters
- Separate from subject with a blank line

### Example with Body

```
Fix: resolve race condition in password save operation

The password repository was not properly handling concurrent save
operations, leading to data corruption when multiple passwords were
saved simultaneously. This fix implements proper locking mechanism
using GetX reactive streams.

Fixes #123
```

---

## Pull Request Process

### Before Submitting

1. **Sync with upstream:**
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes** following the guidelines above

4. **Test your changes:**
   ```bash
   flutter test
   flutter analyze
   flutter format .
   ```

5. **Commit with clear messages:**
   ```bash
   git add .
   git commit -m "Add: your feature description"
   ```

6. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

### Submitting the PR

1. Go to the [LockBloom repository](https://github.com/DarpanNeve/lockbloom)
2. Click "New Pull Request"
3. Select your fork and branch
4. Fill out the PR template with:
   - **Description**: What does this PR do?
   - **Motivation**: Why is this change needed?
   - **Testing**: How was this tested?
   - **Screenshots**: For UI changes (before/after)
   - **Checklist**: Ensure all items are checked

### PR Title Format

Follow the same convention as commits:

```
Add: implement password strength meter
Fix: resolve biometric authentication crash on Android 14
Update: improve password generation performance
```

### Review Process

1. **Automated checks** will run (linting, tests)
2. **Maintainers will review** your code
3. **Address feedback** by pushing new commits
4. Once approved, your PR will be **merged**

### What Happens Next

- Your commits will be squashed into a single commit
- You'll be credited as a contributor
- Changes will be included in the next release

---

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/encryption_service_test.dart

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

```
test/
├── services/           # Service layer tests
│   ├── encryption_service_test.dart
│   └── biometric_service_test.dart
├── controllers/        # Controller tests
│   └── password_controller_test.dart
├── widgets/            # Widget tests
│   └── password_card_test.dart
└── integration_test/   # End-to-end tests
```

### Writing Tests

**Unit Test Example:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lockbloom/app/services/encryption_service.dart';

void main() {
  group('EncryptionService', () {
    late EncryptionService encryptionService;

    setUp(() {
      encryptionService = EncryptionService();
    });

    test('should encrypt and decrypt data correctly', () {
      const plaintext = 'my-secret-password';

      final encrypted = encryptionService.encrypt(plaintext);
      final decrypted = encryptionService.decrypt(encrypted);

      expect(decrypted, equals(plaintext));
    });

    test('should generate unique IVs for each encryption', () {
      const plaintext = 'test-password';

      final encrypted1 = encryptionService.encrypt(plaintext);
      final encrypted2 = encryptionService.encrypt(plaintext);

      expect(encrypted1, isNot(equals(encrypted2)));
    });
  });
}
```

### Test Coverage

- Aim for **70%+ coverage** for new code
- Focus on **critical paths** (encryption, authentication)
- Test **edge cases** and **error handling**

---

## Project Structure

Understanding the codebase architecture:

```
lockbloom/
├── lib/
│   ├── app/
│   │   ├── controllers/          # GetX controllers (state management)
│   │   │   ├── auth_controller.dart
│   │   │   ├── password_controller.dart
│   │   │   └── settings_controller.dart
│   │   ├── data/
│   │   │   └── models/           # Data models
│   │   │       └── password_entry.dart
│   │   ├── modules/              # Feature modules (views)
│   │   │   ├── home/
│   │   │   ├── password_detail/
│   │   │   └── settings/
│   │   ├── repositories/         # Data repositories
│   │   │   └── password_repository.dart
│   │   ├── routes/               # App routing
│   │   │   └── app_routes.dart
│   │   ├── services/             # Business logic services
│   │   │   ├── encryption_service.dart
│   │   │   └── biometric_service.dart
│   │   └── widgets/              # Reusable widgets
│   ├── config/                   # App configuration
│   │   └── theme.dart
│   ├── firebase_options.dart     # Firebase configuration
│   └── main.dart                 # App entry point
├── android/                      # Android native code
├── ios/                          # iOS native code
├── assets/                       # Images, fonts, etc.
│   └── images/
├── test/                         # Unit & widget tests
├── integration_test/             # Integration tests
└── deploy/                       # Deployment scripts
```

### Architecture Layers

1. **UI Layer** (`modules/`): Flutter widgets and views
2. **Controller Layer** (`controllers/`): GetX controllers for state management
3. **Service Layer** (`services/`): Business logic (encryption, biometrics)
4. **Repository Layer** (`repositories/`): Data access and storage
5. **Model Layer** (`data/models/`): Data structures

### Key Technologies

- **State Management**: GetX
- **Routing**: GetX navigation
- **Dependency Injection**: GetX bindings
- **Encryption**: `encrypt` + `pointycastle`
- **Secure Storage**: `flutter_secure_storage`
- **Biometric Auth**: `local_auth`

---

## Building for Release

### Android

```bash
# Build App Bundle (for Play Store)
flutter build appbundle --release

# Build APK (for direct installation)
flutter build apk --release --split-per-abi
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Create IPA
flutter build ipa --release
```

---

## Getting Help

### Resources

- **Flutter Docs**: [https://docs.flutter.dev](https://docs.flutter.dev)
- **GetX Docs**: [https://github.com/jonataslaw/getx](https://github.com/jonataslaw/getx)
- **Effective Dart**: [https://dart.dev/guides/language/effective-dart](https://dart.dev/guides/language/effective-dart)

### Communication

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Email**: darpanneve3@gmail.com for private inquiries

---

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes
- Project acknowledgments

Top contributors may be invited to become maintainers.

---

## Thank You!

Your contributions make LockBloom better for everyone. We appreciate your time and effort in improving this project!

**Happy coding! 🚀**

---

*Last updated: November 2025*
