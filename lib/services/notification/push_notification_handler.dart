import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../core/env/firebase_options.dart';
import 'push_provider.dart';
import 'local_notification_service.dart';

/// 앱이 꺼져 있을 때 알림을 처리하는 콜백 (Top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background code exeuted");

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  print("Background message received: ${message.messageId}");
}

class PushNotificationHandler {
  final PushProvider _pushProvider;
  final LocalNotificationService _localNotificationService;
  bool _isSetUp = false;

  PushNotificationHandler(
    this._pushProvider,
    this._localNotificationService,
  );

  /// 푸시 알림 수신을 위한 초기화를 전담합니다.
  Future<void> setup() async {
    if (_isSetUp) return;
    _isSetUp = true;

    // 1. 백그라운드 핸들러 등록
    _pushProvider.setBackgroundHandler(firebaseMessagingBackgroundHandler);
    await _pushProvider.initialize();
    // 2. 로컬 알림 서비스 초기화 (채널 생성)
    await _localNotificationService.initialize();
    // 3. 전체 공지 토픽 구독
    await _pushProvider.subscribeToTopic('all_users');

    // TODO: onNotificationOpenedApp 리스너 등록 — 알림 탭 시 특정 화면으로 이동

    // 4. 포그라운드 리스너: 로컬 알림으로 표시
    _pushProvider.onMessage((message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotificationService.show(
          title: notification.title ?? '',
          body: notification.body ?? '',
          data: message.data,
        );
      }
    });
  }
}
