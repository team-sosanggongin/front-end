// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sosangongin_platform/features/my/user_provider.dart';
//
// void main() {
//   // UserProvider test
//   group('UserProvider', () {
//     test('초기값 null', () {
//       final container = ProviderContainer();
//       addTearDown(container.dispose);
//       expect(container.read(userProvider), isNull);
//     });
//
//     test('유저 정보 저장', () {
//       final container = ProviderContainer();
//       addTearDown(container.dispose);
//       const user = UserModel(id: 'user_001', name: '홍길동');
//       container.read(userProvider.notifier).setUser(user);
//       final result = container.read(userProvider);
//       expect(result, isNotNull);
//       expect(result!.id, 'user_001');
//       expect(result.name, '홍길동');
//     });
//   });
//
//   // AccountListProvider test
//   group('AccountListProvider', () {
//     test('해당 계좌 삭제', () {
//       final container = ProviderContainer();
//       addTearDown(container.dispose);
//       container.read(accountListProvider.notifier).removeAccount('acc_001');
//       final accounts = container.read(accountListProvider);
//       expect(accounts.length, 1);
//       expect(accounts.any((a) => a.id == 'acc_001'), isFalse);
//     });
//
//     test('존재하지 않는 id로 삭제시 목록 유지', () {
//       final container = ProviderContainer();
//       addTearDown(container.dispose);
//
//       container
//           .read(accountListProvider.notifier)
//           .removeAccount('non_existent');
//
//       expect(container.read(accountListProvider).length, 2);
//     });
//
//     test('계좌 추가', () {
//       final container = ProviderContainer();
//       addTearDown(container.dispose);
//       const newAccount = AccountModel(
//         id: 'acc_003',
//         type: '급여 수령 계좌',
//         bankName: '신한은행',
//         accountNumber: '110-XXX-XXXXXX',
//         accountHolder: '홍길동',
//       );
//       container.read(accountListProvider.notifier).addAccount(newAccount);
//       final accounts = container.read(accountListProvider);
//       expect(accounts.length, 3);
//       expect(accounts.any((a) => a.id == 'acc_003'), isTrue);
//     });
//
//     test('계좌 타입 저장', () {
//       final container = ProviderContainer();
//       addTearDown(container.dispose);
//       final accounts = container.read(accountListProvider);
//       expect(accounts[0].type, '급여 수령 계좌');
//       expect(accounts[1].type, '급여 지급 계좌');
//     });
//   });
// }