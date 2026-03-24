import 'package:go_router/go_router.dart';
import '../../../features/auth/login_screen.dart';
import '../../../features/auth/phone_code_screen.dart';
import '../../../features/auth/phone_verification_screen.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/splash/splash_screen.dart';

final rootRoutes = [
  GoRoute(
    path: '/splash',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/phone-verification',
    builder: (context, state) => const PhoneVerificationScreen(),
  ),
  GoRoute(
    path: '/phone-code',
    builder: (context, state) {
      final phoneNumber = state.extra as String? ?? '';
      return PhoneCodeScreen(phoneNumber: phoneNumber);
    },
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomeScreen(),
  ),
];
