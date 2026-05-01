import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:sosangongin_platform/core/network/dio_provider.dart';
import 'package:sosangongin_platform/features/home/notice_provider.dart';

Future<void> waitForState(ProviderContainer container, dynamic provider) async {
  await Future.doWhile(() async {
    await Future.delayed(const Duration(milliseconds: 50));
    final state = container.read(provider);
    return state is AsyncLoading;
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Notice API', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    tearDown(() => container.dispose());

    test('GET /notices → 공지 목록 파싱', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/notices',
            (server) => server.reply(200, {
          'publicNotices': {
            'content': [
              {
                'id': 1,
                'title': '공지사항 제목',
                'content': '공지사항 내용',
                'authorName': '관리자',
                'isPinned': true,
                'viewCount': 10,
                'createdAt': '2024-01-01T00:00:00',
                'startsAt': null,
                'endsAt': null,
              },
            ],
            'last': true,
          }
        }),
        queryParameters: {'page': 0, 'size': 10},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, noticeListProvider);
      final notices = container.read(noticeListProvider).valueOrNull ?? [];

      expect(notices.length, 1);
      expect(notices.first.title, '공지사항 제목');
      expect(notices.first.isPinned, true);
    });

    test('GET /notices → 빈 목록', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/notices',
            (server) => server.reply(200, {
          'publicNotices': {
            'content': [],
            'last': true,
          }
        }),
        queryParameters: {'page': 0, 'size': 10},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, noticeListProvider);
      final notices = container.read(noticeListProvider).valueOrNull ?? [];
      expect(notices, isEmpty);
    });

    test('GET /notices → API 오류 시 AsyncError', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/notices',
            (server) => server.reply(500, {'message': 'Server Error'}),
        queryParameters: {'page': 0, 'size': 10},
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, noticeListProvider);
      expect(container.read(noticeListProvider), isA<AsyncError>());
    });
  });
}