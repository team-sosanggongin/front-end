import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildBanner(),
          const SizedBox(height: 20),
          _buildMenuGrid(context),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EDFF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF5B9BF3),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('새로운 교육 시스템', style: AppTextStyles.titleMedium),
              SizedBox(height: 4),
              Text(
                '직원 교육을 더 쉽게 관리하세요',
                style: AppTextStyles.subtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: '공지사항',
        onTap: () => context.push('/home/notices'),
      ),
    ];

    return Row(
      children: menuItems.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: item == menuItems.last ? 0 : 12,
            ),
            child: _buildMenuCard(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMenuCard(_MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(item.icon, size: 32, color: AppColors.textPrimary),
            const SizedBox(height: 12),
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
