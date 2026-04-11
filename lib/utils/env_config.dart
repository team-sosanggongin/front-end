enum AppEnv {
  local,     // 서버 없이 Mock으로 동작
  localApi,  // 로컬 개발 서버(10.0.2.2)에 연결
  stg,       // 스테이징 서버
  prod       // 운영 서버
}

class EnvConfig {
  static const _envString = String.fromEnvironment('ENV');

  /// 현재 실행 환경 (JSON의 ENV 필드에서 결정)
  static AppEnv get defaultEnv {
    switch (_envString.toUpperCase()) {
      case 'LOCAL':
        return AppEnv.local;
      case 'LOCAL_API':
        return AppEnv.localApi;
      case 'STG':
        return AppEnv.stg;
      case 'PROD':
        return AppEnv.prod;
      default:
        return AppEnv.local;
    }
  }

  /// 환경별 Base URL 설정 (Dio 표준에 따라 반드시 /로 끝나야 함)
  static String get baseUrl {
    return const String.fromEnvironment('BASE_URL');
  }

  /// 카카오 네이티브 앱키
  static String get kakaoNativeAppKey {
    return const String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  }

  /// 현재 환경이 Mock 모드인지 확인
  static bool get isMock => defaultEnv == AppEnv.local;
}


