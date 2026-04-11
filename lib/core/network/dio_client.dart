import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../utils/env_config.dart';
import 'token_interceptor.dart';

class DioClient {

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true'},
      ),
    );


    dio.interceptors.addAll([
      TokenInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => debugPrint(log.toString()), // 개발 중에만
      ),
    ]);

    return dio;
  }

}