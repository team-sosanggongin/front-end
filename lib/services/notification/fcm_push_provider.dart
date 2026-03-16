import 'package:firebase_messaging/firebase_messaging.dart';
import 'push_provider.dart';

class FcmPushProvider implements PushProvider {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  Future<void> initialize() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Push permission status: ${settings.authorizationStatus}');
  }

  @override
  Future<String?> getToken() => _fcm.getToken();

  @override
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  @override
  void setBackgroundHandler(Future<void> Function(RemoteMessage message) handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  @override
  void onMessage(void Function(RemoteMessage message) handler) {
    FirebaseMessaging.onMessage.listen(handler);
  }

  @override
  void onNotificationOpenedApp(void Function(RemoteMessage message) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }

  @override
  Future<void> subscribeToTopic(String topic) => _fcm.subscribeToTopic(topic);
}
