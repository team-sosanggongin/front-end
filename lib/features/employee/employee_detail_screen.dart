import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'employee_provider.dart';
import 'widgets/role_change_sheet.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final EmployeeModel employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목록에서 실시간 상태 반영
    final employees = ref.watch(employeeListProvider).valueOrNull ?? [];
    final current = employees.firstWhere(
          (e) => e.id == employee.id,
      orElse: () => employee,
    );

    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.employeeDetailTitle)),
      body: ListView(
        children: [
          _buildProfile(context, rs, current),
          const Divider(height: 1, color: AppColors.borderGray),
          _buildInfoSection(context, rs, s, current),
          const Divider(height: 8, color: AppColors.lightGray),
          _buildActionSection(context, ref, rs, s, current),
        ],
      ),
    );
  }

  Widget _buildProfile(
      BuildContext context, ResponsiveSize rs, EmployeeModel employee) {
    return Padding(
      padding: rs.pxy(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          CircleAvatar(
            radius: rs.w(36),
            backgroundColor: AppColors.lightGray,
            child: Text(
              employee.name.characters.first,
              style: AppTextStyles.titleLarge,
            ),
          ),
          SizedBox(height: rs.h(12)),
          Text(employee.name, style: AppTextStyles.titleMedium),
          SizedBox(height: rs.h(4)),
          Text(employee.role.name, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context,
      ResponsiveSize rs,
      S s,
      EmployeeModel employee,
      ) {
    return Padding(
      padding: rs.pxy(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            rs,
            label: s.employeeRoleLabel,
            value: employee.role.name,
          ),
          SizedBox(height: rs.h(16)),
          _buildInfoRow(
            context,
            rs,
            label: s.employeeStartDateLabel,
            value: employee.startDate,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      ResponsiveSize rs, {
        required String label,
        required String value,
      }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label,
              style: AppTextStyles.caption),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: AppTextStyles.body),
        ),
      ],
    );
  }

  Widget _buildActionSection(
      BuildContext context,
      WidgetRef ref,
      ResponsiveSize rs,
      S s,
      EmployeeModel employee,
      ) {
    return Column(
      children: [
        // 역할 변경
        _buildActionTile(
          context,
          rs,
          label: s.employeeRoleChangeButton,
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => RoleChangeSheet(employee: employee),
          ),
        ),
        const Divider(height: 1, color: AppColors.borderGray),
        // 근로계약서 수정 요청 - 비활성화
        _buildActionTile(
          context,
          rs,
          label: s.employeeContractRequestButton,
          onTap: () {
          },
        ),
        const Divider(height: 1, color: AppColors.borderGray),
        // 퇴직 처리
        _buildActionTile(
          context,
          rs,
          label: s.employeeResignButton,
          textColor: AppColors.error,
          onTap: () => _showResignDialog(context, ref, rs, s, employee),
        ),
      ],
    );
  }

  Widget _buildActionTile(
      BuildContext context,
      ResponsiveSize rs, {
        required String label,
        required VoidCallback onTap,
        Color? textColor,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: rs.w(24)),
          ],
        ),
      ),
    );
  }

  void _showResignDialog(
      BuildContext context,
      WidgetRef ref,
      ResponsiveSize rs,
      S s,
      EmployeeModel employee,
      ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: rs.radius(16)),
        title: Text(s.employeeResignDialogTitle),
        content: Text(
          s.employeeResignDialogMessage,
          style: AppTextStyles.caption,
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(s.cancelButton,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(employeeListProvider.notifier)
                  .resignEmployee(employee.id);
              ctx.pop();
              context.pop();
            },
            child: Text(s.employeeResignButton,
                style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}