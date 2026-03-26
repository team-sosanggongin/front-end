import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/auth_page_layout.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validate);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validate() {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _isValid = phone.length >= 10 && phone.length <= 11;
    });
  }

  void _requestCode() {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    context.push('/phone-code', extra: phone);
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: '휴대폰 인증',
      subtitle: '안전한 서비스 이용을 위해 본인 인증을 진행합니다',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('휴대폰 번호', style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            style: AppTextStyles.body,
            decoration: AppInputDecorations.outlined(
              hintText: '01012345678',
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: '인증번호 받기',
            enabled: _isValid,
            onPressed: _requestCode,
          ),
        ],
      ),
    );
  }
}
