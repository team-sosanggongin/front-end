import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sosangongin_platform/features/account/account_verification_screen.dart';
import 'package:sosangongin_platform/features/auth/login_screen.dart';
import 'package:sosangongin_platform/features/auth/phone_code_screen.dart';
import 'package:sosangongin_platform/features/auth/phone_verification_screen.dart';
import 'package:sosangongin_platform/features/consent/privacy_consent_screen.dart';
import 'package:sosangongin_platform/features/consent/salary_consent_screen.dart';
import 'package:sosangongin_platform/features/home/home_screen.dart';
import 'package:sosangongin_platform/features/home/notice_detail_screen.dart';
import 'package:sosangongin_platform/features/home/notice_provider.dart';
import 'package:sosangongin_platform/features/home/notices_screen.dart';
import 'package:sosangongin_platform/features/splash/splash_screen.dart';
import 'package:sosangongin_platform/features/role/role_add_screen.dart';
import 'package:sosangongin_platform/features/role/role_detail_screen.dart';
import 'package:sosangongin_platform/features/role/role_list_screen.dart';
import 'package:sosangongin_platform/features/role/role_provider.dart';
import 'package:sosangongin_platform/features/employee/add/contract_method_screen.dart';
import 'package:sosangongin_platform/features/employee/add/invite_code_screen.dart';
import 'package:sosangongin_platform/features/employee/employee_detail_screen.dart';
import 'package:sosangongin_platform/features/employee/employee_list_screen.dart';
import 'package:sosangongin_platform/features/employee/employee_provider.dart';
import 'package:sosangongin_platform/features/employee/employee_role_select_screen.dart';
import 'package:sosangongin_platform/core/network/dio_provider.dart';
import 'package:sosangongin_platform/l10n/app_localizations.dart';

// ── 헬퍼 ─────────────────────────────────────────────────

