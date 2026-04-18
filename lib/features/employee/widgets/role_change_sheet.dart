import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../l10n/app_localizations.dart';
import '../../role/role_provider.dart';
import '../employee_provider.dart';

class RoleChangeSheet extends ConsumerWidget {
  final EmployeeModel employee;

  const RoleChangeSheet({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);
    final rolesAsync = ref.watch(roleListProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(rs.w(20))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들
          SizedBox(height: rs.h(12)),
          Container(
            width: rs.w(40),
            height: rs.h(4),
            decoration: BoxDecoration(
              color: AppColors.borderGray,
              borderRadius: rs.radius(2),
            ),
          ),
          SizedBox(height: rs.h(20)),
          Padding(
            padding: rs.px(24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(s.employeeRoleChangeTitle,
                  style: AppTextStyles.titleMedium),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderGray),
          rolesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => const SizedBox.shrink(),
            data: (roles) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: roles.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.borderGray),
              itemBuilder: (context, index) {
                final role = roles[index];
                final isSelected = role.id == employee.role.id;

                return InkWell(
                  onTap: () {
                    ref
                        .read(employeeListProvider.notifier)
                        .updateEmployeeRole(employee.id, role);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: rs.pxy(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(role.name,
                              style: AppTextStyles.body),
                        ),
                        if (isSelected)
                          Icon(Icons.check,
                              color: AppColors.darkBackground,
                              size: rs.w(20)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: rs.h(24)),
        ],
      ),
    );
  }
}