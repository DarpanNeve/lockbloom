import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class PasswordEntryCard extends StatelessWidget {
  final PasswordEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onCopyPassword;
  final VoidCallback? onCopyUsername;
  final VoidCallback? onToggleFavorite;

  const PasswordEntryCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onCopyPassword,
    this.onCopyUsername,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      // Use default CardTheme shape
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingMd.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Icon(
                      _getEntryIcon(),
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.w,
                    ),
                  ),
                  
                  SizedBox(width: AppTheme.spacingMd.w),
                  
                  // Title and Website
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.label,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (entry.username.isNotEmpty) ...[
                          SizedBox(height: AppTheme.spacingXs.h),
                          Text(
                            entry.username,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (entry.website?.isNotEmpty == true) ...[
                          SizedBox(height: 2.h),
                          Text(
                            entry.website!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: AppTheme.spacingMd.h),
              
              // Tags
              if (entry.tags.isNotEmpty) ...[
                Wrap(
                  spacing: AppTheme.spacingSm.w,
                  runSpacing: AppTheme.spacingXs.h,
                  children: entry.tags.take(3).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: AppTheme.spacingMd.h),
              ],
              
              Divider(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
              
              SizedBox(height: AppTheme.spacingSm.h),

              // Action Buttons
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   IconButton(
                    onPressed: onCopyUsername,
                    icon: Icon(Icons.person_rounded, size: 20.w),
                    tooltip: 'copy_username'.tr,
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  IconButton(
                    onPressed: onCopyPassword,
                    icon: Icon(Icons.copy_rounded, size: 20.w),
                    tooltip: 'copy_password'.tr,
                     style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                   IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      entry.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: entry.isFavorite 
                          ? AppColors.errorColor 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    tooltip: entry.isFavorite ? 'remove_favorite'.tr : 'add_favorite'.tr,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEntryIcon() {
    final website = entry.website?.toLowerCase() ?? '';
    final label = entry.label.toLowerCase();
    
    if (website.contains('google') || 
        website.contains('gmail') || 
        label.contains('google') || 
        label.contains('gmail')) {
      return Icons.mail_outline_rounded;
    } else if (website.contains('facebook') || label.contains('facebook')) {
      return Icons.facebook_rounded;
    } else if (website.contains('twitter') || label.contains('twitter') || label.contains('x.com')) {
      return Icons.alternate_email_rounded;
    } else if (website.contains('github') || label.contains('github')) {
      return Icons.code_rounded;
    } else if (website.contains('linkedin') || label.contains('linkedin')) {
      return Icons.work_outline_rounded;
    } else if (website.contains('netflix') || label.contains('netflix')) {
      return Icons.movie_outlined;
    } else if (website.contains('spotify') || label.contains('spotify')) {
      return Icons.music_note_rounded;
    } else if (website.contains('amazon') || label.contains('amazon')) {
      return Icons.shopping_cart_outlined;
    } else if (website.isNotEmpty) {
      return Icons.language_rounded;
    } else {
      return Icons.lock_outline_rounded;
    }
  }
}