GoRouter _buildTestRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/privacy-consent',
        builder: (context, state) => const PrivacyConsentScreen(),
      ),
      GoRoute(
        path: '/phone-verification',
        builder: (context, state) => const PhoneVerificationScreen(),
      ),
      GoRoute(
        path: '/phone-code',
        builder: (context, state) =>
            PhoneCodeScreen(phoneNumber: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: '/salary-consent',
        builder: (context, state) =>
            SalaryConsentScreen(fromMyPage: state.extra as bool? ?? false),
      ),
      GoRoute(
        path: '/account-verification',
        builder: (context, state) => const AccountVerificationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/home/notices',
        builder: (context, state) => const NoticesScreen(),
      ),
      GoRoute(
        path: '/home/notices/:id',
        builder: (context, state) =>
            NoticeDetailScreen(notice: state.extra as Notice),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleListScreen(),
      ),
      GoRoute(
        path: '/role/add',
        builder: (context, state) => const RoleAddScreen(),
      ),
      GoRoute(
        path: '/role/detail',
        builder: (context, state) =>
            RoleDetailScreen(role: state.extra as RoleModel),
      ),
      GoRoute(
        path: '/employee',
        builder: (context, state) => const EmployeeListScreen(),
      ),
      GoRoute(
        path: '/employee/detail',
        builder: (context, state) =>
            EmployeeDetailScreen(employee: state.extra as EmployeeModel),
      ),
      GoRoute(
        path: '/employee/add/role-select',
        builder: (context, state) => const EmployeeRoleSelectScreen(),
      ),
      GoRoute(
        path: '/employee/add/contract-method',
        builder: (context, state) => const ContractMethodScreen(),
      ),
      GoRoute(
        path: '/employee/add/invite-code',
        builder: (context, state) => const InviteCodeScreen(),
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

// Mock 데이터

final _mockNotice = Notice(
  id: 1,
  title: '정기 휴무일 안내',
  content: '매주 월요일은 정기 휴무일입니다.',
  authorName: '관리자',
  isPinned: true,
  viewCount: 10,
  createdAt: DateTime.now().toIso8601String(),
);

final _mockRole = RoleModel(
  id: 1,
  name: '매니저',
  description: 'manager',
  permissions: const [],
);

final _mockEmployee = EmployeeModel(
  id: 'emp_001',
  name: '김민수',
  role: _mockRole,
  startDate: '2024.01.01',
  status: EmployeeStatus.active,
);

// ── 화면 렌더링 테스트 ────────────────────────────────────

void main() {
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
            home: const Scaffold(body: NoticesScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NoticesScreen), findsOneWidget);
    });

    testWidgets('공지사항 상세', (tester) async {
      final router = GoRouter(
        initialLocation: '/home/notices/1',
        initialExtra: _mockNotice,
        routes: [
          GoRoute(
            path: '/home/notices/:id',
            builder: (context, state) =>
                NoticeDetailScreen(notice: state.extra as Notice),
          ),
        ],
      );
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(NoticeDetailScreen), findsOneWidget);
      expect(find.text('정기 휴무일 안내'), findsOneWidget);
    });

    testWidgets('역할 목록', (tester) async {
      final router = _buildTestRouter('/role');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(RoleListScreen), findsOneWidget);
    });

    testWidgets('역할 추가', (tester) async {
      final router = _buildTestRouter('/role/add');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(RoleAddScreen), findsOneWidget);
    });

    testWidgets('역할 상세', (tester) async {
      final router = GoRouter(
        initialLocation: '/role/detail',
        initialExtra: _mockRole,
        routes: [
          GoRoute(
            path: '/role/detail',
            builder: (context, state) =>
                RoleDetailScreen(role: state.extra as RoleModel),
          ),
        ],
      );
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(RoleDetailScreen), findsOneWidget);
    });

    testWidgets('직원 목록', (tester) async {
      final router = _buildTestRouter('/employee');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(EmployeeListScreen), findsOneWidget);
    });

    testWidgets('직원 상세', (tester) async {
      final router = GoRouter(
        initialLocation: '/employee/detail',
        initialExtra: _mockEmployee,
        routes: [
          GoRoute(
            path: '/employee/detail',
            builder: (context, state) =>
                EmployeeDetailScreen(employee: state.extra as EmployeeModel),
          ),
        ],
      );
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(EmployeeDetailScreen), findsOneWidget);
    });

    testWidgets('역할 선택', (tester) async {
      final router = _buildTestRouter('/employee/add/role-select');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(EmployeeRoleSelectScreen), findsOneWidget);
    });

    testWidgets('계약방식 선택', (tester) async {
      final router = _buildTestRouter('/employee/add/contract-method');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(ContractMethodScreen), findsOneWidget);
    });

    testWidgets('초대코드', (tester) async {
      final router = _buildTestRouter('/employee/add/invite-code');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.byType(InviteCodeScreen), findsOneWidget);
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
            builder: (context, state) =>
            const SalaryConsentScreen(fromMyPage: true),
          ),
        ],
      );
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pumpAndSettle();
      expect(find.text('나중에 하기'), findsNothing);
    });
  });

  // 역할 관리 첫 진입 분기

  group('역할 관리 첫 진입 분기', () {
    testWidgets('역할 없을 때 — empty state 노출', (tester) async {
      // roleListProvider를 빈 목록으로 override
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            roleListProvider.overrideWith(
                  (ref) => RoleListNotifier(ref.read(dioProvider))
                ..state = const AsyncData([]),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            locale: const Locale('ko'),
            home: const Scaffold(body: RoleListScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('역할을 만들어보세요'), findsOneWidget);
    });

    testWidgets('역할 있을 때 — 목록 노출', (tester) async {
      final router = _buildTestRouter('/role');
      await tester.pumpWidget(_buildTestApp(router));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('역할을 만들어보세요'), findsNothing);
    });
  });
}