import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/notification/notification_providers.dart';
import 'utils/env_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // [환경 전환] localApi -> local (local 테스트)
  // EnvConfig.currentEnv = AppEnv.local;

  // [환경 전환] local -> localApi (실제 자바 서버와 연동)
  EnvConfig.currentEnv = AppEnv.localApi;
  print('[정보] 앱 시작 환경: ${EnvConfig.currentEnv.name}');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
    try {
      await ref.read(pushNotificationHandlerProvider).setup();
      print('[정보] 푸시 알림 서비스 설정 완료');
    } catch (e) {
      print('[오류] 푸시 알림 설정 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'platform',
      home: Scaffold(
        appBar: AppBar(title: const Text('Push Notification MVP')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              Text('현재 환경: ${EnvConfig.currentEnv.name}'),
              const Text('알림 서비스가 실행 중입니다.'),
            ],
          ),
        ),
      ),
    );
  }
}
