import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/user_avatar.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'user_provider.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: API 연결 시 setUser() 호출로 교체
    // 현재는  mock 유저
    final user = ref.watch(userProvider) ??
        const UserModel(id: 'mock_001', name: '홍길동');

    final rs = ResponsiveSize.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: rs.h(24)),
            _buildProfile(context, user),
            SizedBox(height: rs.h(24)),
            const Divider(height: 1, color: AppColors.borderGray),
            _buildAccountMenu(context),
            const Divider(height: 1, color: AppColors.borderGray),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, UserModel user) {
    final rs = ResponsiveSize.of(context);

    return Padding(
      padding: rs.px(24),
      child: Row(
        children: [
          UserAvatar(size: rs.w(56)),
          SizedBox(width: rs.w(16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppTextStyles.titleMedium),
              SizedBox(height: rs.h(2)),
              Text(
                S.of(context).viewProfileLink,
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
    final rs = ResponsiveSize.of(context);

    return InkWell(
      onTap: () => context.push(MyPath.accounts),
      child: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(child: Text(S.of(context).accountInfoMenuLabel, style: AppTextStyles.body)),
            Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: rs.w(24)),
          ],
        ),
      ),
    );
  }
}