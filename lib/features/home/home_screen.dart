import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return SingleChildScrollView(
      padding: rs.px(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: rs.h(8)),
          _buildBanner(context),
          SizedBox(height: rs.h(20)),
          _buildMenuGrid(context),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final iconSize = rs.w(48);

    return Container(
      width: double.infinity,
      padding: rs.pxy(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: rs.radius(16),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EDFF),
              borderRadius: BorderRadius.circular(iconSize / 2),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: const Color(0xFF5B9BF3),
              size: rs.w(24),
            ),
          ),
          SizedBox(width: rs.w(16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).homeBannerTitle, style: AppTextStyles.titleMedium),
              SizedBox(height: rs.h(4)),
              Text(
                S.of(context).homeBannerSubtitle,
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);
    final menuItems = [
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: s.noticesMenuLabel,
        onTap: () => context.push(HomePath.notices),
      ),
      _MenuItem(
        icon: Icons.manage_accounts_outlined,
        label: s.roleManagementMenuLabel,
        onTap: () => context.push(RolePath.root),
      ),
      _MenuItem(
        icon: Icons.people_outline,
        label: s.employeeAddMenuLabel,
        onTap: () => context.push(EmployeePath.contractMethod),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: rs.w(12),
      mainAxisSpacing: rs.h(12),
      childAspectRatio: 1.2,
      children: menuItems
          .map((item) => _buildMenuCard(context, item))
          .toList(),
    );
  }

  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    final rs = ResponsiveSize.of(context);

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: rs.py(24),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: rs.radius(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: rs.w(32), color: AppColors.textPrimary),
            SizedBox(height: rs.h(12)),
            Text(item.label, style: AppTextStyles.label),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}