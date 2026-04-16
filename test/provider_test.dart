import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sosangongin_platform/features/auth/auth_provider.dart';
import 'package:sosangongin_platform/features/consent/consent_provider.dart';
import 'package:sosangongin_platform/features/my/user_provider.dart';

// 헬퍼

ProviderContainer _makeContainer() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  // AuthNotifier

  group('AuthNotifier', () {
    test('초기 상태', () {
      final container = _makeContainer();
      expect(container.read(authProvider), isA<AuthStateIdle>());
    });

    test('Mock 로그인 후 성공(NewUser) 반환', () async {
      // ENV=LOCAL(isMock=true)일 때만 실행
      final container = _makeContainer();
      await container.read(authProvider.notifier).loginWithKakao();
      final state = container.read(authProvider);
      expect(state, isA<AuthStateSuccess>());
      if (state is AuthStateSuccess) {
        expect(state.result, isA<LoginResultNewUser>());
      }
    });

    test('logout 후 상태 초기화', () async {
      final container = _makeContainer();
      await container.read(authProvider.notifier).loginWithKakao();
      await container.read(authProvider.notifier).logout();
      expect(container.read(authProvider), isA<AuthStateIdle>());
    });

    test('resetState 호출 시 초기화', () async {
      final container = _makeContainer();
      await container.read(authProvider.notifier).loginWithKakao();
      container.read(authProvider.notifier).resetState();
      expect(container.read(authProvider), isA<AuthStateIdle>());
    });
  });

  // PhoneNotifier
  group('PhoneNotifier (Mock)', () {
    test('초기 상태', () {
      final container = _makeContainer();
      expect(container.read(phoneProvider), isA<PhoneStateIdle>());
    });

    test('requestCode 후 보낸 상태', () async {
      final container = _makeContainer();
      await container.read(phoneProvider.notifier).requestCode('01012345678');
      expect(container.read(phoneProvider), isA<PhoneStateSent>());
    });

    test('올바른 코드(000000) 입력 시 성공', () async {
      final container = _makeContainer();
      await container.read(phoneProvider.notifier).verifyCode('000000');
      expect(container.read(phoneProvider), isA<PhoneStateSuccess>());
    });

    test('틀린 코드 입력 시 실패', () async {
      final container = _makeContainer();
      await container.read(phoneProvider.notifier).verifyCode('111111');
      expect(container.read(phoneProvider), isA<PhoneStateFailed>());
    });

    test('resetState 호출 시 초기화', () async {
      final container = _makeContainer();
      await container.read(phoneProvider.notifier).verifyCode('000000');
      container.read(phoneProvider.notifier).resetState();
      expect(container.read(phoneProvider), isA<PhoneStateIdle>());
    });
  });

  // ConsentNotifier

  group('ConsentNotifier (Mock)', () {
    test('초기 상태는 Idle', () {
      final container = _makeContainer();
      expect(container.read(consentProvider), isA<ConsentStateIdle>());
    });

    test('agreeAll 후 성공', () async {
      final container = _makeContainer();
      await container.read(consentProvider.notifier).agreeAll();
      expect(container.read(consentProvider), isA<ConsentStateSuccess>());
    });

    test('resetState 호출 시 초기화', () async {
      final container = _makeContainer();
      await container.read(consentProvider.notifier).agreeAll();
      container.read(consentProvider.notifier).resetState();
      expect(container.read(consentProvider), isA<ConsentStateIdle>());
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
    test('초기값 ', () {
      final container = _makeContainer();
      expect(container.read(userProvider), isNull);
    });

    test(' 유저 정보 저장', () {
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
}