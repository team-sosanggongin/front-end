import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_logo.dart';
import '../../common/widgets/maintenance_dialog.dart';
import '../../common/widgets/update_dialog.dart';
import '../../core/router/route_path.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';
import '../../l10n/app_localizations.dart';
import '../app/application/app_controller.dart';
import '../auth/application/auth_controller.dart';

// TODO: 실제 스토어 URL로 교체
const _androidStoreUrl =
    'https://play.google.com/store/apps/details?id=com.yourcompany.app';
const _iosStoreUrl = 'https://apps.apple.com/app/idXXXXXXXXX';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _handled = false;
  bool _delayDone = false;
  AppCheckResult? _pendingResult;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _delayDone = true;
      if (_pendingResult != null) _handleResult(_pendingResult!);
    });
  }

  Future<void> _handleResult(AppCheckResult result) async {
    if (_handled || !mounted) return;
    _handled = true;

    switch (result) {
      case AppCheckOk():
      // 토큰 유무에 따라 홈 or 로그인 분기
        final hasToken = await ref
            .read(authControllerProvider.notifier)
            .hasValidToken();
        if (!mounted) return;
        context.go(hasToken ? HomePath.root : AuthPath.login);

      case AppCheckMaintenance(:final reason, :final startedAt, :final endedAt):
        MaintenanceDialog.show(
          context,
          reason: reason,
          startedAt: startedAt,
          endedAt: endedAt,
        );

      case AppCheckForceUpdate(:final latestVersion, :final reason):
        UpdateDialog.show(
          context,
          latestVersion: latestVersion,
          isForced: true,
          reason: reason,
          storeUrl: Platform.isIOS ? _iosStoreUrl : _androidStoreUrl,
        );

      case AppCheckOptionalUpdate(:final latestVersion, :final reason):
        UpdateDialog.show(
          context,
          latestVersion: latestVersion,
          isForced: false,
          reason: reason,
          storeUrl: Platform.isIOS ? _iosStoreUrl : _androidStoreUrl,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AppCheckResult>>(
      appControllerProvider,
          (_, next) {
        next.whenData((result) {
          if (_delayDone) {
            _handleResult(result);
          } else {
            _pendingResult = result;
          }
        });
      },
    );

    final state = ref.watch(appControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Center(
        child: state.hasError
            ? _ErrorView(
          onRetry: () {
            _handled = false;
            _delayDone = false;
            _pendingResult = null;
            ref.read(appControllerProvider.notifier).retry();
            Future.delayed(const Duration(seconds: 2), () {
              if (!mounted) return;
              _delayDone = true;
              if (_pendingResult != null) _handleResult(_pendingResult!);
            });
          },
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const AppLogo(),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                bottom: ResponsiveSize.of(context).h(48),
              ),
              child: const _LoadingDots(),
            ),
          ],
        ),
      ),
    );
  }
}

//에러

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.of(context).networkError, style: AppTextStyles.subtitle),
        SizedBox(height: rs.h(16)),
        GestureDetector(
          onTap: onRetry,
          child: Text(S.of(context).retryButton, style: AppTextStyles.link),
        ),
      ],
    );
  }
}


class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final rs = ResponsiveSize.of(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final opacity =
            (((_controller.value - delay) % 1.0) < 0.5) ? 1.0 : 0.3;
            return Container(
              width: rs.w(8),
              height: rs.w(8),
              margin: EdgeInsets.symmetric(horizontal: rs.w(4)),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}