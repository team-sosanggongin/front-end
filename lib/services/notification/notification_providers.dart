import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fcm_push_provider.dart';
import 'push_notification_handler.dart';
import 'push_provider.dart';
import 'device_token_service.dart';

final pushProvider = Provider<PushProvider>((ref) {
  return FcmPushProvider();
});

final deviceTokenServiceProvider = Provider<DeviceTokenService>((ref) {
  final provider = ref.watch(pushProvider);
  return DeviceTokenService(provider);
});

final pushNotificationHandlerProvider = Provider<PushNotificationHandler>((ref) {
  final provider = ref.watch(pushProvider);
  final tokenService = ref.watch(deviceTokenServiceProvider);
  return PushNotificationHandler(provider, tokenService);
});
