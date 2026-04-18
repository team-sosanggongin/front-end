import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../common/widgets/empty_state.dart';
import '../../l10n/app_localizations.dart';
import 'employee_provider.dart';
import 'widgets/employee_list_tile.dart';

class EmployeeListScreen extends ConsumerWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeesAsync = ref.watch(employeeListProvider);
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.employeeManagementTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(EmployeePath.roleSelect),
          ),
        ],
      ),
      body: employeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.networkError, style: AppTextStyles.body),
              SizedBox(height: rs.h(12)),
              TextButton(
                onPressed: () =>
                    ref.read(employeeListProvider.notifier).fetch(refresh: true),
                child: Text(s.retryButton),
              ),
            ],
          ),
        ),
        data: (employees) => employees.isEmpty
            ? EmptyState(
          icon: Icons.people_outline,
          heading: s.employeeListEmptyHeading,
          subtitle: s.employeeListEmptySubtitle,
          buttonLabel: s.employeeAddMenuLabel,
          onButtonTap: () => context.push(EmployeePath.roleSelect),
        )
            : ListView.separated(
          itemCount: employees.length,
          separatorBuilder: (_, __) =>
          const Divider(height: 1, color: AppColors.borderGray),
          itemBuilder: (context, index) {
            final employee = employees[index];
            return EmployeeListTile(
              employee: employee,
              onTap: () => context.push(
                EmployeePath.detail,
                extra: employee,
              ),
            );
          },
        ),
      ),
    );
  }
}