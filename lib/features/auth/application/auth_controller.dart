import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../data/auth_remote_datasource.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepositoryImpl(AuthRemoteDatasource(dio));
});

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});


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


class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(AuthStateIdle());

  final AuthRepository _repository;

  Future<void> loginWithKakao() async {
    state = AuthStateLoading();
    try {
      final result = await _repository.loginWithKakao();
      state = AuthStateSuccess(result);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  /// 스플래시에서 토큰 유무 확인 — true홈, false로그인
  Future<bool> hasValidToken() async {
    final token = await _repository.getAccessToken();
    return token != null;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthStateIdle();
  }

  void resetState() => state = AuthStateIdle();
}