import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({super.key, this.size = 48, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.darkBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_outline,
          color: AppColors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
