import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/new_badge.dart';
import '../../core/theme/app_theme.dart';
import 'models/notice.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: API 호출로 대체
    final notices = mockNotices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
      ),
      body: ListView.separated(
        itemCount: notices.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, color: AppColors.borderGray),
        itemBuilder: (context, index) {
          return _NoticeListItem(
            notice: notices[index],
            onTap: () => context.push(
              '/home/notices/${notices[index].id}',
              extra: notices[index],
            ),
          );
        },
      ),
    );
  }
}

class _NoticeListItem extends StatelessWidget {
  final Notice notice;
  final VoidCallback onTap;

  const _NoticeListItem({required this.notice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (notice.isNew) ...[
                        const NewBadge(),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          notice.title,
                          style: AppTextStyles.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notice.description,
                    style: AppTextStyles.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(notice.date, style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
