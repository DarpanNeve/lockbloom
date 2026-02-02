import 'package:flutter/material.dart';
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
                    const SizedBox(width: 12),
                    Text('duplicate'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_rounded, color: Theme.of(context).colorScheme.error, size: 20),
                    const SizedBox(width: 12),
                    Text('delete'.tr, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: isEditing ? _buildEditForm(context) : _buildDetailView(context),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderCard(context),
        const SizedBox(height: 24),
        _buildSectionHeader(context, 'credentials'.tr),
        _buildInfoGroup(context, [
          _buildDetailRow(
            context,
            label: 'username'.tr,
            value: entry.username,
            icon: Icons.person_rounded,
            canCopy: true,
            onCopy: () => _passwordController.copyUsername(entry),
          ),
          _buildPasswordRow(context),
          if (entry.website?.isNotEmpty == true)
            _buildDetailRow(
              context,
              label: 'website'.tr,
              value: entry.website!,
              icon: Icons.language_rounded,
              canCopy: true,
              isLast: true,
            ),
        ]),
        const SizedBox(height: 24),
        if (entry.tags.isNotEmpty) ...[
          _buildSectionHeader(context, 'tags'.tr),
          _buildTagsField(context),
          const SizedBox(height: 24),
        ],
        if (entry.notes.isNotEmpty) ...[
          _buildSectionHeader(context, 'notes'.tr),
          _buildInfoGroup(context, [
            _buildDetailRow(
              context,
              label: 'notes'.tr,
              value: entry.notes,
              icon: Icons.notes_rounded,
              maxLines: null,
              isLast: true,
            ),
          ]),
          const SizedBox(height: 24),
        ],
        _buildSectionHeader(context, 'history'.tr),
        _buildTimestampsCard(context),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Icon(
              _getEntryIcon(),
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            entry.label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (entry.website?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                entry.website!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 16),
          IconButton(
            onPressed: () {
              _passwordController.toggleFavorite(entry);
              setState(() {
                entry = entry.copyWith(isFavorite: !entry.isFavorite);
              });
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(12),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            ),
            icon: Icon(
              entry.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: entry.isFavorite ? AppColors.errorColor : Colors.white,
              size: 24,
            ),
            tooltip: entry.isFavorite ? 'remove_favorite'.tr : 'add_favorite'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGroup(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          final index = e.key;
          final widget = e.value;
          final isLast = index == children.length - 1;
          return Column(
            children: [
              widget,
              if (!isLast && widget is! SizedBox) // Check widget type roughly or just use Divider logic inside children
                 Divider(
                  height: 1,
                  thickness: 1,
                  indent: 56,
                  color: Theme.of(context).dividerTheme.color?.withValues(alpha: 0.05),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool canCopy = false,
    VoidCallback? onCopy,
    int? maxLines = 1,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: canCopy ? onCopy : null,
      borderRadius: BorderRadius.vertical(
        top: isLast && false ? Radius.zero : const Radius.circular(20), // Simplify: just let inkwell clip
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: maxLines == null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: maxLines,
                    overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  ),
                ],
              ),
            ),
            if (canCopy)
              Icon(Icons.copy_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lock_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'password'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPasswordRevealed
                      ? _passwordController.getDecryptedPassword(entry)
                      : '••••••••••••',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: isPasswordRevealed ? 'Inter' : 'monospace',
                    letterSpacing: isPasswordRevealed ? 0 : 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _revealPassword,
                icon: Icon(
                  isPasswordRevealed ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(8),
                ),
              ),
              IconButton(
                onPressed: () => _passwordController.copyPassword(entry),
                icon: Icon(
                  Icons.copy_rounded, 
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
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
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController.usernameController,
          decoration: InputDecoration(
            labelText: '${'username'.tr} *',
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController.websiteController,
          decoration: InputDecoration(
            labelText: 'website'.tr,
            prefixIcon: const Icon(Icons.language_rounded),
          ),
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController.tagsController,
          decoration: InputDecoration(
            labelText: '${'tags'.tr} (comma separated)',
            prefixIcon: const Icon(Icons.tag_rounded),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController.notesController,
          decoration: InputDecoration(
            labelText: 'notes'.tr,
            prefixIcon: const Icon(Icons.note_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelEdit,
                child: Text('cancel'.tr),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text('save_changes'.tr),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTagsField(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entry.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimestampsCard(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
           _buildTimestampRow(context, 'created'.tr, dateFormat.format(entry.createdAt)),
           Divider(height: 24, thickness: 1, color: Theme.of(context).dividerTheme.color),
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
    
    if (website.contains('google') || label.contains('google')) return Icons.alternate_email_rounded;
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
              const SizedBox(height: 16),
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