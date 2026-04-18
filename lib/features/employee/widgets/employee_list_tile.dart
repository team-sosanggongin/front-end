import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../employee_provider.dart';

class EmployeeListTile extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;

  const EmployeeListTile({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // 아바타
            CircleAvatar(
              radius: rs.w(20),
              backgroundColor: AppColors.lightGray,
              child: Text(
                employee.name.characters.first,
                style: AppTextStyles.titleMedium,
              ),
            ),
            SizedBox(width: rs.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee.name, style: AppTextStyles.titleMedium),
                  SizedBox(height: rs.h(2)),
                  Text(
                    employee.role.name,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: rs.w(24),
            ),
          ],
        ),
      ),
    );
  }
}