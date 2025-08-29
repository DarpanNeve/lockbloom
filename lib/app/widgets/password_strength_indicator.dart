import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            SizedBox(width: AppTheme.spacingMd.w),
            Text(
              strength.feedback,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStrengthColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (strength.entropy > 0) ...[
          SizedBox(height: AppTheme.spacingXs.h),
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

  Widget _buildStrengthBar(BuildContext context) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
        return AppTheme.errorColor;
      case 2:
        return AppTheme.warningColor;
      case 3:
        return AppTheme.accentColor;
      case 4:
        return AppTheme.successColor;
      case 5:
        return AppTheme.successColor;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}