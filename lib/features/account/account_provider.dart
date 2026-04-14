import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';

// 상태
sealed class AccountState {}

class AccountStateIdle extends AccountState {}

class AccountStateLoading extends AccountState {}

class AccountStateSuccess extends AccountState {}

class AccountStateError extends AccountState {
  AccountStateError(this.message);
  final String message;
}

// API

abstract class _AccountApiPath {
  static const bankAccounts = 'api/v1/bank-accounts';
}

// Provider
final accountProvider =
StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier(ref.read(dioProvider));
});

//Notifier

class AccountNotifier extends StateNotifier<AccountState> {
  AccountNotifier(this._dio) : super(AccountStateIdle());

  final Dio _dio;

  Future<void> registerAccount({
    required String bankName,
    required String accountNumber,
    required String accountAlias,
  }) async {
    state = AccountStateLoading();
    try {
      if (EnvConfig.isMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        state = AccountStateSuccess();
        return;
      }

      await _dio.post(
        _AccountApiPath.bankAccounts,
        data: {
          'bankName': bankName,
          'accountNumber': accountNumber,
          'accountAlias': accountAlias,
        },
      );
      state = AccountStateSuccess();
    } catch (e) {
      state = AccountStateError(e.toString());
    }
  }

  void resetState() => state = AccountStateIdle();
}