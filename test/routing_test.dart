import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:platform/l10n/app_localizations.dart';
import 'package:platform/features/auth/login_screen.dart';
import 'package:platform/features/auth/phone_verification_screen.dart';
import 'package:platform/features/auth/phone_code_screen.dart';
import 'package:platform/features/splash/splash_screen.dart';
import 'package:platform/features/home/home_screen.dart';
import 'package:platform/features/home/notices_screen.dart';
import 'package:platform/features/home/notice_detail_screen.dart';
import 'package:platform/features/home/models/notice.dart';
import 'package:platform/features/consent/privacy_consent_screen.dart';
import 'package:platform/features/consent/salary_consent_screen.dart';
import 'package:platform/features/account/account_verification_screen.dart';

// router test
// ─── 헬퍼 ────────────────────────────────────────────────
GoRouter _buildTestRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/privacy-consent', builder: (context, state) => const PrivacyConsentScreen()),
      GoRoute(path: '/phone-verification', builder: (context, state) => const PhoneVerificationScreen()),
      GoRoute(
        path: '/phone-code',
        builder: (context, state) => PhoneCodeScreen(phoneNumber: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: '/salary-consent',
        builder: (context, state) => SalaryConsentScreen(fromMyPage: state.extra as bool? ?? false),
      ),
      GoRoute(path: '/account-verification', builder: (context, state) => const AccountVerificationScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/home/notices', builder: (context, state) => const NoticesScreen()),
      GoRoute(
        path: '/home/notices/:id',
        builder: (context, state) => NoticeDetailScreen(notice: state.extra as Notice),
      ),
    ],
  );
}

Widget _buildTestApp(GoRouter router) {
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: const Locale('ko'),
    ),
  );
}

const _mockNotice = Notice(
  id: 'notice_001',
  title: '정기 휴무일 안내',
  description: '매주 월요일은 정기 휴무일입니다.',
  date: '2026.03.05',
  isNew: true,
);

void main() {
  // 랜더링 확인
  group('화면 렌더링', () {
    testWidgets('스플래시', (tester) async {
      final router = _buildTestRouter('/splash');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pump();
      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('로그인', (tester) async {
      final router = _buildTestRouter('/login');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('개인정보동의', (tester) async {
      final router = _buildTestRouter('/privacy-consent');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(PrivacyConsentScreen), findsOneWidget);
    });

    testWidgets('전화번호 인증', (tester) async {
      final router = _buildTestRouter('/phone-verification');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(PhoneVerificationScreen), findsOneWidget);
    });

    testWidgets('인증번호 입력', (tester) async {
      final router = _buildTestRouter('/phone-code');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(PhoneCodeScreen), findsOneWidget);
    });

    testWidgets('급여동의', (tester) async {
      final router = _buildTestRouter('/salary-consent');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(SalaryConsentScreen), findsOneWidget);
    });

    testWidgets('계좌인증', (tester) async {
      final router = _buildTestRouter('/account-verification');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(AccountVerificationScreen), findsOneWidget);
    });

    testWidgets('홈', (tester) async {
      final router = _buildTestRouter('/home');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('공지사항 목록', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            locale: const Locale('ko'),
            home: Scaffold(
              body: const NoticesScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('공지사항 상세', (tester) async {
      final router = GoRouter(
        initialLocation: '/home/notices/notice_001',
        initialExtra: _mockNotice,
        routes: [
          GoRoute(
            path: '/home/notices/:id',
            builder: (context, state) => NoticeDetailScreen(notice: state.extra as Notice),
          ),
        ],
      );
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();

      expect(find.byType(NoticeDetailScreen), findsOneWidget);
      //공지 내용이 맞게 표시되는지
      expect(find.text('정기 휴무일 안내'), findsOneWidget);
    });
  });


  // 급여동의 분기 테스트
  group('급여동의 분기', () {
    testWidgets('가입 플로우 - 나중에 하기 노출', (tester) async {
      final router = _buildTestRouter('/salary-consent');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();

      expect(find.text('나중에 하기'), findsOneWidget);
    });

    testWidgets('마이페이지 - 나중에 하기 없음', (tester) async {
      final router = GoRouter(
        initialLocation: '/salary-consent',
        routes: [
          GoRoute(
            path: '/salary-consent',
            builder: (context, state) => const SalaryConsentScreen(fromMyPage: true),
          ),
        ],
      );
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();

      expect(find.text('나중에 하기'), findsNothing);
    });
  });
}