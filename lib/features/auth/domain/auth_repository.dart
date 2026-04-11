sealed class LoginResult {}

/// 기존 유저 — 토큰 발급 완료
class LoginResultExistingUser extends LoginResult {}

/// 신규 유저 — 전화번호 인증 필요
class LoginResultNewUser extends LoginResult {}


abstract class AuthRepository {
  Future<LoginResult> loginWithKakao();
  Future<void> logout();
  Future<String?> getAccessToken();
}