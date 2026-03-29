import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TagBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const TagBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.darkBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.white,
        ),
      ),
    );
  }
}