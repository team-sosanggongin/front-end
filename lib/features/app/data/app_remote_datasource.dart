import 'package:dio/dio.dart';

import '../domain/app_repository.dart';

//API 경로 상수
abstract class _AppApiPath {
  static const status = '/api/v1/app/status';
  static const versionCheck = '/api/v1/app/version-check';
}

class AppRemoteDatasource {
  AppRemoteDatasource(this._dio);

  final Dio _dio;

  Future<AppStatusResponse> getAppStatus() async {
    final response = await _dio.get(_AppApiPath.status);
    return AppStatusResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AppVersionResponse> checkAppVersion({
    required AppPlatform platform,
    required String appVersion,
  }) async {
    final response = await _dio.post(
      _AppApiPath.versionCheck,
      data: {
        'platform': platform.value,
        'appVersion': appVersion,
      },
    );
    return AppVersionResponse.fromJson(response.data as Map<String, dynamic>);
  }
}