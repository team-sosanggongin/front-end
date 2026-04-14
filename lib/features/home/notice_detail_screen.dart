import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'notice_provider.dart';

class NoticeDetailScreen extends ConsumerWidget {
  final Notice notice;

  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(noticeDetailProvider(notice.id));
    final rs = ResponsiveSize.of(context);

    return detailState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _buildContent(context, rs, notice),
      data: (detail) => _buildContent(context, rs, detail ?? notice),
    );
  }

  Widget _buildContent(BuildContext context, ResponsiveSize rs, Notice data) {
    return SingleChildScrollView(
      padding: rs.pxy(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.title, style: AppTextStyles.titleLarge),
          SizedBox(height: rs.h(8)),
          Text(
            data.createdAt.substring(0, 10).replaceAll('-', '.'),
            style: AppTextStyles.caption,
          ),
          SizedBox(height: rs.h(24)),
          const Divider(height: 1, color: AppColors.borderGray),
          SizedBox(height: rs.h(24)),
          Text(data.content, style: AppTextStyles.body),
          SizedBox(height: rs.h(32)),
          PrimaryButton(
            text: S.of(context).confirmButton,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}