class RoleModel {
  final String id;
  final String name;
  final String description;
  final RoleType type;

  const RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });
}

enum RoleType {
  manager,
  partTimer,
  employee,
}