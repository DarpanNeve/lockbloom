import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/repositories/password_repository.dart';
import 'package:lockbloom/app/services/encryption_service.dart';
import 'package:lockbloom/app/services/password_service.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordController extends GetxController {
  final PasswordRepository _repository = Get.find();
  final PasswordService _passwordService = Get.find();
  final EncryptionService _encryptionService = Get.find();

  // Observable variables
  final passwords = <PasswordEntry>[].obs;
  final filteredPasswords = <PasswordEntry>[].obs;
  final generatorConfig = const PasswordGeneratorConfig().obs;
  final generatedPassword = ''.obs;
  final passwordStrength =
      const PasswordStrength(
        score: 0,
        entropy: 0.0,
        feedback: '',
        suggestions: [],
      ).obs;
  final searchQuery = ''.obs;
  final selectedTags = <String>[].obs;
  final isLoading = false.obs;
  final showPassword = false.obs;

  // Form controllers
  final labelController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final websiteController = TextEditingController();
  final notesController = TextEditingController();
  final tagsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadPasswords();
    generatePassword();

    // Listen to search query changes
    debounce(
      searchQuery,
      (_) => _filterPasswords(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    labelController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    notesController.dispose();
    tagsController.dispose();
    super.onClose();
  }

  /// Load all passwords
  Future<void> loadPasswords() async {
    print('PasswordController: loadPasswords called.');
    isLoading.value = true;
    try {
      final loadedPasswords = await _repository.getAllPasswords();
      print(
        'PasswordController: Loaded ${loadedPasswords.length} passwords from repository.',
      );
      passwords.value = loadedPasswords;
      _filterPasswords();
      print('PasswordController: Passwords loaded and filtered.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load passwords: ${e.toString()}');
      print('PasswordController: Error loading passwords: $e');
    } finally {
      isLoading.value = false;
      print('PasswordController: isLoading set to false.');
    }
  }

  /// Generate a new password
  void generatePassword() {
    try {
      final password = _passwordService.generatePassword(generatorConfig.value);
      generatedPassword.value = password;
      passwordStrength.value = _passwordService.calculateStrength(password);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to generate password: ${e.toString()}',
      );
    }
  }

  /// Update generator configuration
  void updateGeneratorConfig(PasswordGeneratorConfig config) {
    generatorConfig.value = config;
    generatePassword();
  }

  /// Save a password entry
  Future<void> savePassword({
    String? id,
    required String label,
    required String username,
    required String password,
    String? website,
    String? notes,
    List<String>? tags,
  }) async {
    if (label.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Label is required');
      return;
    }

    if (password.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Password is required');
      return;
    }

    isLoading.value = true;
    try {
      // Encrypt the password
      final encryptedPassword = _encryptionService.encrypt(password);

      final entry = PasswordEntry(
        id: id ?? const Uuid().v4(),
        label: label.trim(),
        username: username.trim(),
        encryptedPassword: encryptedPassword,
        website: website?.trim(),
        notes: notes?.trim() ?? '',
        tags: tags ?? [],
        createdAt: id == null ? DateTime.now() : DateTime.now(),
        // Will be updated in repository
        updatedAt: DateTime.now(),
      );

      await _repository.savePassword(entry);
      await loadPasswords();

      Fluttertoast.showToast(
        msg: id == null ? 'Password saved' : 'Password updated',
      );
      _clearForm();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to save password: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a password entry
  Future<void> deletePassword(String id) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Password'),
        content: const Text(
          'Are you sure you want to delete this password? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      isLoading.value = true;
      try {
        await _repository.deletePassword(id);
        await loadPasswords();
        Fluttertoast.showToast(msg: 'Password deleted');
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Failed to delete password: ${e.toString()}',
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Get decrypted password
  String getDecryptedPassword(PasswordEntry entry) {
    try {
      return _encryptionService.decrypt(entry.encryptedPassword);
    } catch (e) {
      return 'Failed to decrypt';
    }
  }

  /// Copy password to clipboard
  Future<void> copyPassword(PasswordEntry entry) async {
    try {
      final password = getDecryptedPassword(entry);
      await Clipboard.setData(ClipboardData(text: password));
      Fluttertoast.showToast(msg: 'Password copied to clipboard');

      // Clear clipboard after 30 seconds for security
      Future.delayed(const Duration(seconds: 30), () {
        Clipboard.setData(const ClipboardData(text: ''));
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to copy password');
    }
  }

  /// Copy username to clipboard
  Future<void> copyUsername(PasswordEntry entry) async {
    try {
      await Clipboard.setData(ClipboardData(text: entry.username));
      Fluttertoast.showToast(msg: 'Username copied to clipboard');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to copy username');
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(PasswordEntry entry) async {
    try {
      final updatedEntry = entry.copyWith(isFavorite: !entry.isFavorite);
      await _repository.savePassword(updatedEntry);
      await loadPasswords();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update favorite status');
    }
  }

  /// Search passwords
  void searchPasswords(String query) {
    searchQuery.value = query;
  }

  /// Filter passwords by tags
  void filterByTags(List<String> tags) {
    selectedTags.value = tags;
    _filterPasswords();
  }

  /// Filter passwords based on search query and selected tags
  void _filterPasswords() {
    print('PasswordController: _filterPasswords called.');
    print('  searchQuery: ${searchQuery.value}');
    print('  selectedTags: ${selectedTags.value}');
    print('  Total passwords: ${passwords.length}');

    var filtered = passwords.toList();

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered =
          filtered
              .where(
                (p) =>
                    p.label.toLowerCase().contains(query) ||
                    p.username.toLowerCase().contains(query) ||
                    p.website?.toLowerCase().contains(query) == true ||
                    p.notes.toLowerCase().contains(query) ||
                    p.tags.any((tag) => tag.toLowerCase().contains(query)),
              )
              .toList();
    }

    // Filter by selected tags
    if (selectedTags.isNotEmpty) {
      filtered =
          filtered
              .where(
                (p) => selectedTags.value.any((tag) => p.tags.contains(tag)),
              )
              .toList();
    }

    filteredPasswords.value = filtered;
    print('  Filtered passwords count: ${filteredPasswords.length}');
  }

  /// Get all unique tags
  List<String> getAllTags() {
    final allTags = <String>{};
    for (final password in passwords) {
      allTags.addAll(password.tags);
    }
    return allTags.toList()..sort();
  }

  /// Load password for editing
  void loadPasswordForEdit(PasswordEntry entry) {
    labelController.text = entry.label;
    usernameController.text = entry.username;
    passwordController.text = getDecryptedPassword(entry);
    websiteController.text = entry.website ?? '';
    notesController.text = entry.notes;
    tagsController.text = entry.tags.join(', ');
  }

  /// Clear form
  void _clearForm() {
    labelController.clear();
    usernameController.clear();
    passwordController.clear();
    websiteController.clear();
    notesController.clear();
    tagsController.clear();
  }

  /// Use generated password in form
  void useGeneratedPassword() {
    passwordController.text = generatedPassword.value;
  }

  /// Calculate password strength for manual input
  void calculatePasswordStrength(String password) {
    passwordStrength.value = _passwordService.calculateStrength(password);
  }

  /// Export passwords
  Future<void> exportPasswords() async {
    try {
      final exportData = await _repository.exportPasswords('export_password');
      // In a real app, you would save this to a file or share it
      await Clipboard.setData(ClipboardData(text: exportData));
      Fluttertoast.showToast(msg: 'Passwords exported to clipboard');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to export passwords: ${e.toString()}',
      );
    }
  }

  /// Get password statistics
  Future<Map<String, dynamic>> getPasswordStats() async {
    return await _repository.getPasswordStats();
  }
}
