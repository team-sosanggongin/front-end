import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final double? height;
  final double? borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final resolvedHeight = height ?? rs.h(56);
    final resolvedRadius = borderRadius ?? rs.w(12);

    return SizedBox(
      width: double.infinity,
      height: resolvedHeight,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              enabled ? AppColors.darkBackground : AppColors.borderGray,
          foregroundColor: enabled ? AppColors.white : AppColors.textSecondary,
          disabledBackgroundColor: AppColors.borderGray,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(resolvedRadius),
          ),
        ),
        child: Text(
          text,
          style: enabled
              ? AppTextStyles.buttonText
              : AppTextStyles.buttonTextDisabled,
        ),
      ),
    );
  }
}
