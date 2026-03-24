import 'package:flutter/material.dart';
import '../../common/widgets/new_badge.dart';
import '../../core/theme/app_theme.dart';
import 'models/notice.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;

  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notice.isNew) ...[
              const NewBadge(),
              const SizedBox(height: 12),
            ],
            Text(notice.title, style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(notice.date, style: AppTextStyles.caption),
            const SizedBox(height: 24),
            const Divider(height: 1, color: AppColors.borderGray),
            const SizedBox(height: 24),
            Text(notice.description, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
