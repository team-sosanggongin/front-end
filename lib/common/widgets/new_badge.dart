import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';

class NewBadge extends StatelessWidget {
  final double? scale;

  const NewBadge({super.key, this.scale});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final s = scale ?? rs.scaleW;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 3 * s),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4 * s),
      ),
      child: Text(
        S.of(context).newBadge,
        style: TextStyle(
          fontSize: 11 * s,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}
