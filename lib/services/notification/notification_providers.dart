import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fcm_push_provider.dart';
import 'push_notification_handler.dart';
import 'push_provider.dart';
import 'local_notification_service.dart';

final pushProvider = Provider<PushProvider>((ref) {
  return FcmPushProvider();
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

final pushNotificationHandlerProvider = Provider<PushNotificationHandler>((ref) {
  final provider = ref.watch(pushProvider);
  final localNotification = ref.watch(localNotificationServiceProvider);
  return PushNotificationHandler(provider, localNotification);
});
