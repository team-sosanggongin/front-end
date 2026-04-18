import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';
import '../my/user_provider.dart';

// 상태

sealed class AccountListState {}

class AccountListStateLoading extends AccountListState {}

class AccountListStateLoaded extends AccountListState {
  AccountListStateLoaded(this.accounts);
  final List<AccountModel> accounts;
}

class AccountListStateError extends AccountListState {
  AccountListStateError(this.message);
  final String message;
}

// API 경로

abstract class _AccountApiPath {
  static const list = 'api/v1/bank-accounts';
  static String detail(String id) => 'api/v1/bank-accounts/$id';
}

// Provider

final accountListProvider =
StateNotifierProvider<AccountListNotifier, AccountListState>((ref) {
  // keepAlive로 라우트 변경 시에도 유지
  ref.keepAlive();
  return AccountListNotifier(ref.read(dioProvider));
});

// Notifier

class AccountListNotifier extends StateNotifier<AccountListState> {
  AccountListNotifier(this._dio) : super(AccountListStateLoading()) {
    fetch();
  }

  final Dio _dio;

  Future<void> fetch() async {
    // Mock일 때 이미 데이터 있으면 재fetch 안 함
    if (EnvConfig.isMock && state is AccountListStateLoaded) return;

    state = AccountListStateLoading();
    try {
      if (EnvConfig.isMock) {
        await Future.delayed(const Duration(milliseconds: 300));
        state = AccountListStateLoaded([]);
        return;
      }

      final res = await _dio.get(_AccountApiPath.list);
      final data = res.data as Map<String, dynamic>;
      final accounts = (data['accounts'] as List)
          .map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AccountListStateLoaded(accounts);
    } catch (e) {
      state = AccountListStateError(e.toString());
    }
  }


  void addAccount(AccountModel account) {
    if (state is AccountListStateLoaded) {
      final current = (state as AccountListStateLoaded).accounts;
      state = AccountListStateLoaded([...current, account]);
    }
  }

  Future<void> deleteAccount(String accountId) async {
    try {
      if (!EnvConfig.isMock) {
        await _dio.delete(_AccountApiPath.detail(accountId));
      }
      if (state is AccountListStateLoaded) {
        final current = (state as AccountListStateLoaded).accounts;
        state = AccountListStateLoaded(
          current.where((a) => a.id != accountId).toList(),
        );
      }
    } catch (e) {
      state = AccountListStateError(e.toString());
    }
  }

  Future<void> updateAccount({
    required String accountId,
    required String bankName,
    required String accountNumber,
    required String accountAlias,
  }) async {
    try {
      if (!EnvConfig.isMock) {
        await _dio.put(
          _AccountApiPath.detail(accountId),
          data: {
            'bankName': bankName,
            'accountNumber': accountNumber,
            'accountAlias': accountAlias,
          },
        );
      }
      if (state is AccountListStateLoaded) {
        final current = (state as AccountListStateLoaded).accounts;
        state = AccountListStateLoaded(
          current.map((a) {
            if (a.id != accountId) return a;
            return AccountModel(
              id: a.id,
              bankName: bankName,
              accountNumber: accountNumber,
              accountAlias: accountAlias,
            );
          }).toList(),
        );
      }
    } catch (e) {
      state = AccountListStateError(e.toString());
    }
  }
}