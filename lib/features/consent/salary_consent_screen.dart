import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';

class SalaryConsentScreen extends StatelessWidget {
  // 마이페이지 계좌추가에서 진입했는지 여부
  // true  /my/accounts로 이동
  // false /home으로 이동
  final bool fromMyPage;

  const SalaryConsentScreen({super.key, this.fromMyPage = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildContent(context)),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }
//Todo : API?백오피스? 연결시 형식보고 교체
  Widget _buildContent(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final l = S.of(context);

    return SingleChildScrollView(
      padding: rs.px(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: rs.h(8)),
          Text(l.salaryConsentTitle, style: AppTextStyles.heading),
          SizedBox(height: rs.h(24)),
          _buildSection(
            context,
            title: l.salarySection1Title,
            content: l.salarySection1Content,
            bullets: [
              l.salaryBasePay,
              l.salaryWorkHours,
              l.salaryOvertimeHours,
              l.salaryBankAccount,
              l.salaryTaxInsurance,
              l.salaryLeaveHistory,
            ],
          ),
          SizedBox(height: rs.h(24)),
          _buildSection(
            context,
            title: l.salarySection2Title,
            content: l.salarySection2Content,
            bullets: [
              l.salaryUseCalculation,
              l.salaryUsePayslip,
              l.salaryUseInsurance,
              l.salaryUseTax,
              l.salaryUseLegalRecord,
              l.salaryUseDispute,
            ],
          ),
          SizedBox(height: rs.h(24)),
          _buildSection(
            context,
            title: l.salarySection3Title,
            content: l.salarySection3Content,
            bullets: const [],
          ),
          SizedBox(height: rs.h(32)),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required List<String> bullets,
  }) {
    final rs = ResponsiveSize.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        SizedBox(height: rs.h(8)),
        if (content.isNotEmpty) ...[
          Text(content, style: AppTextStyles.body),
          SizedBox(height: rs.h(8)),
        ],
        ...bullets.map(
              (b) => Padding(
            padding: EdgeInsets.only(left: rs.w(16), bottom: rs.h(4)),
            child: Text('• $b', style: AppTextStyles.body),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Padding(
      padding: rs.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          PrimaryButton(
            text: S.of(context).agreeButton,
            onPressed: () => context.push(RoutePath.accountVerification),
          ),
          SizedBox(height: rs.h(12)),
          // 나중에 하기 — 가입 플로우에서만 노출
          if (!fromMyPage)
            TextButton(
              onPressed: () => context.go(HomePath.root),
              child: Text(S.of(context).skipButton, style: AppTextStyles.link),
            ),
        ],
      ),
    );
  }
}