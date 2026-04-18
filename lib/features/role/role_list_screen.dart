import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../common/widgets/empty_state.dart';
import '../../l10n/app_localizations.dart';
import 'role_provider.dart';
import '../../common/widgets/role_list_tile.dart';

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
            ? EmptyState(
          icon: Icons.manage_accounts_outlined,
          heading: s.roleEmptyStateHeading,
          subtitle: s.roleEmptyStateSubtitle,
          buttonLabel: s.roleEmptyStateButton,
          onButtonTap: () => context.push(RolePath.add),
        )
            : ListView.separated(
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
        ),
      ),
    );
  }
}