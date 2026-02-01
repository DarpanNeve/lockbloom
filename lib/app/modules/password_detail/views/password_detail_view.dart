import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/controllers/auth_controller.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/services/biometric_service.dart';
import 'package:lockbloom/app/services/encryption_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class PasswordDetailView extends StatefulWidget {
  const PasswordDetailView({super.key});

  @override
  State<PasswordDetailView> createState() => _PasswordDetailViewState();
}

class _PasswordDetailViewState extends State<PasswordDetailView> {
  final PasswordController _passwordController = Get.find();
  final BiometricService _biometricService = Get.find();
  final AuthController _authController = Get.find();
  
  late PasswordEntry entry;
  bool isPasswordRevealed = false;
  bool isEditing = false;
  bool _formInitialized = false;
  Future<void>? _revealTimeout;

  @override
  void initState() {
    super.initState();
    entry = Get.arguments as PasswordEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit_password'.tr : 'details'.tr),
        centerTitle: true,
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: _toggleEdit,
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'edit'.tr,
            ),
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy_rounded, color: Theme.of(context).colorScheme.onSurface, size: 20),
                    SizedBox(width: 12.w),
                    Text('duplicate'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error, size: 20),
                    SizedBox(width: 12.w),
                    Text('delete'.tr, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd.w),
        child: isEditing ? _buildEditForm(context) : _buildDetailView(context),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderCard(context),
        SizedBox(height: 24.h),
        _buildSectionHeader(context, 'credentials'.tr),
        _buildDetailField(
          context,
          label: 'username'.tr,
          value: entry.username,
          icon: Icons.person_rounded,
          canCopy: true,
          onCopy: () => _passwordController.copyUsername(entry),
        ),
        SizedBox(height: 12.h),
        _buildPasswordField(context),
        if (entry.website?.isNotEmpty == true) ...[
          SizedBox(height: 12.h),
          _buildDetailField(
            context,
            label: 'website'.tr,
            value: entry.website!,
            icon: Icons.language_rounded,
            canCopy: true,
          ),
        ],
        SizedBox(height: 24.h),
        if (entry.tags.isNotEmpty) ...[
          _buildSectionHeader(context, 'tags'.tr),
          _buildTagsField(context),
          SizedBox(height: 24.h),
        ],
        if (entry.notes.isNotEmpty) ...[
          _buildSectionHeader(context, 'notes'.tr),
          _buildDetailField(
            context,
            label: 'notes'.tr,
            value: entry.notes,
            icon: Icons.notes_rounded,
            maxLines: null,
          ),
          SizedBox(height: 24.h),
        ],
        _buildSectionHeader(context, 'history'.tr),
        _buildTimestampsCard(context),
        SizedBox(height: 48.h),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getEntryIcon(),
              size: 32.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (entry.website?.isNotEmpty == true) ...[
                  SizedBox(height: 4.h),
                  Text(
                    entry.website!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _passwordController.toggleFavorite(entry);
              setState(() {
                entry = entry.copyWith(isFavorite: !entry.isFavorite);
              });
            },
            style: IconButton.styleFrom(
              backgroundColor: entry.isFavorite 
                  ? AppColors.errorColor.withValues(alpha: 0.1) 
                  : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            icon: Icon(
              entry.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: entry.isFavorite ? AppColors.errorColor : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    if (!_formInitialized) {
      _passwordController.loadPasswordForEdit(entry);
      _formInitialized = true;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _passwordController.labelController,
          decoration: InputDecoration(
            labelText: '${'title'.tr} *',
            prefixIcon: const Icon(Icons.label_outline_rounded),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: _passwordController.usernameController,
          decoration: InputDecoration(
            labelText: '${'username'.tr} *',
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: _passwordController.passwordController,
          decoration: InputDecoration(
            labelText: '${'password'.tr} *',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _passwordController.useGeneratedPassword,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  tooltip: 'generate_password'.tr,
                ),
                Obx(() => IconButton(
                  onPressed: () => _passwordController.showPassword.toggle(),
                  icon: Icon(
                    _passwordController.showPassword.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
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
          decoration: InputDecoration(
            labelText: 'website'.tr,
            prefixIcon: const Icon(Icons.language_rounded),
          ),
          keyboardType: TextInputType.url,
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: _passwordController.tagsController,
          decoration: InputDecoration(
            labelText: '${'tags'.tr} (comma separated)',
            prefixIcon: const Icon(Icons.tag_rounded),
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: _passwordController.notesController,
          decoration: InputDecoration(
            labelText: 'notes'.tr,
            prefixIcon: const Icon(Icons.note_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
        ),
        SizedBox(height: 32.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelEdit,
                child: Text('cancel'.tr),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text('save_changes'.tr),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
           color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: maxLines == null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22.w, color: Theme.of(context).colorScheme.onSurfaceVariant),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (maxLines == null) ...[
                   Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: maxLines,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                ),
              ],
            ),
          ),
          if (canCopy)
            IconButton(
              onPressed: onCopy,
              icon: Icon(Icons.copy_rounded, size: 20.w),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                padding: EdgeInsets.all(8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_rounded, size: 22.w, color: Theme.of(context).colorScheme.onSurfaceVariant),
              SizedBox(width: 16.w),
               Expanded(
                child: Text(
                  isPasswordRevealed
                      ? _passwordController.getDecryptedPassword(entry)
                      : '••••••••••••',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: isPasswordRevealed ? 'Inter' : 'monospace',
                    letterSpacing: isPasswordRevealed ? 0 : 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               TextButton.icon(
                onPressed: _revealPassword, 
                icon: Icon(isPasswordRevealed ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 18),
                label: Text(isPasswordRevealed ? 'hide'.tr : 'reveal'.tr),
                style: TextButton.styleFrom(
                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                   backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                   foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => _passwordController.copyPassword(entry),
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text('copy'.tr),
                 style: TextButton.styleFrom(
                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                   backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagsField(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: entry.tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            tag,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimestampsCard(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
           _buildTimestampRow(context, 'created'.tr, dateFormat.format(entry.createdAt)),
           Divider(height: 24.h, thickness: 1, color: Theme.of(context).dividerTheme.color),
           _buildTimestampRow(context, 'last_modified'.tr, dateFormat.format(entry.updatedAt)),
        ],
      ),
    );
  }
  
  Widget _buildTimestampRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  IconData _getEntryIcon() {
    final website = entry.website?.toLowerCase() ?? '';
    final label = entry.label.toLowerCase();
    
    if (website.contains('google') || label.contains('google')) return Icons.alternate_email_rounded; // Specific icon if available
    if (website.contains('mail') || label.contains('mail')) return Icons.mail_rounded;
    if (website.contains('github') || label.contains('github')) return Icons.code_rounded;
    if (website.contains('linkedin') || label.contains('linkedin')) return Icons.work_rounded;
    return Icons.lock_outline_rounded;
  }

  Future<void> _revealPassword() async {
    if (isPasswordRevealed) {
      setState(() => isPasswordRevealed = false);
      return;
    }

    final bool biometricAvailable = await _biometricService.isAvailable();
    final bool biometricEnabledInApp = await _biometricService.isBiometricEnabledInApp();

    if (biometricAvailable && biometricEnabledInApp) {
      final authenticated = await _biometricService.authenticate(
        localizedReason: 'authenticate_to_reveal'.tr,
      );

      if (authenticated) _showRevealedPassword();
    } else {
      final pinController = TextEditingController();
      final verified = await Get.dialog<bool>(
        AlertDialog(
          title: Text('enter_pin'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('enter_pin_to_reveal'.tr),
              SizedBox(height: 16.h),
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: 'enter_pin'.tr,
                  prefixIcon: const Icon(Icons.lock_rounded),
                  counterText: '',
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                final isValid = await _authController.verifyPin(pinController.text);
                if (isValid) {
                  Get.back(result: true);
                } else {
                  pinController.clear();
                }
              },
              child: Text('verify'.tr),
            ),
          ],
        ),
      );
      pinController.dispose();

      if (verified == true) _showRevealedPassword();
    }
  }

  void _showRevealedPassword() {
    setState(() => isPasswordRevealed = true);
    _revealTimeout = Future.delayed(const Duration(seconds: 30), () {
      if (mounted && isPasswordRevealed) {
        setState(() => isPasswordRevealed = false);
      }
    });
  }
  
  @override
  void dispose() {
    _revealTimeout = null;
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = true;
      _formInitialized = false;
    });
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
      _formInitialized = false;
    });
    // Clear controllers? No, better to let them be reset on next edit.
  }

  void _saveChanges() {
    final tags = _passwordController.tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    
    final newPassword = _passwordController.passwordController.text;
    
    _passwordController.savePassword(
      id: entry.id,
      label: _passwordController.labelController.text,
      username: _passwordController.usernameController.text,
      password: newPassword,
      website: _passwordController.websiteController.text,
      notes: _passwordController.notesController.text,
      tags: tags,
      originalCreatedAt: entry.createdAt,
    );
    
    setState(() {
      entry = entry.copyWith(
        label: _passwordController.labelController.text,
        username: _passwordController.usernameController.text,
        encryptedPassword: Get.find<EncryptionService>().encrypt(newPassword),
        website: _passwordController.websiteController.text,
        notes: _passwordController.notesController.text,
        tags: tags,
        updatedAt: DateTime.now(),
      );
      isEditing = false;
      _formInitialized = false;
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
      label: '${entry.label} (${'copy'.tr})',
      username: entry.username,
      password: _passwordController.getDecryptedPassword(entry),
      website: entry.website,
      notes: entry.notes,
      tags: entry.tags,
    );
    Fluttertoast.showToast(msg: 'password_saved'.tr);
  }

  void _deleteEntry() {
    _passwordController.deletePassword(entry.id);
    Get.back();
  }
}