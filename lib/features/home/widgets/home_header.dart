import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/user_avatar.dart';
import '../../../core/router/route_path.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final bool isRoot;

  const HomeHeader({super.key, required this.isRoot});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final location = GoRouterState.of(context).uri.path;
    final title = _resolveTitle(context, location);

    return Padding(
      padding: rs.pxy(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          if (!isRoot) ...[
            GestureDetector(
              onTap: () => context.pop(),
              child: Padding(
                padding: EdgeInsets.only(right: rs.w(12)),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
            ),
            Text(title, style: AppTextStyles.appBarTitle),
          ] else
            Text(S.of(context).appTitle, style: AppTextStyles.heading),
          const Spacer(),
          if (!location.startsWith(MyPath.root))
            UserAvatar(onTap: () => context.push(MyPath.root)),
        ],
      ),
    );
  }

  String _resolveTitle(BuildContext context, String location) {
    final l = S.of(context);
    if (location.startsWith(HomePath.notices)) return l.noticesHeaderTitle;
    if (location.startsWith(MyPath.accounts)) return l.accountInfoHeaderTitle;
    if (location.startsWith(MyPath.root)) return l.myPageHeaderTitle;
    return '';
  }
}
