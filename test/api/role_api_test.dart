import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:sosangongin_platform/core/network/dio_provider.dart';
import 'package:sosangongin_platform/features/role/role_provider.dart';

// AsyncLoading이 끝날 때까지 대기하는 헬퍼
Future<void> waitForState(ProviderContainer container, dynamic provider) async {
  await Future.doWhile(() async {
    await Future.delayed(const Duration(milliseconds: 50));
    final state = container.read(provider);
    return state is AsyncLoading;
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Role API', () {
    late Dio dio;
    late DioAdapter dioAdapter;
    late ProviderContainer container;

    tearDown(() => container.dispose());

    test('GET /roles/mine → 역할 목록 파싱', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/roles/mine',
            (server) => server.reply(200, {
          'roles': [
            {
              'id': 1,
              'roleName': '매니저',
              'description': 'manager',
              'recommended': true,
              'platformType': 'PLATFORM',
              'active': true,
            },
            {
              'id': 2,
              'roleName': '파트타이머',
              'description': 'partTimer',
              'recommended': false,
              'platformType': 'PLATFORM',
              'active': true,
            },
          ]
        }),
      );
      dioAdapter.onGet(
        'api/v1/roles/permissions',
            (server) => server.reply(200, {'permissions': []}),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, roleListProvider);
      final roles = container.read(roleListProvider).valueOrNull ?? [];

      expect(roles.length, 2);
      expect(roles.first.name, '매니저');
      expect(roles.last.name, '파트타이머');
    });

    test('GET /roles/permissions → 권한 목록 파싱', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/roles/mine',
            (server) => server.reply(200, {'roles': []}),
      );
      dioAdapter.onGet(
        'api/v1/roles/permissions',
            (server) => server.reply(200, {
          'permissions': [
            {
              'id': 1,
              'permissionName': 'staff_manage',
              'permDomain': 'STAFF',
              'description': '직원 등록 및 관리',
              'active': true,
            },
            {
              'id': 2,
              'permissionName': 'store_manage',
              'permDomain': 'STORE',
              'description': '매장 정보 조회 및 수정',
              'active': true,
            },
          ]
        }),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, permissionListProvider);
      final permissions =
          container.read(permissionListProvider).valueOrNull ?? [];

      expect(permissions.length, 2);
      expect(permissions.first.permissionName, 'staff_manage');
      expect(permissions.last.permDomain, 'STORE');
    });

    test('POST /roles → 역할 생성 후 목록 반영', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/roles/mine',
            (server) => server.reply(200, {'roles': []}),
      );
      dioAdapter.onGet(
        'api/v1/roles/permissions',
            (server) => server.reply(200, {'permissions': []}),
      );
      dioAdapter.onPost(
        'api/v1/roles',
            (server) => server.reply(200, {
          'role': {
            'id': 10,
            'roleName': '신규역할',
            'description': 'newRole',
            'recommended': false,
            'platformType': 'PLATFORM',
            'active': true,
          },
          'permissions': [],
        }),
        data: {
          'roleName': '신규역할',
          'description': 'newRole',
          'permissionIds': [],
        },
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, roleListProvider);

      final success = await container
          .read(roleMutationProvider.notifier)
          .create(
        roleName: '신규역할',
        description: 'newRole',
        permissionIds: [],
      );

      expect(success, true);
      final roles = container.read(roleListProvider).valueOrNull ?? [];
      expect(roles.any((r) => r.name == '신규역할'), true);
    });

    test('PUT /roles/{roleId} → 역할 수정 후 목록 반영', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/roles/mine',
            (server) => server.reply(200, {
          'roles': [
            {
              'id': 1,
              'roleName': '매니저',
              'description': 'manager',
              'recommended': true,
              'platformType': 'PLATFORM',
              'active': true,
            },
          ]
        }),
      );
      dioAdapter.onGet(
        'api/v1/roles/permissions',
            (server) => server.reply(200, {'permissions': []}),
      );
      dioAdapter.onPut(
        'api/v1/roles/1',
            (server) => server.reply(200, {
          'role': {
            'id': 1,
            'roleName': '수정된매니저',
            'description': 'manager',
            'recommended': true,
            'platformType': 'PLATFORM',
            'active': true,
          },
          'permissions': [],
        }),
        data: {
          'roleName': '수정된매니저',
          'description': 'manager',
          'permissionIds': [],
        },
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, roleListProvider);

      final success = await container
          .read(roleMutationProvider.notifier)
          .update(
        roleId: 1,
        roleName: '수정된매니저',
        description: 'manager',
        permissionIds: [],
      );

      expect(success, true);
      final roles = container.read(roleListProvider).valueOrNull ?? [];
      expect(roles.first.name, '수정된매니저');
    });

    test('API 오류 시 AsyncError 반환', () async {
      dio = Dio(BaseOptions(baseUrl: 'http://test.com/'));
      dioAdapter = DioAdapter(dio: dio);

      dioAdapter.onGet(
        'api/v1/roles/mine',
            (server) => server.reply(500, {'message': 'Server Error'}),
      );
      dioAdapter.onGet(
        'api/v1/roles/permissions',
            (server) => server.reply(500, {'message': 'Server Error'}),
      );

      container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(dio)],
      );

      await waitForState(container, roleListProvider);
      expect(container.read(roleListProvider), isA<AsyncError>());
    });
  });
}