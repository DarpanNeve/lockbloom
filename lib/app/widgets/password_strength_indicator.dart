import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lockbloom/app/data/models/password_entry.dart';

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
            SizedBox(width: 12.w),
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
          SizedBox(height: 4.h),
          Text(
            'Entropy: ${strength.entropy.toStringAsFixed(1)} bits',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
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
        borderRadius: BorderRadius.circular(3.r),
        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.r),
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
        return const Color(0xFFEF4444); // Red
      case 2:
        return const Color(0xFFF97316); // Orange
      case 3:
        return const Color(0xFFF59E0B); // Amber
      case 4:
        return const Color(0xFF10B981); // Emerald
      case 5:
        return const Color(0xFF059669); // Dark Emerald
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}