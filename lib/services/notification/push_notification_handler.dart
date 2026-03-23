import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'push_provider.dart';
import 'device_token_service.dart';
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
  final DeviceTokenService _tokenService;
  final LocalNotificationService _localNotificationService;

  PushNotificationHandler(
    this._pushProvider,
    this._tokenService,
    this._localNotificationService,
  );

  void _handleTokenSyncResult(TokenSyncResult result) {
    switch (result.status) {
      case TokenSyncStatus.success:
        print('[정보] 토큰 동기화 성공');
      case TokenSyncStatus.noToken:
        print('[경고] ${result.message}');
      case TokenSyncStatus.invalidToken:
        // TODO: 토큰을 삭제하고 새로 발급받는 로직 추가
        print('[경고] ${result.message}');
      case TokenSyncStatus.serverError:
        // TODO: 재시도 로직 추가
        print('[오류] ${result.message}');
      case TokenSyncStatus.networkError:
        // TODO: 재시도 로직 추가
        print('[오류] ${result.message}');
      case TokenSyncStatus.unknownError:
        print('[오류] ${result.message}');
    }
  }

  /// 푸시 알림의 모든 초기화 과정을 전담합니다.
  Future<void> setup() async {
    // 1. 백그라운드 핸들러 등록
    _pushProvider.setBackgroundHandler(firebaseMessagingBackgroundHandler);
    print("set background handler");
    await _pushProvider.initialize();
    print("pushProvider initialized");

    // 3. 로컬 알림 서비스 초기화 (채널 생성)
    await _localNotificationService.initialize();
    print("localNotification service initialized");
    // 4. 전체 공지 토픽 구독
    await _pushProvider.subscribeToTopic('all_users');
    print("all_user topic subscription completed");
    // 5. 서버에 토큰 동기화
    final syncResult = await _tokenService.syncTokenToServer(
      onRefreshResult: _handleTokenSyncResult,
    );
    _handleTokenSyncResult(syncResult);

    // 6. 포그라운드 리스너: 로컬 알림으로 표시
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
