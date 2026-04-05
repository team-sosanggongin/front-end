import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

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
        SizedBox(height: size * 0.13),
        Text(S.of(context).appTitle, style: AppTextStyles.logoTitle),
      ],
    );
  }
}
