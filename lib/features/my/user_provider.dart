import 'package:flutter_riverpod/flutter_riverpod.dart';

//유저 모델
class UserModel {
  final String id;
  final String name;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.name,
    this.profileImageUrl,
  });

// TODO: API 연결 시
// factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       profileImageUrl: json['profileImageUrl'] as String?,
//     );
}

//계좌 모델
class AccountModel {
  final String id;
  final String type;
  final String bankName;
  final String accountNumber;
  final String accountHolder;

  const AccountModel({
    required this.id,
    required this.type,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
  });

// TODO: API 연결 시
// factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
//       id: json['id'] as String,
//       type: json['type'] as String,
//       bankName: json['bankName'] as String,
//       accountNumber: json['accountNumber'] as String,
//       accountHolder: json['accountHolder'] as String,
//     );
}

//유저 Notifier
class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void setUser(UserModel user) => state = user;
  void clearUser() => state = null;
}

final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

// ─── 계좌 목록 Notifier ───────────────────────────────────
class AccountListNotifier extends Notifier<List<AccountModel>> {
  @override
  List<AccountModel> build() {
    // TODO: API 연결 후 수정
    return const [
      AccountModel(
        id: 'acc_001',
        type: '급여 수령 계좌',
        bankName: '우리은행',
        accountNumber: '1002-XXX-XXXXXX',
        accountHolder: '홍길동',
      ),
      AccountModel(
        id: 'acc_002',
        type: '급여 지급 계좌',
        bankName: '국민은행',
        accountNumber: '234-XXX-XXXXXX',
        accountHolder: '홍길동',
      ),
    ];
  }

  void removeAccount(String accountId) {
    state = state.where((a) => a.id != accountId).toList();
    // TODO: API 연결 시 → await dio.delete('/accounts/$accountId');
  }

  void addAccount(AccountModel account) {
    state = [...state, account];
    // TODO: API 연결 시 → await dio.post('/accounts', data: account.toJson());
  }
}

final accountListProvider =
NotifierProvider<AccountListNotifier, List<AccountModel>>(
  AccountListNotifier.new,
);