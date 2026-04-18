import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: rs.pxy(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkBackground.withOpacity(0.08)
              : AppColors.lightGray,
          borderRadius: rs.radius(12),
          border: Border.all(
            color: isSelected ? AppColors.darkBackground : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: rs.w(32),
              color: isSelected
                  ? AppColors.darkBackground
                  : AppColors.textSecondary,
            ),
            SizedBox(height: rs.h(8)),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: isSelected
                    ? AppColors.darkBackground
                    : AppColors.textPrimary,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}