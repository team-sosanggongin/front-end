import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import '../role/role_provider.dart';
import '../../common/widgets/role_list_tile.dart';

class EmployeeRoleSelectScreen extends ConsumerStatefulWidget {
  const EmployeeRoleSelectScreen({super.key});

  @override
  ConsumerState<EmployeeRoleSelectScreen> createState() =>
      _EmployeeRoleSelectScreenState();
}

class _EmployeeRoleSelectScreenState
    extends ConsumerState<EmployeeRoleSelectScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(roleListProvider);
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.employeeRoleSelectTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 검색창
          Padding(
            padding: rs.pxy(horizontal: 24, vertical: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: AppInputDecorations.outlined(
                hintText: s.employeeRoleSelectSearchHint,
              ).copyWith(
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                    : null,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderGray),
          // 역할 목록
          Expanded(
            child: rolesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.read(roleListProvider.notifier).fetch(refresh: true),
                  child: Text(s.retryButton),
                ),
              ),
              data: (roles) {
                final filtered = _searchQuery.isEmpty
                    ? roles
                    : roles
                    .where((r) => r.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                    .toList();

                return ListView(
                  children: [
                    if (filtered.isEmpty)
                      Padding(
                        padding: rs.pxy(horizontal: 24, vertical: 32),
                        child: Center(
                          child: Text(s.employeeRoleSelectEmpty,
                              style: AppTextStyles.caption),
                        ),
                      )
                    else
                      ...filtered.map((role) => Column(
                        children: [
                          RoleListTile(
                            role: role,
                            onTap: () => context.push(
                              EmployeePath.contractMethod,
                              extra: role,
                            ),
                          ),
                          const Divider(height: 1, color: AppColors.borderGray),
                        ],
                      )),
                    const Divider(height: 1, color: AppColors.borderGray),
                    // 새 역할 만들기 진입점
                    _buildCreateRoleTile(context, rs, s),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRoleTile(
      BuildContext context, ResponsiveSize rs, S s) {
    return InkWell(
      onTap: () async {
        // 역할 추가 화면으로 이동 후 돌아오면 목록 갱신
        await context.push(RolePath.add);
        if (context.mounted) {
          ref.read(roleListProvider.notifier).fetch(refresh: true);
        }
      },
      child: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.employeeRoleSelectNoRole,
                    style: AppTextStyles.caption,
                  ),
                  SizedBox(height: rs.h(4)),
                  Text(
                    s.employeeRoleSelectCreateButton,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.darkBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline,
                color: AppColors.darkBackground, size: rs.w(24)),
          ],
        ),
      ),
    );
  }
}