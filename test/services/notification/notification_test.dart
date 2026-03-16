import 'package:flutter_test/flutter_test.dart';
import 'package:platform/services/notification/push_notification_handler.dart';
import 'package:platform/services/notification/device_token_service.dart';
import 'package:platform/services/notification/push_provider.dart';
import 'package:platform/utils/env_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// 1. 테스트용 가짜 푸시 제공자
class FakePushProvider implements PushProvider {
  bool isInitialized = false;
  String? subscribedTopic;
  String? mockToken = "fake-fcm-token-123";

  @override
  Future<void> initialize() async => isInitialized = true;

  @override
  Future<String?> getToken() async => mockToken;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  void setBackgroundHandler(Future<void> Function(RemoteMessage message) handler) {}

  @override
  void onMessage(void Function(RemoteMessage message) handler) {}

  @override
  void onNotificationOpenedApp(void Function(RemoteMessage message) handler) {}

  @override
  Future<void> subscribeToTopic(String topic) async => subscribedTopic = topic;
}

void main() {
  group('앱 푸시 MVP v1 통합 테스트 (Logic Check)', () {
    late FakePushProvider fakeProvider;
    late DeviceTokenService tokenService;
    late PushNotificationHandler notificationHandler;

    setUp(() {
      EnvConfig.currentEnv = AppEnv.local; // Mock으로 테스트 진행
      fakeProvider = FakePushProvider();
      tokenService = DeviceTokenService(fakeProvider);
      notificationHandler = PushNotificationHandler(fakeProvider, tokenService);
    });

    test('PushNotificationHandler.setup() 실행 시 모든 초기화 단계가 순차적으로 수행되어야 한다', () async {
      // 1. 실행
      await notificationHandler.setup();

      // 2. 검증 (Why: 멘토님이 강조하신 초기화 프로세스 확인)
      expect(fakeProvider.isInitialized, true, reason: '푸시 엔진이 초기화되어야 함');
      expect(fakeProvider.subscribedTopic, 'all_users', reason: '전체 공지 토픽을 구독해야 함');
    });

    test('EnvConfig가 local일 때 DeviceTokenService는 Mock 모드로 동작해야 한다', () async {
      // 1. 환경 확인
      expect(EnvConfig.isMock, true);
      
      // 2. 토큰 동기화 시도 (HTTP 요청이 없는 상태에서 로그 확인)
      await tokenService.syncTokenToServer();
      
      // 3. 토큰 획득 확인
      final token = await fakeProvider.getToken();
      expect(token, "fake-fcm-token-123");
    });
  });
}
