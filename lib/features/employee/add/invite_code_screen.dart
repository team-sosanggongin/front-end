import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_size.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../employee_provider.dart';

class InviteCodeScreen extends ConsumerWidget {
  const InviteCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rs = ResponsiveSize.of(context);
    final s = S.of(context);
    final inviteAsync = ref.watch(inviteCodeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.inviteCodeTitle)),
      body: inviteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(s.networkError, style: AppTextStyles.body),
        ),
        data: (invite) {
          if (invite == null) return const SizedBox.shrink();
          return _buildContent(context, ref, rs, s, invite.code);
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      WidgetRef ref,
      ResponsiveSize rs,
      S s,
      String code,
      ) {
    return SingleChildScrollView(
      padding: rs.pxy(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Text(s.inviteCodeHeading, style: AppTextStyles.titleLarge),
          SizedBox(height: rs.h(8)),
          Text(
            s.inviteCodeSubtitle,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: rs.h(32)),
          QrImageView(
            data: code,
            version: QrVersions.auto,
            size: rs.w(180),
          ),
          SizedBox(height: rs.h(24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(code, style: AppTextStyles.titleLarge),
              SizedBox(width: rs.w(8)),
              IconButton(
                icon: Icon(
                  Icons.copy_outlined,
                  size: rs.w(20),
                  color: AppColors.textSecondary,
                ),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.inviteCodeCopied)),
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: rs.h(32)),
          const Divider(color: AppColors.borderGray),
          SizedBox(height: rs.h(24)),
          _buildKakaoShareButton(rs, code, s),
          SizedBox(height: rs.h(24)),
          PrimaryButton(
            text: s.inviteCodeDoneButton,
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }

  Widget _buildKakaoShareButton(ResponsiveSize rs, String code, S s) {
    return GestureDetector(
      onTap: () {
        // TODO: 카카오 SDK 공유 연동
        Share.share(code);
      },
      child: Container(
        width: double.infinity,
        height: rs.h(56),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE500),
          borderRadius: rs.radius(12),
        ),
        child: Center(
          child: Text(
            s.inviteCodeShareKakaoButton,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191919),
            ),
          ),
        ),
      ),
    );
  }
}