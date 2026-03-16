import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'push_provider.dart';
import 'device_token_service.dart';

/// 앱이 꺼져 있을 때 알림을 처리하는 콜백 (Top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Background message received: ${message.messageId}");
}

class PushNotificationHandler {
  final PushProvider _pushProvider;
  final DeviceTokenService _tokenService;

  PushNotificationHandler(this._pushProvider, this._tokenService);

  /// 푸시 알림의 모든 초기화 과정을 전담합니다.
  Future<void> setup() async {
    // 1. 백그라운드 핸들러 등록
    _pushProvider.setBackgroundHandler(firebaseMessagingBackgroundHandler);

    // 2. 푸시 서비스 초기화 (권한 요청 등)
    await _pushProvider.initialize();
    
    // 3. 전체 공지 토픽 구독
    await _pushProvider.subscribeToTopic('all_users');

    // 4. 서버에 토큰 동기화
    await _tokenService.syncTokenToServer();

    // 5. 포그라운드 리스너 설정
    _pushProvider.onMessage((message) {
      print('Foreground message: ${message.notification?.title}');
    });

    _pushProvider.onNotificationOpenedApp((message) {
      print('Notification clicked: ${message.notification?.title}');
    });
  }
}
