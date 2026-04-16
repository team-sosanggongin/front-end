import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/primary_button.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'consent_provider.dart';

class PrivacyConsentScreen extends ConsumerWidget {
  const PrivacyConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(consentProvider);

    ref.listen<ConsentState>(consentProvider, (_, next) {
      switch (next) {
        case ConsentStateSuccess():
          context.push(AuthPath.phoneVerification);
        case ConsentStateError(:final message):
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          ref.read(consentProvider.notifier).resetState();
        case ConsentStateIdle():
        case ConsentStateLoading():
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildContent(context)),
            _buildBottomButton(context, ref, state),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final l = S.of(context);

    return SingleChildScrollView(
      padding: rs.px(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: rs.h(8)),
          Text(l.privacyConsentTitle, style: AppTextStyles.heading),
          SizedBox(height: rs.h(24)),
          _buildSection(context,
              title: l.privacySection1Title,
              content: l.privacySection1Content,
              bullets: [
                l.privacyRequiredItems,
                l.privacyOptionalItems,
                l.privacyAutoCollectedItems,
              ]),
          SizedBox(height: rs.h(24)),
          _buildSection(context,
              title: l.privacySection2Title,
              content: l.privacySection2Content,
              bullets: [
                l.privacyUseMemberManagement,
                l.privacyUseServiceProvision,
                l.privacyUseAttendanceSalary,
                l.privacyUseNoticeDelivery,
                l.privacyUseIdentityVerification,
              ]),
          SizedBox(height: rs.h(24)),
          _buildSection(context,
              title: l.privacySection3Title,
              content: l.privacySection3Content,
              bullets: [
                l.privacyRetentionWithdrawal,
                l.privacyRetentionLegal,
              ]),
          SizedBox(height: rs.h(32)),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title,
        required String content,
        required List<String> bullets}) {
    final rs = ResponsiveSize.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        SizedBox(height: rs.h(8)),
        Text(content, style: AppTextStyles.body),
        SizedBox(height: rs.h(8)),
        ...bullets.map((b) => Padding(
          padding: EdgeInsets.only(left: rs.w(16), bottom: rs.h(4)),
          child: Text('• $b', style: AppTextStyles.body),
        )),
      ],
    );
  }

  Widget _buildBottomButton(
      BuildContext context, WidgetRef ref, ConsentState state) {
    final rs = ResponsiveSize.of(context);
    return Padding(
      padding: rs.fromLTRB(24, 0, 24, 24),
      child: PrimaryButton(
        text: S.of(context).agreeButton,
        enabled: state is! ConsentStateLoading,
        onPressed: state is ConsentStateLoading
            ? null
            : () => ref.read(consentProvider.notifier).agreeAll(),
      ),
    );
  }
}