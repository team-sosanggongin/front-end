import 'package:firebase_messaging/firebase_messaging.dart';

abstract class PushProvider {
  Future<void> initialize();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  
  /// 명확한 타입을 위해 dynamic 대신 RemoteMessage 사용
  void setBackgroundHandler(Future<void> Function(RemoteMessage message) handler);
  void onMessage(void Function(RemoteMessage message) handler);
  void onNotificationOpenedApp(void Function(RemoteMessage message) handler);

  Future<void> subscribeToTopic(String topic);
}
