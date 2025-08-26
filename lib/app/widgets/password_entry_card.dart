import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Icon
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      _getEntryIcon(),
                      color: Theme.of(context).colorScheme.primary,
                      size: 20.w,
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Title and Website
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.label,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 16.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                  
                  // Favorite Button
                  if (onToggleFavorite != null)
                    IconButton(
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        entry.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: entry.isFavorite ? Colors.red : null,
                      ),
                      iconSize: 20.w,
                    ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Username
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16.w,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      entry.username.isNotEmpty ? entry.username : 'No username',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Tags
              if (entry.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: entry.tags.take(3).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontSize: 10.sp,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
              ],
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onCopyUsername != null)
                    _buildActionButton(
                      context,
                      icon: Icons.person,
                      label: 'Username',
                      onPressed: onCopyUsername!,
                    ),
                  if (onCopyPassword != null)
                    _buildActionButton(
                      context,
                      icon: Icons.lock,
                      label: 'Password',
                      onPressed: onCopyPassword!,
                    ),
                  _buildActionButton(
                    context,
                    icon: Icons.open_in_new,
                    label: 'Details',
                    onPressed: onTap ?? () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.w,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
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
      return Icons.mail;
    } else if (website.contains('facebook') || label.contains('facebook')) {
      return Icons.facebook;
    } else if (website.contains('twitter') || label.contains('twitter')) {
      return Icons.alternate_email;
    } else if (website.contains('github') || label.contains('github')) {
      return Icons.code;
    } else if (website.contains('linkedin') || label.contains('linkedin')) {
      return Icons.work;
    } else if (website.contains('netflix') || label.contains('netflix')) {
      return Icons.movie;
    } else if (website.contains('spotify') || label.contains('spotify')) {
      return Icons.music_note;
    } else if (website.contains('amazon') || label.contains('amazon')) {
      return Icons.shopping_cart;
    } else if (website.isNotEmpty) {
      return Icons.web;
    } else {
      return Icons.lock_outline;
    }
  }
}