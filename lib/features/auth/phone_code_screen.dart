import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/auth_page_layout.dart';
import '../../common/widgets/code_input_box.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

class PhoneCodeScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneCodeScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneCodeScreen> createState() => _PhoneCodeScreenState();
}

class _PhoneCodeScreenState extends State<PhoneCodeScreen> {
  final _codeKey = GlobalKey<CodeInputBoxState>();
  Timer? _timer;
  int _remainingSeconds = 180;
  bool _hasError = false;
  bool _isFilled = false;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 180;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds--;
      });
    });
  }

  void _resendCode() {
    _codeKey.currentState?.clear();
    setState(() {
      _hasError = false;
      _isFilled = false;
      _code = '';
    });
    _startTimer();
  }

  void _onCodeCompleted(String code) {
    setState(() {
      _code = code;
      _isFilled = true;
    });
  }

  void _onCodeChanged() {
    final state = _codeKey.currentState;
    setState(() {
      _hasError = false;
      _code = state?.code ?? '';
      _isFilled = state?.isFilled ?? false;
    });
  }

  void _verify() {
    // TODO: API 호출로 인증번호 검증
    _verifyCode(_code);
  }

  Future<void> _verifyCode(String code) async {
    // TODO: 실제 API 호출로 대체
    if (code == '000000') {
      context.push('/salary-consent');
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageLayout(
      title: '인증번호 확인',
      subtitle: '휴대폰으로 전송된 6자리 번호를 입력해주세요',
      bottomButton: PrimaryButton(
        text: '확인',
        enabled: _isFilled,
        onPressed: _verify,
      ),
      body: Column(
        children: [
          CodeInputBox(
            key: _codeKey,
            onCompleted: _onCodeCompleted,
            onChanged: _onCodeChanged,
            hasError: _hasError,
          ),
          if (_hasError)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                '인증번호가 올바르지 않습니다. 다시 확인해주세요',
                style: AppTextStyles.errorText,
              ),
            ),
          const SizedBox(height: 24),
          Text(_formattedTime, style: AppTextStyles.timer),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _resendCode,
            child: const Text('인증번호 재발송', style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }
}
