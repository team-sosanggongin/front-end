import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;

  const EmptyState({
    super.key,
    required this.icon,
    required this.heading,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Center(
      child: Padding(
        padding: rs.px(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: rs.w(64), color: AppColors.textSecondary),
            SizedBox(height: rs.h(16)),
            Text(heading, style: AppTextStyles.titleMedium),
            SizedBox(height: rs.h(8)),
            Text(
              subtitle,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonTap != null) ...[
              SizedBox(height: rs.h(32)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onButtonTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBackground,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: rs.py(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: rs.radius(12),
                    ),
                  ),
                  child: Text(buttonLabel!, style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}