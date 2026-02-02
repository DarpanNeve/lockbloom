import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/core/theme/app_colors.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStrengthBar(context),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Text(
              _getStrengthText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStrengthColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (strength.entropy > 0) ...[
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Entropy: ${strength.entropy.toStringAsFixed(1)} bits',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String _getStrengthText() {
    switch (strength.score) {
      case 1:
        return 'weak'.tr;
      case 2:
        return 'fair'.tr;
      case 3:
        return 'good'.tr;
      case 4:
      case 5:
        return 'strong'.tr;
      default:
        return '';
    }
  }

  Widget _buildStrengthBar(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
        child: LinearProgressIndicator(
          value: strength.score / 5.0,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor(context)),
        ),
      ),
    );
  }

  Color _getStrengthColor(BuildContext context) {
    switch (strength.score) {
      case 1:
        return AppColors.errorColor;
      case 2:
        return AppColors.warningColor;
      case 3:
        return AppColors.accentColor;
      case 4:
        return AppColors.successColor;
      case 5:
        return AppColors.successColor;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}