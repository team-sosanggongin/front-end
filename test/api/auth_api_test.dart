import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:sosangongin_platform/core/network/dio_provider.dart';
import 'package:sosangongin_platform/features/auth/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth API', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    tearDown(() => container.dispose());

    test('verify-phone → 인증번호 요청 성공', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onPost(
        'api/v1/auth/verify-phone',
            (server) => server.reply(200, {}),
        data: {'code': '01012345678', 'phoneVerificationRequest': true},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(phoneProvider.notifier).requestCode('01012345678');
      expect(container.read(phoneProvider), isA<PhoneStateSent>());
    });

    test('verify-phone → 인증번호 확인 성공', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onPost(
        'api/v1/auth/verify-phone',
            (server) => server.reply(200, {}),
        data: {'code': '123456', 'phoneVerificationRequest': false},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(phoneProvider.notifier).verifyCode('123456');
      expect(container.read(phoneProvider), isA<PhoneStateSuccess>());
    });

    test('verify-phone → 인증번호 확인 실패', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onPost(
        'api/v1/auth/verify-phone',
            (server) => server.reply(400, {'message': '잘못된 인증번호'}),
        data: {'code': '000000', 'phoneVerificationRequest': false},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(phoneProvider.notifier).verifyCode('000000');
      expect(container.read(phoneProvider), isA<PhoneStateFailed>());
    });

    test('verify-phone → API 오류 시 PhoneStateError', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onPost(
        'api/v1/auth/verify-phone',
            (server) => server.reply(500, {'message': 'Server Error'}),
        data: {'code': '01012345678', 'phoneVerificationRequest': true},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await container.read(phoneProvider.notifier).requestCode('01012345678');
      expect(container.read(phoneProvider), isA<PhoneStateError>());
    });

    test('PhoneNotifier 초기 상태', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );
      expect(container.read(phoneProvider), isA<PhoneStateIdle>());
    });

    test('PhoneNotifier resetState 호출 시 초기화', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );
      container.read(phoneProvider.notifier).resetState();
      expect(container.read(phoneProvider), isA<PhoneStateIdle>());
    });
  });
}