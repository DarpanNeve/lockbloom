class PasswordEntry {
  final String id;
  final String label;
  final String username;
  final String encryptedPassword;
  final List<String> tags;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? website;
  final String? iconUrl;
  final bool isFavorite;

  const PasswordEntry({
    required this.id,
    required this.label,
    required this.username,
    required this.encryptedPassword,
    required this.tags,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.website,
    this.iconUrl,
    this.isFavorite = false,
  });

  PasswordEntry copyWith({
    String? id,
    String? label,
    String? username,
    String? encryptedPassword,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? website,
    String? iconUrl,
    bool? isFavorite,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      label: label ?? this.label,
      username: username ?? this.username,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      website: website ?? this.website,
      iconUrl: iconUrl ?? this.iconUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'username': username,
      'encryptedPassword': encryptedPassword,
      'tags': tags,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'website': website,
      'iconUrl': iconUrl,
      'isFavorite': isFavorite,
    };
  }

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'] as String,
      label: json['label'] as String,
      username: json['username'] as String,
      encryptedPassword: json['encryptedPassword'] as String,
      tags: List<String>.from(json['tags'] as List),
      notes: json['notes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      website: json['website'] as String?,
      iconUrl: json['iconUrl'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordEntry &&
        other.id == id &&
        other.label == label &&
        other.username == username &&
        other.encryptedPassword == encryptedPassword &&
        _listEquals(other.tags, tags) &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.website == website &&
        other.iconUrl == iconUrl &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      label,
      username,
      encryptedPassword,
      Object.hashAll(tags),
      notes,
      createdAt,
      updatedAt,
      website,
      iconUrl,
      isFavorite,
    );
  }

  @override
  String toString() {
    return 'PasswordEntry(id: $id, label: $label, username: $username, '
        'tags: $tags, notes: $notes, createdAt: $createdAt, '
        'updatedAt: $updatedAt, website: $website, iconUrl: $iconUrl, '
        'isFavorite: $isFavorite)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

class PasswordStrength {
  final int score;
  final double entropy;
  final String feedback;
  final List<String> suggestions;

  const PasswordStrength({
    required this.score,
    required this.entropy,
    required this.feedback,
    required this.suggestions,
  });

  PasswordStrength copyWith({
    int? score,
    double? entropy,
    String? feedback,
    List<String>? suggestions,
  }) {
    return PasswordStrength(
      score: score ?? this.score,
      entropy: entropy ?? this.entropy,
      feedback: feedback ?? this.feedback,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'entropy': entropy,
      'feedback': feedback,
      'suggestions': suggestions,
    };
  }

  factory PasswordStrength.fromJson(Map<String, dynamic> json) {
    return PasswordStrength(
      score: json['score'] as int,
      entropy: json['entropy'] as double,
      feedback: json['feedback'] as String,
      suggestions: List<String>.from(json['suggestions'] as List),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordStrength &&
        other.score == score &&
        other.entropy == entropy &&
        other.feedback == feedback &&
        _listEquals(other.suggestions, suggestions);
  }

  @override
  int get hashCode {
    return Object.hash(
      score,
      entropy,
      feedback,
      Object.hashAll(suggestions),
    );
  }

  @override
  String toString() {
    return 'PasswordStrength(score: $score, entropy: $entropy, '
        'feedback: $feedback, suggestions: $suggestions)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

class PasswordGeneratorConfig {
  final int length;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSymbols;
  final bool excludeAmbiguous;
  final bool excludeSimilar;
  final bool pronounceable;

  const PasswordGeneratorConfig({
    this.length = 16,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
    this.excludeAmbiguous = true,
    this.excludeSimilar = false,
    this.pronounceable = false,
  });

  PasswordGeneratorConfig copyWith({
    int? length,
    bool? includeUppercase,
    bool? includeLowercase,
    bool? includeNumbers,
    bool? includeSymbols,
    bool? excludeAmbiguous,
    bool? excludeSimilar,
    bool? pronounceable,
  }) {
    return PasswordGeneratorConfig(
      length: length ?? this.length,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSymbols: includeSymbols ?? this.includeSymbols,
      excludeAmbiguous: excludeAmbiguous ?? this.excludeAmbiguous,
      excludeSimilar: excludeSimilar ?? this.excludeSimilar,
      pronounceable: pronounceable ?? this.pronounceable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'includeUppercase': includeUppercase,
      'includeLowercase': includeLowercase,
      'includeNumbers': includeNumbers,
      'includeSymbols': includeSymbols,
      'excludeAmbiguous': excludeAmbiguous,
      'excludeSimilar': excludeSimilar,
      'pronounceable': pronounceable,
    };
  }

  factory PasswordGeneratorConfig.fromJson(Map<String, dynamic> json) {
    return PasswordGeneratorConfig(
      length: json['length'] as int? ?? 16,
      includeUppercase: json['includeUppercase'] as bool? ?? true,
      includeLowercase: json['includeLowercase'] as bool? ?? true,
      includeNumbers: json['includeNumbers'] as bool? ?? true,
      includeSymbols: json['includeSymbols'] as bool? ?? true,
      excludeAmbiguous: json['excludeAmbiguous'] as bool? ?? true,
      excludeSimilar: json['excludeSimilar'] as bool? ?? false,
      pronounceable: json['pronounceable'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordGeneratorConfig &&
        other.length == length &&
        other.includeUppercase == includeUppercase &&
        other.includeLowercase == includeLowercase &&
        other.includeNumbers == includeNumbers &&
        other.includeSymbols == includeSymbols &&
        other.excludeAmbiguous == excludeAmbiguous &&
        other.excludeSimilar == excludeSimilar &&
        other.pronounceable == pronounceable;
  }

  @override
  int get hashCode {
    return Object.hash(
      length,
      includeUppercase,
      includeLowercase,
      includeNumbers,
      includeSymbols,
      excludeAmbiguous,
      excludeSimilar,
      pronounceable,
    );
  }

  @override
  String toString() {
    return 'PasswordGeneratorConfig(length: $length, '
        'includeUppercase: $includeUppercase, '
        'includeLowercase: $includeLowercase, '
        'includeNumbers: $includeNumbers, '
        'includeSymbols: $includeSymbols, '
        'excludeAmbiguous: $excludeAmbiguous, '
        'excludeSimilar: $excludeSimilar, '
        'pronounceable: $pronounceable)';
  }
}