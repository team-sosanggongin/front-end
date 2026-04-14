import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'notice_provider.dart';

class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noticeListProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).networkError, style: AppTextStyles.body),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  ref.read(noticeListProvider.notifier).fetch(refresh: true),
              child: Text(S.of(context).retryButton),
            ),
          ],
        ),
      ),
      data: (notices) => notices.isEmpty
          ? Center(
        child: Text(
          S.of(context).noNotices,
          style:
          AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
      )
          : ListView.separated(
        itemCount: notices.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, color: AppColors.borderGray),
        itemBuilder: (context, index) => _NoticeListItem(
          notice: notices[index],
          onTap: () => context.push(
            HomePath.noticeDetail(notices[index].id.toString()),
            extra: notices[index],
          ),
        ),
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
    final rs = ResponsiveSize.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: rs.pxy(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: AppTextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: rs.h(6)),
                  Text(
                    notice.content,
                    style: AppTextStyles.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: rs.h(4)),
                  Text(
                    notice.createdAt.substring(0, 10).replaceAll('-', '.'),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            SizedBox(width: rs.w(8)),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: rs.w(24),
            ),
          ],
        ),
      ),
    );
  }
}