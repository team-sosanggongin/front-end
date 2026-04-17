import 'package:go_router/go_router.dart';
import '../route_path.dart';
import '../../../features/role/role_list_screen.dart';
import '../../../features/role/role_detail_screen.dart';
import '../../../features/role/role_add_screen.dart';
import '../../../features/role/role_provider.dart';

final roleRoutes = [
  GoRoute(
    path: RolePath.root,
    builder: (context, state) => const RoleListScreen(),
  ),
  GoRoute(
    path: RolePath.detail,
    builder: (context, state) {
      final role = state.extra as RoleModel;
      return RoleDetailScreen(role: role);
    },
  ),
  GoRoute(
    path: RolePath.add,
    builder: (context, state) => const RoleAddScreen(),
  ),
];