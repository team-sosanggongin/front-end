import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.circular(size * 0.23),
          ),
          child: Icon(
            Icons.storefront_outlined,
            size: size * 0.47,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text('소상공인', style: AppTextStyles.logoTitle),
      ],
    );
  }
}
