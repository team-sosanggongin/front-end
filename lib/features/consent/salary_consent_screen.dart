import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

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
            Expanded(child: _buildContent()),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }
//Todo : API?백오피스? 연결시 형식보고 교체
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('급여 정보 수집 동의', style: AppTextStyles.heading),
          const SizedBox(height: 24),
          _buildSection(
            title: '1. 수집하는 급여 정보',
            content: '회사는 정확한 급여 지급 및 관리를 위해 다음과 같은 정보를 수집합니다.',
            bullets: const [
              '기본급 및 수당 정보',
              '근무 시간 및 근태 정보',
              '연장근무, 야간근무, 휴일근무 시간',
              '급여 지급 계좌 정보',
              '소득세 및 4대 보험 관련 정보',
              '연차 사용 내역',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '2. 급여 정보의 이용 목적',
            content: '수집한 급여 정보는 다음의 목적으로 이용됩니다.',
            bullets: const [
              '정확한 급여 계산 및 지급',
              '급여 명세서 작성 및 제공',
              '4대 보험 신고 및 관리',
              '소득세 원천징수 및 연말정산',
              '근로기준법에 따른 법정 기록 유지',
              '급여 관련 분쟁 및 분쟁 해결',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '3. 급여 정보의 보유 및 이용 기간',
            content: '급여 관련 정보는 관련 법령에 따라 다음과 같이 보관됩니다.',
            bullets: const [],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required List<String> bullets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        if (content.isNotEmpty) ...[
          Text(content, style: AppTextStyles.body),
          const SizedBox(height: 8),
        ],
        ...bullets.map(
              (b) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text('• $b', style: AppTextStyles.body),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          PrimaryButton(
            text: '위 내용에 동의합니다',
            onPressed: () => context.push('/account-verification'),
          ),
          const SizedBox(height: 12),
          // 나중에 하기 — 가입 플로우에서만 노출
          if (!fromMyPage)
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('나중에 하기', style: AppTextStyles.link),
            ),
        ],
      ),
    );
  }
}