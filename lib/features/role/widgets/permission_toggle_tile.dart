import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../l10n/app_localizations.dart';
import '../role_provider.dart';

class PermissionToggleTile extends StatelessWidget {
  final PermissionModel permission;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const PermissionToggleTile({
    super.key,
    required this.permission,
    required this.isEnabled,
    required this.onChanged,
  });

  String _label(BuildContext context) {
    final s = S.of(context);
    switch (permission.permissionName) {
      case PermissionKey.staffManage:    return s.permissionStaffManage;
      case PermissionKey.storeManage:    return s.permissionStoreManage;
      case PermissionKey.contractManage: return s.permissionContractManage;
      case PermissionKey.salaryManage:   return s.permissionSalaryManage;
      case PermissionKey.staffInvite:    return s.permissionStaffInvite;
      default:                           return permission.permissionName;
    }
  }

  String _desc(BuildContext context) {
    final s = S.of(context);
    switch (permission.permissionName) {
      case PermissionKey.staffManage:    return s.permissionStaffManageDesc;
      case PermissionKey.storeManage:    return s.permissionStoreManageDesc;
      case PermissionKey.contractManage: return s.permissionContractManageDesc;
      case PermissionKey.salaryManage:   return s.permissionSalaryManageDesc;
      case PermissionKey.staffInvite:    return s.permissionStaffInviteDesc;
      default:                           return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Padding(
      padding: rs.pxy(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_label(context), style: AppTextStyles.body),
                SizedBox(height: rs.h(2)),
                Text(_desc(context), style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: AppColors.darkBackground,
          ),
        ],
      ),
    );
  }
}