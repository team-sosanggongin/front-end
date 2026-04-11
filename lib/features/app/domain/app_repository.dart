enum AppPlatform {
  android('ANDROID'),
  ios('IOS');

  const AppPlatform(this.value);
  final String value;
}

class AppStatusResponse {
  const AppStatusResponse({
    required this.underMaintenance,
    this.reason,
    this.startedAt,
    this.endedAt,
  });

  final bool underMaintenance;
  final String? reason;
  final String? startedAt;
  final String? endedAt;

  factory AppStatusResponse.fromJson(Map<String, dynamic> json) {
    return AppStatusResponse(
      underMaintenance: json['underMaintenance'] as bool,
      reason: json['reason'] as String?,
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
    );
  }
}

class AppVersionResponse {
  const AppVersionResponse({
    required this.compatible,
    required this.forceUpdateRequired,
    this.latestVersion,
    this.reason,
  });

  final bool compatible;
  final bool forceUpdateRequired;
  final String? latestVersion;
  final String? reason;

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      compatible: json['compatible'] as bool,
      forceUpdateRequired: json['forceUpdateRequired'] as bool,
      latestVersion: json['latestVersion'] as String?,
      reason: json['reason'] as String?,
    );
  }
}

abstract class AppRepository {
  Future<AppStatusResponse> getAppStatus();

  Future<AppVersionResponse> checkAppVersion({
    required AppPlatform platform,
    required String appVersion,
  });
}