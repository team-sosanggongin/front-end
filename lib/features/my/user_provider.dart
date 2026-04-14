import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.profileImageUrl,
  });

  final String id;
  final String name;
  final String? profileImageUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    profileImageUrl: json['profileImageUrl'] as String?,
  );
}


class AccountModel {
  const AccountModel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountAlias,
  });

  final String id;
  final String bankName;
  final String accountNumber;
  final String accountAlias;

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json['id'] as String,
    bankName: json['bankName'] as String,
    accountNumber: json['accountNumber'] as String,
    accountAlias: json['accountAlias'] as String? ?? '',
  );
}


class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void setUser(UserModel user) => state = user;
  void clearUser() => state = null;
}

final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

