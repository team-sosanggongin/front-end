import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/app_logo.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 3),
                const AppLogo(),
                const Spacer(flex: 2),
                _KakaoLoginButton(
                  onPressed: () => context.push('/privacy-consent'),
                ),
                const SizedBox(height: 12),
                const Text(
                  '카카오계정으로 시작하기',
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.chat_bubble, color: Color(0xFF3C1E1E), size: 20),
        label: const Text(
          '카카오 로그인',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C1E1E),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFEE500),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
