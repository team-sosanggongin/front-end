import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fcm_push_provider.dart';
import 'push_notification_handler.dart';
import 'push_provider.dart';
import 'device_token_service.dart';
import 'remote_device_token_service.dart';
import 'mock_device_token_service.dart';
import 'local_notification_service.dart';
import '../../utils/env_config.dart';

final pushProvider = Provider<PushProvider>((ref) {
  print("push provider");
  return FcmPushProvider();
});

final deviceTokenServiceProvider = Provider<DeviceTokenService>((ref) {
  print("token service provider");
  if (EnvConfig.isMock) {
    return MockDeviceTokenService();
  }
  final provider = ref.watch(pushProvider);
  return RemoteDeviceTokenService(provider);
});

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

final pushNotificationHandlerProvider = Provider<PushNotificationHandler>((ref) {
  print("handler setup");
  final provider = ref.watch(pushProvider);
  final tokenService = ref.watch(deviceTokenServiceProvider);
  final localNotification = ref.watch(localNotificationServiceProvider);
  return PushNotificationHandler(provider, tokenService, localNotification);
});
