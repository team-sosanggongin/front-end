import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_provider.dart';

// 모델

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
  final List<PermissionModel> permissions;

  List<String> get permissionKeys =>
      permissions.map((p) => p.permissionName).toList();

  List<int> get permissionIds => permissions.map((p) => p.id).toList();

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
    id: json['id'] as int,
    name: json['roleName'] as String,
    description: json['description'] as String? ?? '',
    permissions: (json['permissions'] as List? ?? [])
        .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class PermissionModel {
  const PermissionModel({
    required this.id,
    required this.permissionName,
    required this.permDomain,
    required this.description,
    required this.active,
  });

  final int id;
  final String permissionName;
  final String permDomain;
  final String description;
  final bool active;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        id: json['id'] as int,
        permissionName: json['permissionName'] as String,
        permDomain: json['permDomain'] as String? ?? '',
        description: json['description'] as String? ?? '',
        active: json['active'] as bool? ?? true,
      );
}

// 권한 키 상수

abstract class PermissionKey {
  static const staffManage    = 'staff_manage';
  static const storeManage    = 'store_manage';
  static const contractManage = 'contract_manage';
  static const salaryManage   = 'salary_manage';
  static const staffInvite    = 'staff_invite';
}

// 역할 유형별 권한 프리셋

const _presetPermissionKeys = {
  'manager':  [
    PermissionKey.staffManage,
    PermissionKey.storeManage,
    PermissionKey.contractManage,
    PermissionKey.salaryManage,
    PermissionKey.staffInvite,
  ],
  'partTimer': [PermissionKey.storeManage],
  'employee':  [PermissionKey.storeManage, PermissionKey.contractManage],
  'newRole':   <String>[],
};

List<String> presetPermissionsFor(String typeKey) =>
    List.from(_presetPermissionKeys[typeKey] ?? []);

// API

abstract class _RoleApiPath {
  static const mine        = 'api/v1/roles/mine';
  static const permissions = 'api/v1/roles/permissions';
  static const create      = 'api/v1/roles';
  static String detail(int id) => 'api/v1/roles/$id';
  static String update(int id) => 'api/v1/roles/$id';
  static String delete(int id) => 'api/v1/roles/$id';
}

// 역할 목록 Provider

final roleListProvider =
StateNotifierProvider<RoleListNotifier, AsyncValue<List<RoleModel>>>(
        (ref) => RoleListNotifier(ref.read(dioProvider)));

class RoleListNotifier extends StateNotifier<AsyncValue<List<RoleModel>>> {
  RoleListNotifier(this._dio) : super(const AsyncLoading()) {
    fetch();
  }

  final Dio _dio;

  Future<void> fetch({bool refresh = false}) async {
    state = const AsyncLoading();
    try {
      // GET /api/v1/roles/mine
      final res = await _dio.get(_RoleApiPath.mine);
      final list = (res.data['roles'] as List)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncData(list);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
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

// 권한 목록 Provider

final permissionListProvider =
StateNotifierProvider<PermissionListNotifier,
    AsyncValue<List<PermissionModel>>>(
        (ref) => PermissionListNotifier(ref.read(dioProvider)));

class PermissionListNotifier
    extends StateNotifier<AsyncValue<List<PermissionModel>>> {
  PermissionListNotifier(this._dio) : super(const AsyncLoading()) {
    fetch();
  }

  final Dio _dio;

  Future<void> fetch() async {
    state = const AsyncLoading();
    try {
      // GET /api/v1/roles/permissions
      final res = await _dio.get(_RoleApiPath.permissions);
      final list = (res.data['permissions'] as List)
          .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncData(list);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// 역할 생성/수정/삭제 Provider

final roleMutationProvider =
StateNotifierProvider<RoleMutationNotifier, AsyncValue<void>>(
        (ref) => RoleMutationNotifier(ref.read(dioProvider), ref));

class RoleMutationNotifier extends StateNotifier<AsyncValue<void>> {
  RoleMutationNotifier(this._dio, this._ref) : super(const AsyncData(null));

  final Dio _dio;
  final Ref _ref;

  Future<bool> create({
    required String roleName,
    required String description,
    required List<int> permissionIds,
  }) async {
    state = const AsyncLoading();
    try {
      // POST /api/v1/roles
      final res = await _dio.post(_RoleApiPath.create, data: {
        'roleName': roleName,
        'description': description,
        'permissionIds': permissionIds,
      });
      final created = RoleModel.fromJson(
          res.data['role'] as Map<String, dynamic>);
      _ref.read(roleListProvider.notifier).addRole(created);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> update({
    required int roleId,
    required String roleName,
    required String description,
    required List<int> permissionIds,
  }) async {
    state = const AsyncLoading();
    try {
      // PUT /api/v1/roles/{roleId}
      final res = await _dio.put(_RoleApiPath.update(roleId), data: {
        'roleName': roleName,
        'description': description,
        'permissionIds': permissionIds,
      });
      final updated = RoleModel.fromJson(
          res.data['role'] as Map<String, dynamic>);
      _ref.read(roleListProvider.notifier).updateRole(updated);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> delete(int roleId) async {
    state = const AsyncLoading();
    try {
      // API 확인 후 수정 및 삭제
      _ref.read(roleListProvider.notifier).deleteRole(roleId);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}