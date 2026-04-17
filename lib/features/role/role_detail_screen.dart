import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../common/widgets/primary_button.dart';
import '../../l10n/app_localizations.dart';
import 'role_provider.dart';
import 'widgets/permission_toggle_tile.dart';

class RoleDetailScreen extends ConsumerStatefulWidget {
  final RoleModel role;

  const RoleDetailScreen({super.key, required this.role});

  @override
  ConsumerState<RoleDetailScreen> createState() => _RoleDetailScreenState();
}

class _RoleDetailScreenState extends ConsumerState<RoleDetailScreen> {
  late Set<String> _enabledPermissions;
  late TextEditingController _nameController;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _enabledPermissions = Set.from(widget.role.permissions);
    _nameController = TextEditingController(text: widget.role.name);
    _nameController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final nameChanged = _nameController.text.trim() != widget.role.name;
    final permChanged = !_setEquals(
        _enabledPermissions, Set.from(widget.role.permissions));
    setState(() => _isEdited = nameChanged || permChanged);
  }

  void _onPermissionToggled(String key, bool value) {
    setState(() {
      value ? _enabledPermissions.add(key) : _enabledPermissions.remove(key);
    });
    _onChanged();
  }

  bool _setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  Future<void> _submit() async {
    final success = await ref.read(roleMutationProvider.notifier).update(
      roleId: widget.role.id,
      name: _nameController.text.trim(),
      description: widget.role.description,
      permissions: _enabledPermissions.toList(),
    );
    if (success && mounted) context.pop();
  }

  void _showDeleteDialog(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: rs.radius(16)),
        title: Text(s.roleDeleteDialogTitle),
        content: Text(
          s.roleDeleteDialogMessage,
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
              ref.read(roleListProvider.notifier).deleteRole(widget.role.id);
              ctx.pop();
              context.pop();
            },
            child: Text(s.roleDeleteButton,
                style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionListProvider);
    final isMutating = ref.watch(roleMutationProvider).isLoading;
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.roleDetailTitle),
        actions: [
          TextButton(
            onPressed: () => _showDeleteDialog(context),
            child: Text(s.roleDeleteButton,
                style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ],
      ),
      body: ListView(
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
                  decoration: AppInputDecorations.outlined(),
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
                isEnabled: _enabledPermissions.contains(permission.key),
                onChanged: (v) => _onPermissionToggled(permission.key, v),
              ),
              const Divider(height: 1, color: AppColors.borderGray),
            ],
          )),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: rs.pxy(horizontal: 24, vertical: 16),
          child: PrimaryButton(
            text: s.roleSaveButton,
            enabled: _isEdited && !isMutating,
            onPressed: _submit,
          ),
        ),
      ),
    );
  }
}