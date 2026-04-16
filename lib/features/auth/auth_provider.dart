import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';

// 로그인 결과
sealed class LoginResult {}

class LoginResultExistingUser extends LoginResult {}

class LoginResultNewUser extends LoginResult {}

// 컨트롤러 상태
sealed class AuthState {}

class AuthStateIdle extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateSuccess extends AuthState {
  AuthStateSuccess(this.result);
  final LoginResult result;
}

class AuthStateError extends AuthState {
  AuthStateError(this.message);
  final String message;
}


abstract class _TokenKey {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
}

// API
abstract class _AuthApiPath {
  static const loginCallback = 'api/v1/auth/login-callback';
  static const verifyPhone = 'api/v1/auth/verify-phone';
}

// Provider
final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(dioProvider));
});

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._dio) : super(AuthStateIdle());

  final Dio _dio;
  final _storage = const FlutterSecureStorage();

  Future<void> loginWithKakao() async {
    state = AuthStateLoading();
    try {
      final result = EnvConfig.isMock
          ? await _mockLogin()
          : await _realLogin();
      state = AuthStateSuccess(result);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  // Mock 로그인 — 카카오 SDK 없이 임시 토큰 저장
  Future<LoginResult> _mockLogin() async {
    await Future.delayed(const Duration(milliseconds: 500)); // 로딩 느낌용
    await Future.wait([
      _storage.write(key: _TokenKey.accessToken, value: 'mock_access_token'),
      _storage.write(key: _TokenKey.refreshToken, value: 'mock_refresh_token'),
    ]);
    return LoginResultNewUser(); // 시뮬은 항상 신규 유저 플로우
  }

  // 실제 로그인 — 카카오 SDK → 백엔드
  Future<LoginResult> _realLogin() async {
    final OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      token = await UserApi.instance.loginWithKakaoTalk();
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    final res = await _dio.post(
      _AuthApiPath.loginCallback,
      data: {
        'code': token.accessToken,
        'provider': 'KAKAO',
        'agentType': 'ANDROID',
        'deviceInfo': 'ANDROID',
      },
    );
    final data = res.data as Map<String, dynamic>;

    if (data['accessToken'] == null) {
      return LoginResultNewUser();
    }

    await Future.wait([
      _storage.write(
          key: _TokenKey.accessToken, value: data['accessToken'] as String),
      _storage.write(
          key: _TokenKey.refreshToken, value: data['refreshToken'] as String),
    ]);
    return LoginResultExistingUser();
  }

  Future<bool> hasValidToken() async {
    // 플로우 안정화 이후에는 아래 isMock 분기 제거
    if (EnvConfig.isMock) return false;

    final token = await _storage.read(key: _TokenKey.accessToken);
    return token != null;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = AuthStateIdle();
  }

  void resetState() => state = AuthStateIdle();
}

// 전화번호 인증 상태
sealed class PhoneState {}

class PhoneStateIdle extends PhoneState {}

class PhoneStateLoading extends PhoneState {}

class PhoneStateSent extends PhoneState {}

class PhoneStateSuccess extends PhoneState {}

class PhoneStateFailed extends PhoneState {}

class PhoneStateError extends PhoneState {
  PhoneStateError(this.message);
  final String message;
}

// ── Provider ─────────────────────────────────────────────

final phoneProvider =
StateNotifierProvider<PhoneNotifier, PhoneState>((ref) {
  return PhoneNotifier(ref.read(dioProvider));
});

// ── Notifier ─────────────────────────────────────────────

class PhoneNotifier extends StateNotifier<PhoneState> {
  PhoneNotifier(this._dio) : super(PhoneStateIdle());

  final Dio _dio;

  Future<void> requestCode(String phoneNumber) async {
    state = PhoneStateLoading();
    try {
      if (EnvConfig.isMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        state = PhoneStateSent();
        return;
      }
      await _dio.post(
        _AuthApiPath.verifyPhone,
        data: {'code': phoneNumber, 'phoneVerificationRequest': true},
      );
      state = PhoneStateSent();
    } catch (e) {
      state = PhoneStateError(e.toString());
    }
  }

  Future<void> verifyCode(String code) async {
    state = PhoneStateLoading();
    try {
      if (EnvConfig.isMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        // Mock: 000000이면 성공, 아니면 실패
        state = code == '000000' ? PhoneStateSuccess() : PhoneStateFailed();
        return;
      }
      await _dio.post(
        _AuthApiPath.verifyPhone,
        data: {'code': code, 'phoneVerificationRequest': false},
      );
      state = PhoneStateSuccess();
    } catch (e) {
      // 인증번호 틀림 → 실패 처리
      state = PhoneStateFailed();
    }
  }

  void resetState() => state = PhoneStateIdle();
}