import 'package:go_router/go_router.dart';
import '../../../features/home/models/notice.dart';
import '../../../features/home/notice_detail_screen.dart';
import '../../../features/home/notices_screen.dart';

final homeSubRoutes = [
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
];
