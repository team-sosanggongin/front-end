import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../l10n/app_localizations.dart';
import '../role_provider.dart';

class RoleListTile extends StatelessWidget {
  final RoleModel role;
  final VoidCallback onTap;

  const RoleListTile({
    super.key,
    required this.role,
    required this.onTap,
  });

  String _permissionLabel(BuildContext context, String key) {
    final s = S.of(context);
    switch (key) {
      case PermissionKey.staffManage:    return s.permissionStaffManage;
      case PermissionKey.storeManage:    return s.permissionStoreManage;
      case PermissionKey.contractManage: return s.permissionContractManage;
      case PermissionKey.salaryManage:   return s.permissionSalaryManage;
      case PermissionKey.staffInvite:    return s.permissionStaffInvite;
      default:                           return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final permissions = role.permissions;

    // 최대 3개까지 표시, 초과시 +N개 표시
    const maxVisible = 3;
    final visible = permissions.take(maxVisible).toList();
    final overflow = permissions.length - maxVisible;

    final permissionText = [
      ...visible.map((k) => _permissionLabel(context, k)),
      if (overflow > 0) '+$overflow개',
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.name, style: AppTextStyles.titleMedium),
                  SizedBox(height: rs.h(4)),
                  Text(
                    permissions.isEmpty ? '-' : permissionText,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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