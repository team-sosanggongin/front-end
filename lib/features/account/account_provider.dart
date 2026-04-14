import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';
import '../my/user_provider.dart';
import 'account_list_provider.dart';

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
  return AccountNotifier(ref, ref.read(dioProvider));
});

// Notifier

class AccountNotifier extends StateNotifier<AccountState> {
  AccountNotifier(this._ref, this._dio) : super(AccountStateIdle());

  final Ref _ref;
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
        // Mock-등록한 계좌를 목록에 바로 추가
        _ref.read(accountListProvider.notifier).addAccount(
          AccountModel(
            id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
            bankName: bankName,
            accountNumber: accountNumber,
            accountAlias: accountAlias,
          ),
        );
        state = AccountStateSuccess();
        return;
      }

      final res = await _dio.post(
        _AccountApiPath.bankAccounts,
        data: {
          'bankName': bankName,
          'accountNumber': accountNumber,
          'accountAlias': accountAlias,
        },
      );
      final data = res.data as Map<String, dynamic>;
      // Todo: API_등록된 계좌를 목록에 추가
      if (data['account'] != null) {
        _ref.read(accountListProvider.notifier).addAccount(
          AccountModel.fromJson(data['account'] as Map<String, dynamic>),
        );
      } else {
        // account 없으면 목록 새로 fetch
        await _ref.read(accountListProvider.notifier).fetch();
      }
      state = AccountStateSuccess();
    } catch (e) {
      state = AccountStateError(e.toString());
    }
  }

  void resetState() => state = AccountStateIdle();
}