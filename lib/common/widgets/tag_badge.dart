import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';

class TagBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final double? scale;

  const TagBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final s = scale ?? rs.scaleW;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 4 * s),
      decoration: BoxDecoration(
        color: color ?? AppColors.darkBackground,
        borderRadius: BorderRadius.circular(20 * s),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12 * s,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.white,
        ),
      ),
    );
  }
}