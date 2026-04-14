import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_logo.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rs = ResponsiveSize.of(context);
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (_, next) {
      switch (next) {
        case AuthStateSuccess(:final result):
          switch (result) {
            case LoginResultExistingUser():
              context.go(HomePath.root);
            case LoginResultNewUser():
              context.go(ConsentPath.privacy);
          }
        case AuthStateError():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).loginFailError)),
          );
          ref.read(authProvider.notifier).resetState();
        case AuthStateIdle():
        case AuthStateLoading():
          break;
      }
    });

    final isLoading = authState is AuthStateLoading;

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
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () => ref.read(authProvider.notifier).loginWithKakao(),
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
  const _KakaoLoginButton({required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return SizedBox(
      width: double.infinity,
      height: rs.h(56),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF3C1E1E),
          ),
        )
            : Icon(Icons.chat_bubble,
            color: const Color(0xFF3C1E1E), size: rs.w(20)),
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
            borderRadius: BorderRadius.circular(rs.w(12)),
          ),
        ),
      ),
    );
  }
}