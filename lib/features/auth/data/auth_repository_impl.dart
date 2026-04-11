import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_datasource.dart';


abstract class _TokenKey {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
}


class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;
  final _storage = const FlutterSecureStorage();

  @override
  Future<LoginResult> loginWithKakao() async {
    final OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      token = await UserApi.instance.loginWithKakaoTalk();
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    final response = await _datasource.loginCallback(
      kakaoAccessToken: token.accessToken,
      provider: 'KAKAO',
    );

    // 신규 유저 — accessToken 없음, 정상 분기
    if (response['accessToken'] == null) {
      return LoginResultNewUser();
    }

    // 기존 유저 — 토큰저장
    await Future.wait([
      _storage.write(
        key: _TokenKey.accessToken,
        value: response['accessToken'] as String,
      ),
      _storage.write(
        key: _TokenKey.refreshToken,
        value: response['refreshToken'] as String,
      ),
    ]);

    return LoginResultExistingUser();
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // 스플래시 라우팅 분기
  Future<String?> getAccessToken() {
    return _storage.read(key: _TokenKey.accessToken);
  }
}