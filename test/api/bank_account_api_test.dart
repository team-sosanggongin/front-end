import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:sosangongin_platform/core/network/dio_provider.dart';
import 'package:sosangongin_platform/features/account/account_list_provider.dart';

Future<void> waitForAccountState(ProviderContainer container) async {
  await Future.doWhile(() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return container.read(accountListProvider) is AccountListStateLoading;
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BankAccount API', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    tearDown(() => container.dispose());

    test('GET /bank-accounts → 계좌 목록 파싱', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/bank-accounts',
            (server) => server.reply(200, {
          'accounts': [
            {
              'id': 'acc_001',
              'bankName': '우리은행',
              'accountNumber': '1002-XXX-XXXXXX',
              'accountAlias': '급여계좌',
            },
          ]
        }),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForAccountState(container);
      final state = container.read(accountListProvider);

      expect(state, isA<AccountListStateLoaded>());
      if (state is AccountListStateLoaded) {
        expect(state.accounts.length, 1);
        expect(state.accounts.first.bankName, '우리은행');
        expect(state.accounts.first.accountAlias, '급여계좌');
      }
    });

    test('DELETE /bank-accounts/{id} → 계좌 삭제', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/bank-accounts',
            (server) => server.reply(200, {
          'accounts': [
            {
              'id': 'acc_001',
              'bankName': '우리은행',
              'accountNumber': '1002-XXX-XXXXXX',
              'accountAlias': '급여계좌',
            },
          ]
        }),
      );
      dioAdapter.onDelete(
        'api/v1/bank-accounts/acc_001',
            (server) => server.reply(200, {}),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForAccountState(container);
      await container.read(accountListProvider.notifier).deleteAccount('acc_001');

      final state = container.read(accountListProvider);
      if (state is AccountListStateLoaded) {
        expect(state.accounts, isEmpty);
      }
    });

    test('PUT /bank-accounts/{id} → 계좌 수정', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/bank-accounts',
            (server) => server.reply(200, {
          'accounts': [
            {
              'id': 'acc_001',
              'bankName': '우리은행',
              'accountNumber': '1002-XXX-XXXXXX',
              'accountAlias': '급여계좌',
            },
          ]
        }),
      );
      dioAdapter.onPut(
        'api/v1/bank-accounts/acc_001',
            (server) => server.reply(200, {}),
        data: {
          'bankName': '신한은행',
          'accountNumber': '1002-XXX-XXXXXX',
          'accountAlias': '수정된계좌',
        },
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForAccountState(container);
      await container.read(accountListProvider.notifier).updateAccount(
        accountId: 'acc_001',
        bankName: '신한은행',
        accountNumber: '1002-XXX-XXXXXX',
        accountAlias: '수정된계좌',
      );

      final state = container.read(accountListProvider);
      if (state is AccountListStateLoaded) {
        expect(state.accounts.first.bankName, '신한은행');
        expect(state.accounts.first.accountAlias, '수정된계좌');
      }
    });

    test('GET /bank-accounts → API 오류 시 Error 상태', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/bank-accounts',
            (server) => server.reply(500, {'message': 'Server Error'}),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForAccountState(container);
      expect(container.read(accountListProvider), isA<AccountListStateError>());
    });
  });
}