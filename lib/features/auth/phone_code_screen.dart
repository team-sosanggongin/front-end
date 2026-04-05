import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/auth_page_layout.dart';
import '../../core/router/route_path.dart';
import '../../common/widgets/code_input_box.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';

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
      context.push(ConsentPath.salary);
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
    final rs = ResponsiveSize.of(context);
    final l = S.of(context);

    return AuthPageLayout(
      title: l.verifyAuthCodeTitle,
      subtitle: l.verifyAuthCodeSubtitle,
      bottomButton: PrimaryButton(
        text: l.confirmButton,
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
            Padding(
              padding: EdgeInsets.only(top: rs.h(12)),
              child: Text(
                l.invalidAuthCodeError,
                style: AppTextStyles.errorText,
              ),
            ),
          SizedBox(height: rs.h(24)),
          Text(_formattedTime, style: AppTextStyles.timer),
          SizedBox(height: rs.h(8)),
          GestureDetector(
            onTap: _resendCode,
            child: Text(l.resendAuthCodeButton, style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }
}
