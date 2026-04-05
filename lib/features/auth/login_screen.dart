import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_logo.dart';
import '../../core/router/route_path.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: rs.px(24),
            child: Column(
              children: [
                const Spacer(flex: 3),
                const AppLogo(),
                const Spacer(flex: 2),
                _KakaoLoginButton(
                  onPressed: () => context.push(ConsentPath.privacy),
                ),
                SizedBox(height: rs.h(12)),
                Text(
                  S.of(context).startWithKakao,
                  style: AppTextStyles.subtitle,
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _KakaoLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return SizedBox(
      width: double.infinity,
      height: rs.h(56),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.chat_bubble, color: const Color(0xFF3C1E1E), size: rs.w(20)),
        label: Text(
          S.of(context).kakaoLoginButton,
          style: TextStyle(
            fontSize: rs.w(16),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3C1E1E),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFEE500),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: rs.radius(12),
          ),
        ),
      ),
    );
  }
}
