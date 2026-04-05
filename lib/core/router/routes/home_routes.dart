import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../route_path.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/home/home_shell_layout.dart';
import '../../../features/home/models/notice.dart';
import '../../../features/home/notice_detail_screen.dart';
import '../../../features/home/notices_screen.dart';
import '../../../features/my/my_page_screen.dart';
import '../../../features/account/account_list_screen.dart';

final homeShellNavigatorKey = GlobalKey<NavigatorState>();

final homeShellRoute = ShellRoute(
  navigatorKey: homeShellNavigatorKey,
  builder: (context, state, child) => HomeShellLayout(child: child),
  routes: [
    GoRoute(
      path: HomePath.root,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: HomePath.notices,
      builder: (context, state) => const NoticesScreen(),
    ),
    GoRoute(
      path: '${HomePath.notices}/:id',
      builder: (context, state) {
        final notice = state.extra as Notice;
        return NoticeDetailScreen(notice: notice);
      },
    ),
    GoRoute(
      path: MyPath.root,
      builder: (context, state) => const MyPageScreen(),
    ),
    GoRoute(
      path: MyPath.accounts,
      builder: (context, state) => const AccountListScreen(),
    ),
  ],
);
