import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../common/widgets/primary_button.dart';
import '../../l10n/app_localizations.dart';
import 'role_provider.dart';
import 'widgets/role_list_tile.dart';

class RoleListScreen extends ConsumerWidget {
  const RoleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(roleListProvider);
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.roleManagementTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(RolePath.add),
          ),
        ],
      ),
      body: rolesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.networkError, style: AppTextStyles.body),
              SizedBox(height: rs.h(12)),
              TextButton(
                onPressed: () =>
                    ref.read(roleListProvider.notifier).fetch(refresh: true),
                child: Text(s.retryButton),
              ),
            ],
          ),
        ),
        data: (roles) => roles.isEmpty
            ? _buildEmptyState(context, rs, s)
            : _buildList(context, roles, rs),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<RoleModel> roles, ResponsiveSize rs) {
    return ListView.separated(
      itemCount: roles.length,
      separatorBuilder: (_, __) =>
      const Divider(height: 1, color: AppColors.borderGray),
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleListTile(
          role: role,
          onTap: () => context.push(RolePath.detail, extra: role),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ResponsiveSize rs, S s) {
    return Center(
      child: Padding(
        padding: rs.px(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.manage_accounts_outlined,
              size: rs.w(64),
              color: AppColors.textSecondary,
            ),
            SizedBox(height: rs.h(16)),
            Text(s.roleEmptyStateHeading, style: AppTextStyles.titleMedium),
            SizedBox(height: rs.h(8)),
            Text(
              s.roleEmptyStateSubtitle,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: rs.h(32)),
            PrimaryButton(
              text: s.roleEmptyStateButton,
              onPressed: () => context.push(RolePath.add),
            ),
          ],
        ),
      ),
    );
  }
}