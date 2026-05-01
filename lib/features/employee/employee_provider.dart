import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../role/role_provider.dart';

// 모델

enum EmployeeStatus { active, resigned }

class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.status,
  });

  final String id;
  final String name;
  final RoleModel role;
  final String startDate;
  final EmployeeStatus status;

  EmployeeModel copyWith({
    String? id,
    String? name,
    RoleModel? role,
    String? startDate,
    EmployeeStatus? status,
  }) =>
      EmployeeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        startDate: startDate ?? this.startDate,
        status: status ?? this.status,
      );

  factory EmployeeModel.fromJson(Map<String, dynamic> json,
      {required RoleModel role}) =>
      EmployeeModel(
        id: json['id'] as String,
        name: json['name'] as String,
        role: role,
        startDate: json['startDate'] as String,
        status: json['status'] == 'resigned'
            ? EmployeeStatus.resigned
            : EmployeeStatus.active,
      );
}

class InviteCodeModel {
  const InviteCodeModel({required this.code});
  final String code;
}

// Mock

final _mockManagerRole = RoleModel(
  id: 1,
  name: '매니저',
  description: 'manager',
  permissions: [
    PermissionModel(id: 1, permissionName: PermissionKey.staffManage,
        permDomain: 'STAFF', description: '', active: true),
    PermissionModel(id: 2, permissionName: PermissionKey.storeManage,
        permDomain: 'STORE', description: '', active: true),
    PermissionModel(id: 3, permissionName: PermissionKey.contractManage,
        permDomain: 'CONTRACT', description: '', active: true),
    PermissionModel(id: 4, permissionName: PermissionKey.salaryManage,
        permDomain: 'SALARY', description: '', active: true),
    PermissionModel(id: 5, permissionName: PermissionKey.staffInvite,
        permDomain: 'STAFF', description: '', active: true),
  ],
);

final _mockEmployees = [
  EmployeeModel(
    id: 'emp_001',
    name: '김민수',
    role: _mockManagerRole,
    startDate: '2024.01.01',
    status: EmployeeStatus.active,
  ),
  EmployeeModel(
    id: 'emp_002',
    name: '박지영',
    role: RoleModel(
      id: 2,
      name: '파트타이머',
      description: 'partTimer',
      permissions: [
        PermissionModel(id: 2, permissionName: PermissionKey.storeManage,
            permDomain: 'STORE', description: '', active: true),
      ],
    ),
    startDate: '2024.03.15',
    status: EmployeeStatus.active,
  ),
];

// 직원 목록 Provider
// TODO: API 연동 시 교체

final employeeListProvider =
StateNotifierProvider<EmployeeListNotifier, AsyncValue<List<EmployeeModel>>>(
        (ref) => EmployeeListNotifier());

class EmployeeListNotifier
    extends StateNotifier<AsyncValue<List<EmployeeModel>>> {
  EmployeeListNotifier() : super(const AsyncLoading()) {
    fetch();
  }

  Future<void> fetch({bool refresh = false}) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 300));

    state = AsyncData(List.from(_mockEmployees));
  }

  void addEmployee(EmployeeModel employee) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, employee]);
  }

  void updateEmployeeRole(String employeeId, RoleModel newRole) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(current
        .map((e) => e.id == employeeId ? e.copyWith(role: newRole) : e)
        .toList());
  }

  void resignEmployee(String employeeId) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(current
        .map((e) => e.id == employeeId
        ? e.copyWith(status: EmployeeStatus.resigned)
        : e)
        .toList());
  }
}

// 초대코드 Provider

final inviteCodeProvider =
StateNotifierProvider<InviteCodeNotifier, AsyncValue<InviteCodeModel?>>(
        (ref) => InviteCodeNotifier());

class InviteCodeNotifier
    extends StateNotifier<AsyncValue<InviteCodeModel?>> {
  InviteCodeNotifier() : super(const AsyncData(null));

  Future<void> generate() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: API 연동 시 교체
    state = const AsyncData(InviteCodeModel(code: 'AB12-CD34'));
  }
}