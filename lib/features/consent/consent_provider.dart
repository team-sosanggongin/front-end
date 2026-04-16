import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_provider.dart';
import '../../utils/env_config.dart';

//  상태
sealed class ConsentState {}

class ConsentStateIdle extends ConsentState {}

class ConsentStateLoading extends ConsentState {}

class ConsentStateSuccess extends ConsentState {}

class ConsentStateError extends ConsentState {
  ConsentStateError(this.message);
  final String message;
}

//  API 경로
abstract class _ConsentApiPath {
  static const pending = 'api/v1/consents/pending';
  static const agree = 'api/v1/consents/agree';
}

// Provider
final consentProvider =
StateNotifierProvider<ConsentNotifier, ConsentState>((ref) {
  return ConsentNotifier(ref.read(dioProvider));
});

//  은행 목록
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

//Notifier
class ConsentNotifier extends StateNotifier<ConsentState> {
  ConsentNotifier(this._dio) : super(ConsentStateIdle());

  final Dio _dio;

  Future<void> agreeAll() async {
    state = ConsentStateLoading();
    try {
      if (EnvConfig.isMock) {
        await Future.delayed(const Duration(milliseconds: 500));
        state = ConsentStateSuccess();
        return;
      }

      final res = await _dio.get(_ConsentApiPath.pending);
      final data = res.data as Map<String, dynamic>;

      if (data['allAgreed'] == true) {
        state = ConsentStateSuccess();
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

      state = ConsentStateSuccess();
    } catch (e) {
      state = ConsentStateError(e.toString());
    }
  }

  void resetState() => state = ConsentStateIdle();
}