import 'package:flutter/material.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';

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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Section
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Icon(
                    _getEntryIcon(),
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Content Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              entry.label,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (entry.isFavorite) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.favorite_rounded, size: 14, color: AppColors.errorColor),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (entry.username.isNotEmpty)
                        Text(
                          entry.username,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (entry.website?.isNotEmpty == true) ...[
                        const SizedBox(height: 2),
                        Text(
                          entry.website!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (entry.tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: entry.tags.take(2).map((tag) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Actions Section
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     _buildActionButton(
                      context,
                      icon: Icons.person_rounded,
                      onTap: onCopyUsername,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      icon: Icons.copy_rounded,
                      onTap: onCopyPassword,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  IconData _getEntryIcon() {
    final website = entry.website?.toLowerCase() ?? '';
    final label = entry.label.toLowerCase();
    
    if (website.contains('google') || label.contains('google')) return Icons.alternate_email_rounded;
    if (website.contains('gmail') || label.contains('gmail')) return Icons.mail_outline_rounded;
    if (website.contains('facebook') || label.contains('facebook')) return Icons.facebook_rounded;
    if (website.contains('twitter') || label.contains('twitter') || label.contains('x.com')) return Icons.alternate_email_rounded; // Use generic/alt email as flutter usually doesn't have X icon
    if (website.contains('github') || label.contains('github')) return Icons.code_rounded;
    if (website.contains('linkedin') || label.contains('linkedin')) return Icons.work_outline_rounded;
    if (website.contains('netflix') || label.contains('netflix')) return Icons.movie_outlined;
    if (website.contains('spotify') || label.contains('spotify')) return Icons.music_note_rounded;
    if (website.contains('amazon') || label.contains('amazon')) return Icons.shopping_cart_outlined;
    if (website.isNotEmpty) return Icons.language_rounded;
    return Icons.lock_outline_rounded;
  }
}