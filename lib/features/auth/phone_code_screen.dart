import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/auth_page_layout.dart';
import '../../common/widgets/code_input_box.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'auth_provider.dart';

class PhoneCodeScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const PhoneCodeScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<PhoneCodeScreen> createState() => _PhoneCodeScreenState();
}

class _PhoneCodeScreenState extends ConsumerState<PhoneCodeScreen> {
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
    setState(() => _remainingSeconds = 180);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _resendCode() {
    _codeKey.currentState?.clear();
    setState(() {
      _hasError = false;
      _isFilled = false;
      _code = '';
    });
    ref.read(phoneProvider.notifier).requestCode(widget.phoneNumber);
    _startTimer();
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
    final phoneState = ref.watch(phoneProvider);

    ref.listen<PhoneState>(phoneProvider, (_, next) {
      switch (next) {
        case PhoneStateSuccess():
          context.push(ConsentPath.salary);
          ref.read(phoneProvider.notifier).resetState();
        case PhoneStateFailed():
          setState(() => _hasError = true);
          ref.read(phoneProvider.notifier).resetState();
        case PhoneStateError(:final message):
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          ref.read(phoneProvider.notifier).resetState();
        default:
          break;
      }
    });

    final isLoading = phoneState is PhoneStateLoading;

    return AuthPageLayout(
      title: l.verifyAuthCodeTitle,
      subtitle: l.verifyAuthCodeSubtitle,
      bottomButton: PrimaryButton(
        text: l.confirmButton,
        enabled: _isFilled && !isLoading,
        onPressed: _isFilled && !isLoading
            ? () => ref.read(phoneProvider.notifier).verifyCode(_code)
            : null,
      ),
      body: Column(
        children: [
          CodeInputBox(
            key: _codeKey,
            onCompleted: (code) => setState(() {
              _code = code;
              _isFilled = true;
            }),
            onChanged: () {
              final s = _codeKey.currentState;
              setState(() {
                _hasError = false;
                _code = s?.code ?? '';
                _isFilled = s?.isFilled ?? false;
              });
            },
            hasError: _hasError,
          ),
          if (_hasError)
            Padding(
              padding: EdgeInsets.only(top: rs.h(12)),
              child: Text(l.invalidAuthCodeError,
                  style: AppTextStyles.errorText),
            ),
          SizedBox(height: rs.h(24)),
          Text(_formattedTime, style: AppTextStyles.timer),
          SizedBox(height: rs.h(8)),
          GestureDetector(
            onTap: isLoading ? null : _resendCode,
            child: Text(l.resendAuthCodeButton, style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }
}