import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/user_avatar.dart';
import '../../core/theme/app_theme.dart';
import 'user_provider.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: API 연결 시 setUser() 호출로 교체
    // 현재는  mock 유저
    final user = ref.watch(userProvider) ??
        const UserModel(id: 'mock_001', name: '홍길동');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfile(user),
            const SizedBox(height: 24),
            const Divider(height: 1, color: AppColors.borderGray),
            _buildAccountMenu(context),
            const Divider(height: 1, color: AppColors.borderGray),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const UserAvatar(size: 56),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppTextStyles.titleMedium),
              const SizedBox(height: 2),
              Text(
                '프로필 보기',
                style: AppTextStyles.caption.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountMenu(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/my/accounts'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(child: Text('계좌 정보', style: AppTextStyles.body)),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }
}