import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:sosangongin_platform/core/network/dio_provider.dart';
import 'package:sosangongin_platform/features/consent/consent_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Consent API', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    tearDown(() => container.dispose());

    test('agreeAll → 미동의 약관 있을 때 동의 성공', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/consents/pending',
            (server) => server.reply(200, {
          'allAgreed': false,
          'pendingConsents': [
            {'consentPolicyId': 1},
            {'consentPolicyId': 2},
          ],
        }),
      );
      dioAdapter.onPost(
        'api/v1/consents/agree',
            (server) => server.reply(200, {}),
        data: {'consentPolicyId': 1, 'agreed': true},
      );
      dioAdapter.onPost(
        'api/v1/consents/agree',
            (server) => server.reply(200, {}),
        data: {'consentPolicyId': 2, 'agreed': true},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(consentProvider.notifier).agreeAll();
      expect(container.read(consentProvider), isA<AsyncData<void>>());
    });

    test('agreeAll → 이미 모두 동의된 경우', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/consents/pending',
            (server) => server.reply(200, {
          'allAgreed': true,
          'pendingConsents': [],
        }),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(consentProvider.notifier).agreeAll();
      expect(container.read(consentProvider), isA<AsyncData<void>>());
    });

    test('agreeAll → API 오류 시 AsyncError', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/consents/pending',
            (server) => server.reply(500, {'message': 'Server Error'}),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(consentProvider.notifier).agreeAll();
      expect(container.read(consentProvider), isA<AsyncError>());
    });

    test('resetState 호출 시 AsyncData(null)로 초기화', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );
      container.read(consentProvider.notifier).resetState();
      expect(container.read(consentProvider), isA<AsyncData<void>>());
    });
  });
}