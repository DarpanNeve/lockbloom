import 'dart:math';
import 'package:get/get.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';

class PasswordService extends GetxService {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _symbols = '!@#\$%^&*';
  static const String _ambiguous = '0O1lI';
  static const String _similar = 'il1Lo0O';

  // Pre-filtered character sets
  static const String _lowercaseNoAmbiguous = 'abcdefghijkmnopqrstvwxyz'; // 'l' removed
  static const String _lowercaseNoSimilar = 'abcdefghjkmnpqrstvwxyz'; // 'i', 'l', 'o' removed
  static const String _uppercaseNoAmbiguous = 'ABCDEFGHJKMNPQRSTVWXYZ'; // 'I', 'L', 'O' removed
  static const String _uppercaseNoSimilar = 'ABCDEFGHJKMNPQRSTVWXYZ'; // 'I', 'L', 'O' removed
  static const String _numbersNoAmbiguous = '23456789'; // '0', '1' removed
  static const String _numbersNoSimilar = '23456789'; // '0', '1' removed

  /// Generate a password based on configuration
  String generatePassword(PasswordGeneratorConfig config) {
    if (config.pronounceable) {
      return _generatePronounceablePassword(config.length);
    }
    
    if (!config.includeUppercase && !config.includeLowercase && 
        !config.includeNumbers && !config.includeSymbols) {
      throw PasswordGenerationException('At least one character type must be selected');
    }

    var charset = '';

    if (config.includeUppercase) {
      charset += config.excludeAmbiguous
          ? _uppercaseNoAmbiguous
          : config.excludeSimilar
              ? _uppercaseNoSimilar
              : _uppercase;
    }

    if (config.includeLowercase) {
      charset += config.excludeAmbiguous
          ? _lowercaseNoAmbiguous
          : config.excludeSimilar
              ? _lowercaseNoSimilar
              : _lowercase;
    }

    if (config.includeNumbers) {
      charset += config.excludeAmbiguous
          ? _numbersNoAmbiguous
          : config.excludeSimilar
              ? _numbersNoSimilar
              : _numbers;
    }

    if (config.includeSymbols) {
      charset += _symbols;
    }

    if (charset.isEmpty) {
      throw PasswordGenerationException('Character set is empty with current settings');
    }

    return _generateRandomPassword(charset, config.length, config);
  }

  /// Generate a random password
  String _generateRandomPassword(
    String charset,
    int length,
    PasswordGeneratorConfig config,
  ) {
    final random = Random.secure();
    final password = StringBuffer();

    // Ensure at least one character from each required set
    final requiredSets = <String>[];
    if (config.includeLowercase) requiredSets.add(_lowercase);
    if (config.includeUppercase) requiredSets.add(_uppercase);
    if (config.includeNumbers) requiredSets.add(_numbers);
    if (config.includeSymbols) requiredSets.add(_symbols);

    // Add one character from each required set
    for (final set in requiredSets) {
      if (password.length < length) {
        String validChars = set;
        if (config.excludeAmbiguous) {
          for (String char in _ambiguous.split('')) {
            validChars = validChars.replaceAll(char, '');
          }
        }
        if (config.excludeSimilar) {
          for (String char in _similar.split('')) {
            validChars = validChars.replaceAll(char, '');
          }
        }
        if (validChars.isNotEmpty) {
          password.write(validChars[random.nextInt(validChars.length)]);
        }
      }
    }

    // Fill remaining length with random characters
    while (password.length < length) {
      password.write(charset[random.nextInt(charset.length)]);
    }

    // Shuffle the password
    final passwordList = password.toString().split('');
    for (int i = passwordList.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = passwordList[i];
      passwordList[i] = passwordList[j];
      passwordList[j] = temp;
    }

    return passwordList.join('');
  }

  /// Generate a pronounceable password
  String _generatePronounceablePassword(int length) {
    const consonants = 'bcdfghjklmnpqrstvwxyz';
    const vowels = 'aeiou';
    final random = Random.secure();
    final password = StringBuffer();

    bool useConsonant = random.nextBool();

    while (password.length < length) {
      if (useConsonant) {
        password.write(consonants[random.nextInt(consonants.length)]);
      } else {
        password.write(vowels[random.nextInt(vowels.length)]);
      }
      useConsonant = !useConsonant;
    }

    // Capitalize randomly
    final result = password.toString();
    if (random.nextBool() && result.isNotEmpty) {
      return result[0].toUpperCase() + result.substring(1);
    }

    return result;
  }

  /// Calculate password strength
  PasswordStrength calculateStrength(String password) {
    if (password.isEmpty) {
      return const PasswordStrength(
        score: 0,
        entropy: 0.0,
        feedback: 'Password cannot be empty',
        suggestions: ['Enter a password'],
      );
    }

    int charsetSize = 0;
    bool hasLowercase = false;
    bool hasUppercase = false;
    bool hasNumbers = false;
    bool hasSymbols = false;

    for (int i = 0; i < password.length; i++) {
      final char = password[i];
      if (_lowercase.contains(char) && !hasLowercase) {
        charsetSize += _lowercase.length;
        hasLowercase = true;
      } else if (_uppercase.contains(char) && !hasUppercase) {
        charsetSize += _uppercase.length;
        hasUppercase = true;
      } else if (_numbers.contains(char) && !hasNumbers) {
        charsetSize += _numbers.length;
        hasNumbers = true;
      } else if (_symbols.contains(char) && !hasSymbols) {
        charsetSize += _symbols.length;
        hasSymbols = true;
      }
    }

    // Calculate entropy
    final entropy = password.length * (log(charsetSize) / log(2));

    // Determine score and feedback
    int score;
    String feedback;
    List<String> suggestions = [];

    if (entropy < 28) {
      score = 1;
      feedback = 'Very weak';
      suggestions.add('Use a longer password');
    } else if (entropy < 35) {
      score = 2;
      feedback = 'Weak';
      suggestions.add('Add more character types');
    } else if (entropy < 59) {
      score = 3;
      feedback = 'Fair';
      suggestions.add('Consider using symbols');
    } else if (entropy < 127) {
      score = 4;
      feedback = 'Strong';
    } else {
      score = 5;
      feedback = 'Very strong';
    }

    // Add specific suggestions
    if (!hasUppercase) suggestions.add('Add uppercase letters');
    if (!hasLowercase) suggestions.add('Add lowercase letters');
    if (!hasNumbers) suggestions.add('Add numbers');
    if (!hasSymbols) suggestions.add('Add symbols');
    if (password.length < 12) suggestions.add('Use at least 12 characters');

    return PasswordStrength(
      score: score,
      entropy: entropy,
      feedback: feedback,
      suggestions: suggestions,
    );
  }

  double log10(num x) {
    if (x == 0) return 0;
    return log(x) / ln10;
  }

  double get ln10 => 2.302585092994046;
}

class PasswordGenerationException implements Exception {
  final String message;
  PasswordGenerationException(this.message);
  
  @override
  String toString() => 'PasswordGenerationException: $message';
}
