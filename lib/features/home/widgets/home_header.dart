import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/user_avatar.dart';
import '../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final bool isRoot;

  const HomeHeader({super.key, required this.isRoot});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final title = _resolveTitle(location);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          if (!isRoot) ...[
            GestureDetector(
              onTap: () => context.pop(),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
            ),
            Text(title, style: AppTextStyles.appBarTitle),
          ] else
            const Text('소상공인', style: AppTextStyles.heading),
          const Spacer(),
          const UserAvatar(),
        ],
      ),
    );
  }

  String _resolveTitle(String location) {
    if (location.startsWith('/home/notices')) return '공지사항';
    return '';
  }
}
