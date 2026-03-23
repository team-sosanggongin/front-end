enum TokenSyncStatus {
  success,
  noToken,
  invalidToken,
  serverError,
  networkError,
  unknownError,
}

class TokenSyncResult {
  final TokenSyncStatus status;
  final String? message;

  const TokenSyncResult(this.status, {this.message});

  bool get isSuccess => status == TokenSyncStatus.success;
}

abstract class DeviceTokenService {
  Future<TokenSyncResult> syncTokenToServer({
    void Function(TokenSyncResult)? onRefreshResult,
  });
}
