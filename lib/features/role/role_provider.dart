import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleModel {
  const RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  final int id;
  final String name;
  final String description;
  final List<String> permissions;

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    permissions: (json['permissions'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
  );
}

class PermissionModel {
  const PermissionModel({required this.key});
  final String key;
}

// 권한 키 상수

abstract class PermissionKey {
  static const staffManage    = 'staff_manage';
  static const storeManage    = 'store_manage';
  static const contractManage = 'contract_manage';
  static const salaryManage   = 'salary_manage';
  static const staffInvite    = 'staff_invite';
}

//  Mock 데이터

const _mockPermissions = [
  PermissionModel(key: PermissionKey.staffManage),
  PermissionModel(key: PermissionKey.storeManage),
  PermissionModel(key: PermissionKey.contractManage),
  PermissionModel(key: PermissionKey.salaryManage),
  PermissionModel(key: PermissionKey.staffInvite),
];

// 역할 유형별 기본 권한 프리셋
const _presetPermissions = {
  'manager': [
    PermissionKey.staffManage,
    PermissionKey.storeManage,
    PermissionKey.contractManage,
    PermissionKey.salaryManage,
    PermissionKey.staffInvite,
  ],
  'partTimer': [
    PermissionKey.storeManage,
  ],
  'employee': [
    PermissionKey.storeManage,
    PermissionKey.contractManage,
  ],
  'newRole': <String>[],
};

List<String> presetPermissionsFor(String typeKey) =>
    List.from(_presetPermissions[typeKey] ?? []);

final _mockRoles = [
  RoleModel(
    id: 1,
    name: '매니저',
    description: 'manager',
    permissions: _presetPermissions['manager']!,
  ),
  RoleModel(
    id: 2,
    name: '파트타이머',
    description: 'partTimer',
    permissions: _presetPermissions['partTimer']!,
  ),
];

// 역할 목록 Provider
// TODO: API 연동 시 수정

final roleListProvider =
StateNotifierProvider<RoleListNotifier, AsyncValue<List<RoleModel>>>(
        (ref) => RoleListNotifier());

class RoleListNotifier extends StateNotifier<AsyncValue<List<RoleModel>>> {
  RoleListNotifier() : super(const AsyncLoading()) {
    fetch();
  }

  Future<void> fetch({bool refresh = false}) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = AsyncData(List.from(_mockRoles));
  }

  void addRole(RoleModel role) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, role]);
  }

  void updateRole(RoleModel updated) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(
        current.map((r) => r.id == updated.id ? updated : r).toList());
  }

  void deleteRole(int id) {
    final current = state.valueOrNull ?? [];

    state = AsyncData(current.where((r) => r.id != id).toList());
  }
}

//권한 목록 Provider

final permissionListProvider =
Provider<List<PermissionModel>>((ref) => _mockPermissions);

// 역할 생성/수정 Provider

final roleMutationProvider =
StateNotifierProvider<RoleMutationNotifier, AsyncValue<void>>(
        (ref) => RoleMutationNotifier(ref));

class RoleMutationNotifier extends StateNotifier<AsyncValue<void>> {
  RoleMutationNotifier(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<bool> create({
    required String name,
    required String description,
    required List<String> permissions,
  }) async {
    state = const AsyncLoading();
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // TODO: API 연동 시 Mock 코드 제거 후 교체
      final newRole = RoleModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        description: description,
        permissions: permissions,
      );
      _ref.read(roleListProvider.notifier).addRole(newRole);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> update({
    required int roleId,
    required String name,
    required String description,
    required List<String> permissions,
  }) async {
    state = const AsyncLoading();
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // TODO: API 연동 시 Mock 코드 제거 후 교체
      final updated = RoleModel(
        id: roleId,
        name: name,
        description: description,
        permissions: permissions,
      );
      _ref.read(roleListProvider.notifier).updateRole(updated);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}