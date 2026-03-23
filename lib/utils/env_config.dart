enum AppEnv {
  local,     // 서버 없이 Mock으로 동작
  localApi,  // 로컬 개발 서버(10.0.2.2)에 연결
  stg,       // 스테이징 서버
  prod       // 운영 서버
}

class EnvConfig {
  /// 현재 실행 환경
  static AppEnv currentEnv = AppEnv.local;

  /// 환경별 Base URL 설정 (Dio 표준에 따라 반드시 /로 끝나야 함)
  static String get baseUrl {
    switch (currentEnv) {
      case AppEnv.local:
        return 'mock';
      case AppEnv.localApi:
        return const String.fromEnvironment(
          'BASE_URL_LOCAL_API',
          defaultValue: 'http://10.0.2.2:8080/api/',
        );
      case AppEnv.stg:
        return const String.fromEnvironment('BASE_URL_STG');
      case AppEnv.prod:
        return const String.fromEnvironment('BASE_URL_PROD');
    }
  }

  /// 현재 환경이 Mock 모드인지 확인
  static bool get isMock => currentEnv == AppEnv.local;
}
