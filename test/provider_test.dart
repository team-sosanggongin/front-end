import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosangongin_platform/features/auth/auth_provider.dart';
import 'package:sosangongin_platform/features/consent/consent_provider.dart';
import 'package:sosangongin_platform/features/my/user_provider.dart';
import 'package:sosangongin_platform/features/role/role_provider.dart';

// 헬퍼

ProviderContainer _makeContainer() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // AuthNotifier

  group('AuthNotifier', () {
    test('초기 상태', () {
      final container = _makeContainer();
      expect(container.read(authProvider), isA<AuthStateIdle>());
    });


    test('resetState 호출 시 초기화', () {
      final container = _makeContainer();
      container.read(authProvider.notifier).resetState();
      expect(container.read(authProvider), isA<AuthStateIdle>());
    });
  });

  // PhoneNotifier
  group('PhoneNotifier', () {
    test('초기 상태', () {
      final container = _makeContainer();
      expect(container.read(phoneProvider), isA<PhoneStateIdle>());
    });

    test('resetState 호출 시 초기화', () {
      final container = _makeContainer();
      container.read(phoneProvider.notifier).resetState();
      expect(container.read(phoneProvider), isA<PhoneStateIdle>());
    });
  });

  // ConsentNotifier

  group('ConsentNotifier', () {
    test('초기 상태는 AsyncData(null)', () {
      final container = _makeContainer();
      expect(container.read(consentProvider), isA<AsyncData<void>>());
    });

    test('resetState 호출 시 AsyncData(null)로 초기화', () {
      final container = _makeContainer();
      container.read(consentProvider.notifier).resetState();
      expect(container.read(consentProvider), isA<AsyncData<void>>());
    });
  });

  // BankListProvider

  group('BankListProvider', () {
    test('은행 목록 6개', () {
      final container = _makeContainer();
      final banks = container.read(bankListProvider);
      expect(banks.length, 6);
    });

    test('KB국민은행 포함', () {
      final container = _makeContainer();
      expect(container.read(bankListProvider), contains('KB국민은행'));
    });
  });

  // UserProvider

  group('UserProvider', () {
    test('초기값 null', () {
      final container = _makeContainer();
      expect(container.read(userProvider), isNull);
    });

    test('유저 정보 저장', () {
      final container = _makeContainer();
      const user = UserModel(id: 'user_001', name: '홍길동');
      container.read(userProvider.notifier).setUser(user);
      final result = container.read(userProvider);
      expect(result, isNotNull);
      expect(result!.id, 'user_001');
      expect(result.name, '홍길동');
    });

    test('clearUser 후 초기화', () {
      final container = _makeContainer();
      const user = UserModel(id: 'user_001', name: '홍길동');
      container.read(userProvider.notifier).setUser(user);
      container.read(userProvider.notifier).clearUser();
      expect(container.read(userProvider), isNull);
    });
  });

  // AccountModel

  group('AccountModel', () {
    test('fromJson 정상 파싱', () {
      final json = {
        'id': 'acc_001',
        'bankName': '우리은행',
        'accountNumber': '1002-XXX-XXXXXX',
        'accountAlias': '급여계좌',
      };
      final account = AccountModel.fromJson(json);
      expect(account.id, 'acc_001');
      expect(account.bankName, '우리은행');
      expect(account.accountAlias, '급여계좌');
    });

    test('accountAlias null이면 빈 문자열', () {
      final json = {
        'id': 'acc_001',
        'bankName': '우리은행',
        'accountNumber': '1002-XXX-XXXXXX',
        'accountAlias': null,
      };
      final account = AccountModel.fromJson(json);
      expect(account.accountAlias, '');
    });
  });

  // RoleModel.fromJson

  group('RoleModel.fromJson', () {
    test('정상 파싱', () {
      final json = {
        'id': 1,
        'roleName': '매니저',
        'description': 'manager',
        'permissions': [
          {
            'id': 1,
            'permissionName': 'staff_manage',
            'permDomain': 'STAFF',
            'description': '직원 등록 및 관리',
            'active': true,
          }
        ],
      };

      final role = RoleModel.fromJson(json);

      expect(role.id, 1);
      expect(role.name, '매니저');
      expect(role.description, 'manager');
      expect(role.permissions.length, 1);
      expect(role.permissions.first.permissionName, 'staff_manage');
    });

    test('permissions 비어있을 때', () {
      final json = {
        'id': 1,
        'roleName': '매니저',
        'description': 'manager',
        'permissions': [],
      };

      final role = RoleModel.fromJson(json);
      expect(role.permissions, isEmpty);
      expect(role.permissionIds, isEmpty);
      expect(role.permissionKeys, isEmpty);
    });

    test('description, permissions null일 때 기본값', () {
      final json = {
        'id': 1,
        'roleName': '매니저',
        'description': null,
        'permissions': null,
      };

      final role = RoleModel.fromJson(json);
      expect(role.description, '');
      expect(role.permissions, isEmpty);
    });

    test('permissionIds, permissionKeys getter', () {
      final json = {
        'id': 1,
        'roleName': '매니저',
        'description': 'manager',
        'permissions': [
          {
            'id': 1,
            'permissionName': 'staff_manage',
            'permDomain': 'STAFF',
            'description': '',
            'active': true,
          },
          {
            'id': 2,
            'permissionName': 'store_manage',
            'permDomain': 'STORE',
            'description': '',
            'active': true,
          },
        ],
      };

      final role = RoleModel.fromJson(json);
      expect(role.permissionIds, [1, 2]);
      expect(role.permissionKeys, ['staff_manage', 'store_manage']);
    });
  });

  // PermissionModel.fromJson

  group('PermissionModel.fromJson', () {
    test('정상 파싱', () {
      final json = {
        'id': 1,
        'permissionName': 'staff_manage',
        'permDomain': 'STAFF',
        'description': '직원 등록 및 관리',
        'active': true,
      };

      final permission = PermissionModel.fromJson(json);

      expect(permission.id, 1);
      expect(permission.permissionName, 'staff_manage');
      expect(permission.permDomain, 'STAFF');
      expect(permission.description, '직원 등록 및 관리');
      expect(permission.active, true);
    });

    test('optional 필드 null일 때 기본값', () {
      final json = {
        'id': 1,
        'permissionName': 'staff_manage',
        'permDomain': null,
        'description': null,
        'active': null,
      };

      final permission = PermissionModel.fromJson(json);

      expect(permission.permDomain, '');
      expect(permission.description, '');
      expect(permission.active, true);
    });
  });
}