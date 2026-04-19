import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';

// API 경로

abstract class _ConsentApiPath {
  static const pending = 'api/v1/consents/pending';
  static const agree   = 'api/v1/consents/agree';
}

// Provider

final consentProvider =
StateNotifierProvider<ConsentNotifier, AsyncValue<void>>(
        (ref) => ConsentNotifier(ref.read(dioProvider)));

// 은행 목록

final bankListProvider = Provider<List<String>>((ref) {
  return const [
    'KB국민은행',
    '신한은행',
    '우리은행',
    '하나은행',
    'NH농협은행',
    'IBK기업은행',
  ];
});

// Notifier

class ConsentNotifier extends StateNotifier<AsyncValue<void>> {
  ConsentNotifier(this._dio) : super(const AsyncData(null));

  final Dio _dio;

  Future<void> agreeAll() async {
    state = const AsyncLoading();
    try {
      if (EnvConfig.isMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        state = const AsyncData(null);
        return;
      }

      final res = await _dio.get(_ConsentApiPath.pending);
      final data = res.data as Map<String, dynamic>;

      if (data['allAgreed'] == true) {
        state = const AsyncData(null);
        return;
      }

      final List pendingConsents = data['pendingConsents'] as List;
      for (final consent in pendingConsents) {
        await _dio.post(
          _ConsentApiPath.agree,
          data: {
            'consentPolicyId': consent['consentPolicyId'],
            'agreed': true,
          },
        );
      }

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void resetState() => state = const AsyncData(null);
}