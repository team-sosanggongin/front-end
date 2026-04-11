import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'services/notification/notification_providers.dart';
import 'utils/env_config.dart';
import 'core/env/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('[정보] 앱 시작 환경: ${EnvConfig.defaultEnv.name}');
  KakaoSdk.init(nativeAppKey: EnvConfig.kakaoNativeAppKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    print('[디버그] 푸시 알림 서비스 설정 시작...');
    await ref.read(pushNotificationHandlerProvider).setup();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'platform',
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      //국제화시 변경 구조만잡고 영어만 예시로 만들어봄 영어전환시'en'테스트 확인 완료
      locale: const Locale('ko'),
    );
  }
}
