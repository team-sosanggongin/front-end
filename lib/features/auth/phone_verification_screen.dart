import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/auth_page_layout.dart';
import '../../common/widgets/primary_button.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'auth_provider.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
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
    setState(() => _isValid = phone.length >= 10 && phone.length <= 11);
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final l = S.of(context);
    final phoneState = ref.watch(phoneProvider);

    ref.listen<PhoneState>(phoneProvider, (_, next) {
      switch (next) {
        case PhoneStateSent():
          final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
          context.push(AuthPath.phoneCode, extra: phone);
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
      title: l.phoneVerificationTitle,
      subtitle: l.phoneVerificationSubtitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.phoneNumberLabel, style: AppTextStyles.label),
          SizedBox(height: rs.h(8)),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            style: AppTextStyles.body,
            decoration: AppInputDecorations.outlined(hintText: l.phoneNumberHint),
          ),
          SizedBox(height: rs.h(16)),
          PrimaryButton(
            text: l.getAuthCodeButton,
            enabled: _isValid && !isLoading,
            onPressed: _isValid && !isLoading
                ? () => ref
                .read(phoneProvider.notifier)
                .requestCode(
              _phoneController.text.replaceAll(RegExp(r'\D'), ''),
            )
                : null,
          ),
        ],
      ),
    );
  }
}