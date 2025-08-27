import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/services/biometric_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordDetailView extends StatefulWidget {
  const PasswordDetailView({super.key});

  @override
  State<PasswordDetailView> createState() => _PasswordDetailViewState();
}

class _PasswordDetailViewState extends State<PasswordDetailView> {
  final PasswordController _passwordController = Get.find();
  final BiometricService _biometricService = Get.find();
  
  late PasswordEntry entry;
  bool isPasswordRevealed = false;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    entry = Get.arguments as PasswordEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.label),
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: _toggleEdit,
              icon: const Icon(Icons.edit_rounded),
            ),
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: ListTile(
                  leading: Icon(Icons.copy_rounded),
                  title: Text('Duplicate'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_rounded, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: isEditing ? _buildEditForm(context) : _buildDetailView(context),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Card with Favorite
        Card(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Icon or Avatar
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getEntryIcon(),
                    size: 30.w,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                // Title and Website
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.label,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (entry.website?.isNotEmpty == true) ...[
                        SizedBox(height: 4.h),
                        Text(
                          entry.website!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Favorite Button
                IconButton(
                  onPressed: () {
                    _passwordController.toggleFavorite(entry);
                    setState(() {
                      entry = entry.copyWith(isFavorite: !entry.isFavorite);
                    });
                  },
                  icon: Icon(
                    entry.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: entry.isFavorite ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Username Field
        _buildDetailField(
          context,
          label: 'Username',
          value: entry.username,
          icon: Icons.person_outline,
          canCopy: true,
          onCopy: () => _passwordController.copyUsername(entry),
        ),
        
        SizedBox(height: 16.h),
        
        // Password Field
        _buildPasswordField(context),
        
        SizedBox(height: 16.h),
        
        // Website Field
        if (entry.website?.isNotEmpty == true) ...[
          _buildDetailField(
            context,
            label: 'Website',
            value: entry.website!,
            icon: Icons.web,
            canCopy: true,
          ),
          SizedBox(height: 16.h),
        ],
        
        // Tags
        if (entry.tags.isNotEmpty) ...[
          _buildTagsField(context),
          SizedBox(height: 16.h),
        ],
        
        // Notes Field
        if (entry.notes.isNotEmpty) ...[
          _buildDetailField(
            context,
            label: 'Notes',
            value: entry.notes,
            icon: Icons.note_outlined,
            maxLines: null,
          ),
          SizedBox(height: 16.h),
        ],
        
        // Timestamps
        _buildTimestampsCard(context),
      ],
    );
  }

  Widget _buildEditForm(BuildContext context) {
    // Initialize form controllers
    _passwordController.loadPasswordForEdit(entry);
    
    return Column(
      children: [
        TextField(
          controller: _passwordController.labelController,
          decoration: const InputDecoration(
            labelText: 'Label *',
            prefixIcon: Icon(Icons.label_outline),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        TextField(
          controller: _passwordController.usernameController,
          decoration: const InputDecoration(
            labelText: 'Username/Email *',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        TextField(
          controller: _passwordController.passwordController,
          decoration: InputDecoration(
            labelText: 'Password *',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _passwordController.useGeneratedPassword,
                  icon: const Icon(Icons.auto_awesome),
                  tooltip: 'Generate Password',
                ),
                Obx(() => IconButton(
                  onPressed: () => _passwordController.showPassword.toggle(),
                  icon: Icon(
                    _passwordController.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                )),
              ],
            ),
          ),
          obscureText: !_passwordController.showPassword.value,
        ),
        
        SizedBox(height: 16.h),
        
        TextField(
          controller: _passwordController.websiteController,
          decoration: const InputDecoration(
            labelText: 'Website',
            prefixIcon: Icon(Icons.web),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        TextField(
          controller: _passwordController.tagsController,
          decoration: const InputDecoration(
            labelText: 'Tags (comma separated)',
            prefixIcon: Icon(Icons.tag),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        TextField(
          controller: _passwordController.notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            prefixIcon: Icon(Icons.note_outlined),
          ),
          maxLines: 3,
        ),
        
        SizedBox(height: 32.h),
        
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelEdit,
                child: const Text('Cancel'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool canCopy = false,
    VoidCallback? onCopy,
    int? maxLines = 1,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (canCopy)
                  IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy_rounded),
                    iconSize: 18.w,
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 20.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _revealPassword,
                  icon: Icon(
                    isPasswordRevealed ? Icons.visibility_off : Icons.visibility,
                  ),
                  iconSize: 18.w,
                ),
                IconButton(
                  onPressed: () => _passwordController.copyPassword(entry),
                  icon: const Icon(Icons.copy_rounded),
                  iconSize: 18.w,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              isPasswordRevealed
                  ? _passwordController.getDecryptedPassword(entry)
                  : '••••••••••••',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'monospace',
                letterSpacing: isPasswordRevealed ? 0 : 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsField(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tag,
                  size: 20.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: entry.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampsCard(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y \'at\' h:mm a');
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20.w,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'History',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        dateFormat.format(entry.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Modified',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        dateFormat.format(entry.updatedAt),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEntryIcon() {
    final website = entry.website?.toLowerCase() ?? '';
    if (website.contains('google') || website.contains('gmail')) {
      return Icons.mail;
    } else if (website.contains('facebook')) {
      return Icons.facebook;
    } else if (website.contains('twitter')) {
      return Icons.alternate_email;
    } else if (website.contains('github')) {
      return Icons.code;
    } else if (website.contains('linkedin')) {
      return Icons.work;
    } else {
      return Icons.web;
    }
  }

  Future<void> _revealPassword() async {
    print('PasswordDetailView: _revealPassword called. isPasswordRevealed: $isPasswordRevealed');

    if (isPasswordRevealed) {
      setState(() {
        isPasswordRevealed = false;
      });
      print('PasswordDetailView: Password already revealed, hiding it.');
      return;
    }

    print('PasswordDetailView: Checking biometric availability and enablement.');
    // Check if biometric is available and enabled
    final bool biometricAvailable = await _biometricService.isAvailable();
    final bool biometricEnabledInApp = await _biometricService.isBiometricEnabledInApp();
    print('PasswordDetailView: Biometric available: $biometricAvailable, enabled in app: $biometricEnabledInApp');

    if (biometricAvailable && biometricEnabledInApp) {
      print('PasswordDetailView: Attempting biometric authentication.');
      final authenticated = await _biometricService.authenticate(
        localizedReason: 'Authenticate to reveal password',
      );

      if (authenticated) {
        setState(() {
          isPasswordRevealed = true;
        });
        print('PasswordDetailView: Biometric authentication successful. Password revealed.');

        // Auto-hide password after 30 seconds
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted) {
            setState(() {
              isPasswordRevealed = false;
            });
            print('PasswordDetailView: Auto-hiding password after 30 seconds.');
          }
        });
      } else {
        print('PasswordDetailView: Biometric authentication failed.');
      }
    } else {
      print('PasswordDetailView: Biometric not available or not enabled in app. Showing confirmation dialog.');
      // Show confirmation dialog if biometric is not available
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Reveal Password'),
          content: const Text('Are you sure you want to reveal the password?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Reveal'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() {
          isPasswordRevealed = true;
        });
        print('PasswordDetailView: Confirmation received. Password revealed.');

        // Auto-hide password after 30 seconds
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted) {
            setState(() {
              isPasswordRevealed = false;
            });
            print('PasswordDetailView: Auto-hiding password after 30 seconds.');
          }
        });
      } else {
        print('PasswordDetailView: Confirmation denied. Password not revealed.');
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
    });
    // Clear form controllers
    _passwordController.labelController.clear();
    _passwordController.usernameController.clear();
    _passwordController.passwordController.clear();
    _passwordController.websiteController.clear();
    _passwordController.notesController.clear();
    _passwordController.tagsController.clear();
  }

  void _saveChanges() {
    final tags = _passwordController.tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    
    _passwordController.savePassword(
      id: entry.id,
      label: _passwordController.labelController.text,
      username: _passwordController.usernameController.text,
      password: _passwordController.passwordController.text,
      website: _passwordController.websiteController.text,
      notes: _passwordController.notesController.text,
      tags: tags,
    );
    
    // Update local entry
    setState(() {
      entry = entry.copyWith(
        label: _passwordController.labelController.text,
        username: _passwordController.usernameController.text,
        website: _passwordController.websiteController.text,
        notes: _passwordController.notesController.text,
        tags: tags,
        updatedAt: DateTime.now(),
      );
      isEditing = false;
    });
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'duplicate':
        _duplicateEntry();
        break;
      case 'delete':
        _deleteEntry();
        break;
    }
  }

  void _duplicateEntry() {
    _passwordController.savePassword(
      label: '${entry.label} (Copy)',
      username: entry.username,
      password: _passwordController.getDecryptedPassword(entry),
      website: entry.website,
      notes: entry.notes,
      tags: entry.tags,
    );
    Fluttertoast.showToast(msg: 'Password duplicated');
  }

  void _deleteEntry() {
    _passwordController.deletePassword(entry.id);
    Get.back();
  }
}