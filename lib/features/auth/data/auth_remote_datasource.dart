import 'dart:io';
import 'package:dio/dio.dart';
import '../../app/domain/app_repository.dart';


abstract class _AuthApiPath {
  static const loginCallback = '/api/v1/auth/login-callback';
}

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> loginCallback({
    required String kakaoAccessToken,
    required String provider,
  }) async {
    final platform =
    Platform.isAndroid ? AppPlatform.android : AppPlatform.ios;

    final response = await _dio.post(
      _AuthApiPath.loginCallback,
      data: {
        'code': kakaoAccessToken,
        'provider': provider,
        'agentType': platform.value,
        'deviceInfo': platform.value,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}