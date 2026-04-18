import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';

class ContractMethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isDisabled;
  final VoidCallback onTap;

  const ContractMethodCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: rs.radius(12),
      child: Opacity(
        opacity: isDisabled ? 0.45 : 1.0,
        child: Container(
          width: double.infinity,
          padding: rs.pxy(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: rs.radius(12),
          ),
          child: Row(
            children: [
              Container(
                width: rs.w(48),
                height: rs.w(48),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: rs.radius(10),
                ),
                child: Icon(icon,
                    size: rs.w(24), color: AppColors.textPrimary),
              ),
              SizedBox(width: rs.w(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.titleMedium),
                    SizedBox(height: rs.h(4)),
                    Text(description, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: AppColors.textSecondary, size: rs.w(24)),
            ],
          ),
        ),
      ),
    );
  }
}