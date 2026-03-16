import 'package:dio/dio.dart';
import '../../utils/env_config.dart';
import 'push_provider.dart';

class DeviceTokenService {
  final PushProvider _pushProvider;
  late final Dio _dio;

  DeviceTokenService(this._pushProvider) {
    final String url = EnvConfig.isMock ? 'http://localhost' : EnvConfig.baseUrl;
    
    _dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));
  }

  Future<void> syncTokenToServer() async {
    final token = await _pushProvider.getToken();
    if (token != null) {
      await _sendTokenToSpringServer(token);
    }

    _pushProvider.onTokenRefresh.listen((newToken) async {
      await _sendTokenToSpringServer(newToken);
    });
  }

  Future<void> _sendTokenToSpringServer(String token) async {
    if (EnvConfig.isMock) {
      print('[디버그] 로컬 모드: 서버 동기화를 건너뜁니다. (토큰: $token)');
      return;
    }

    try {
      // 스웨거 확인 결과에 따라 경로 설정 (baseUrl 끝에 /가 있으므로 여기선 / 없이 시작)
      final response = await _dio.post(
        'device-tokens', 
        data: {
          'userId': 1, // 테스트용 ID
          'token': token,
          'deviceType': 'ANDROID',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[정보] 서버에 토큰 동기화 성공 (${EnvConfig.currentEnv.name})');
      }
    } on DioException catch (e) {
      print('[오류] 토큰 동기화 중 네트워크 에러 발생: ${e.response?.statusCode} ${e.message}');
      print('[디버그] 호출 시도 전체 URL: ${_dio.options.baseUrl}device-tokens');
    } catch (e) {
      print('[오류] 토큰 동기화 중 알 수 없는 에러 발생: $e');
    }
  }
}
