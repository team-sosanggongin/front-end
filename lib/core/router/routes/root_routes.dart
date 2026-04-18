import 'package:go_router/go_router.dart';
import '../route_path.dart';
import '../../../features/auth/login_screen.dart';
import '../../../features/auth/phone_code_screen.dart';
import '../../../features/auth/phone_verification_screen.dart';
import '../../../features/splash/splash_screen.dart';
import '../../../features/consent/privacy_consent_screen.dart';
import '../../../features/consent/salary_consent_screen.dart';
import '../../../features/account/account_verification_screen.dart';

final rootRoutes = [
  GoRoute(
    path: RoutePath.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: AuthPath.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: ConsentPath.privacy,
    builder: (context, state) => const PrivacyConsentScreen(),
  ),
  GoRoute(
    path: AuthPath.phoneVerification,
    builder: (context, state) => const PhoneVerificationScreen(),
  ),
  GoRoute(
    path: AuthPath.phoneCode,
    builder: (context, state) {
      final phoneNumber = state.extra as String? ?? '';
      return PhoneCodeScreen(phoneNumber: phoneNumber);
    },
  ),
  GoRoute(
    path: ConsentPath.salary,
    builder: (context, state) {
      final fromMyPage = state.extra as bool? ?? false;
      return SalaryConsentScreen(fromMyPage: fromMyPage);
    },
  ),
  GoRoute(
    path: RoutePath.accountVerification,
    builder: (context, state) {
      final fromMyPage = state.extra as bool? ?? false;
      return AccountVerificationScreen(fromMyPage: fromMyPage);
    },
  ),
];
