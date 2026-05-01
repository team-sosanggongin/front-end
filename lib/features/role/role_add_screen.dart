import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../common/widgets/primary_button.dart';
import '../../l10n/app_localizations.dart';
import 'role_provider.dart';
import 'widgets/role_card.dart';
import 'widgets/permission_toggle_tile.dart';

class _RoleAddState {
  final int step;
  final String? selectedTypeKey;
  final Set<int> enabledPermissionIds;

  const _RoleAddState({
    this.step = 0,
    this.selectedTypeKey,
    this.enabledPermissionIds = const {},
  });

  _RoleAddState copyWith({
    int? step,
    String? selectedTypeKey,
    Set<int>? enabledPermissionIds,
  }) =>
      _RoleAddState(
        step: step ?? this.step,
        selectedTypeKey: selectedTypeKey ?? this.selectedTypeKey,
        enabledPermissionIds: enabledPermissionIds ?? this.enabledPermissionIds,
      );
}

const _roleTypeKeys = ['manager', 'partTimer', 'employee', 'newRole'];

const _roleTypeIcons = {
  'manager':   Icons.manage_accounts_outlined,
  'partTimer': Icons.access_time_outlined,
  'employee':  Icons.person_outline,
  'newRole':   Icons.add_circle_outline,
};

class RoleAddScreen extends ConsumerStatefulWidget {
  const RoleAddScreen({super.key});

  @override
  ConsumerState<RoleAddScreen> createState() => _RoleAddScreenState();
}

class _RoleAddScreenState extends ConsumerState<RoleAddScreen> {
  _RoleAddState _state = const _RoleAddState();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _roleTypeLabel(BuildContext context, String key) {
    final s = S.of(context);
    switch (key) {
      case 'manager':   return s.roleTypeManager;
      case 'partTimer': return s.roleTypePartTimer;
      case 'employee':  return s.roleTypeEmployee;
      case 'newRole':   return s.roleTypeNewRole;
      default:          return key;
    }
  }

  void _onTypeSelected(String key) {
    final presetKeys = presetPermissionsFor(key);
    final allPerms = ref.read(permissionListProvider).valueOrNull ?? [];
    final presetIds = allPerms
        .where((p) => presetKeys.contains(p.permissionName))
        .map((p) => p.id)
        .toSet();
    setState(() {
      _state = _state.copyWith(
        selectedTypeKey: key,
        enabledPermissionIds: presetIds,
      );
    });
  }

  void _onPermissionToggled(int id, bool value) {
    final updated = Set<int>.from(_state.enabledPermissionIds);
    value ? updated.add(id) : updated.remove(id);
    setState(() => _state = _state.copyWith(enabledPermissionIds: updated));
  }

  bool _canProceed() {
    if (_state.step == 0) return _state.selectedTypeKey != null;
    return _nameController.text.trim().isNotEmpty;
  }

  Future<void> _submit() async {
    final success = await ref.read(roleMutationProvider.notifier).create(
      roleName: _nameController.text.trim(),
      description: _state.selectedTypeKey ?? '',
      permissionIds: _state.enabledPermissionIds.toList(),
    );
    if (success && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);
    final isMutating = ref.watch(roleMutationProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _state.step == 0 ? s.roleAddTitle : s.rolePermissionTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_state.step == 1) {
              setState(() => _state = _state.copyWith(step: 0));
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: _state.step == 0
          ? _buildStep1(context, rs, s)
          : _buildStep2(context, rs, s),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: rs.pxy(horizontal: 24, vertical: 16),
          child: PrimaryButton(
            text: _state.step == 0 ? s.roleNextButton : s.roleCompleteButton,
            enabled: _canProceed() && !isMutating,
            onPressed: _state.step == 0
                ? () => setState(() => _state = _state.copyWith(step: 1))
                : _submit,
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context, ResponsiveSize rs, S s) {
    return Padding(
      padding: rs.pxy(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.roleAddStepOneHeading, style: AppTextStyles.titleMedium),
          SizedBox(height: rs.h(8)),
          Text(s.roleAddStepOneSubtitle, style: AppTextStyles.caption),
          SizedBox(height: rs.h(24)),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: rs.w(12),
            mainAxisSpacing: rs.h(12),
            childAspectRatio: 1.4,
            children: _roleTypeKeys.map((key) {
              return RoleCard(
                icon: _roleTypeIcons[key]!,
                label: _roleTypeLabel(context, key),
                isSelected: _state.selectedTypeKey == key,
                onTap: () => _onTypeSelected(key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context, ResponsiveSize rs, S s) {
    final permissionsAsync = ref.watch(permissionListProvider);

    return permissionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(s.networkError)),
      data: (permissions) => ListView(
        children: [
          Padding(
            padding: rs.pxy(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.roleNameLabel, style: AppTextStyles.label),
                SizedBox(height: rs.h(8)),
                TextField(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                  decoration: AppInputDecorations.outlined(
                    hintText: s.roleNameHint,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderGray),
          Padding(
            padding: rs.pxy(horizontal: 24, vertical: 16),
            child: Text(s.rolePermissionLabel, style: AppTextStyles.label),
          ),
          ...permissions.map((permission) => Column(
            children: [
              PermissionToggleTile(
                permission: permission,
                isEnabled: _state.enabledPermissionIds
                    .contains(permission.id),
                onChanged: (v) =>
                    _onPermissionToggled(permission.id, v),
              ),
              const Divider(height: 1, color: AppColors.borderGray),
            ],
          )),
        ],
      ),
    );
  }
}