import 'package:flutter/material.dart';
import '../../common/widgets/new_badge.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import 'models/notice.dart';

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;

  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return SingleChildScrollView(
      padding: rs.pxy(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (notice.isNew) ...[
            const NewBadge(),
            SizedBox(height: rs.h(12)),
          ],
          Text(notice.title, style: AppTextStyles.titleLarge),
          SizedBox(height: rs.h(8)),
          Text(notice.date, style: AppTextStyles.caption),
          SizedBox(height: rs.h(24)),
          const Divider(height: 1, color: AppColors.borderGray),
          SizedBox(height: rs.h(24)),
          Text(notice.description, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
