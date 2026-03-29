import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

class PrivacyConsentScreen extends StatelessWidget {
  const PrivacyConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildContent()),
            _buildBottomButton(context),
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
          const Text('개인정보 수집 및 이용 동의', style: AppTextStyles.heading),
          const SizedBox(height: 24),
          _buildSection(
            title: '1. 수집하는 개인정보 항목',
            content: '회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집하고 있습니다.',
            bullets: const [
              '필수항목: 이름, 휴대전화번호',
              '선택항목: 이메일 주소, 프로필 사진',
              '자동 수집 항목: 접속 로그, 쿠키, 접속 IP 정보',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '2. 개인정보의 수집 및 이용목적',
            content: '수집한 개인정보는 다음의 목적을 위해 활용됩니다.',
            bullets: const [
              '회원 가입 및 관리',
              '서비스 제공 및 계약 이행',
              '근태 관리 및 급여 지급',
              '고지사항 전달 및 공지사항 발송',
              '본인 확인 및 인증',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '3. 개인정보의 보유 및 이용기간',
            content:
            '회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.',
            bullets: const [
              '회원 탈퇴 시: 즉시 삭제',
              '법령에 따른 보관: 관련 법령에서 정한 기간',
            ],
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
        Text(content, style: AppTextStyles.body),
        const SizedBox(height: 8),
        ...bullets.map(
              (b) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text('• $b', style: AppTextStyles.body),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: PrimaryButton(
        text: '위 내용에 동의합니다',
        onPressed: () => context.push('/phone-verification'),
      ),
    );
  }
}