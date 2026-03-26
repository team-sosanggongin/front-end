import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/home/home_shell_layout.dart';
import '../../../features/home/models/notice.dart';
import '../../../features/home/notice_detail_screen.dart';
import '../../../features/home/notices_screen.dart';

final homeShellNavigatorKey = GlobalKey<NavigatorState>();

final homeShellRoute = ShellRoute(
  navigatorKey: homeShellNavigatorKey,
  builder: (context, state, child) => HomeShellLayout(child: child),
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/home/notices',
      builder: (context, state) => const NoticesScreen(),
    ),
    GoRoute(
      path: '/home/notices/:id',
      builder: (context, state) {
        final notice = state.extra as Notice;
        return NoticeDetailScreen(notice: notice);
      },
    ),
  ],
);
