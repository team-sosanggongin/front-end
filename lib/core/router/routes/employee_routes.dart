import 'package:go_router/go_router.dart';
import '../route_path.dart';
import '../../../features/employee/employee_list_screen.dart';
import '../../../features/employee/employee_detail_screen.dart';
import '../../../features/employee/employee_role_select_screen.dart';
import '../../../features/employee/add/contract_method_screen.dart';
import '../../../features/employee/add/contract_upload_screen.dart';
import '../../../features/employee/add/contract_viewer_screen.dart';
import '../../../features/employee/add/invite_code_screen.dart';
import '../../../features/employee/employee_provider.dart';

final employeeRoutes = [
  GoRoute(
    path: EmployeePath.list,
    builder: (context, state) => const EmployeeListScreen(),
  ),
  GoRoute(
    path: EmployeePath.detail,
    builder: (context, state) {
      final employee = state.extra as EmployeeModel;
      return EmployeeDetailScreen(employee: employee);
    },
  ),
  GoRoute(
    path: EmployeePath.roleSelect,
    builder: (context, state) => const EmployeeRoleSelectScreen(),
  ),
  GoRoute(
    path: EmployeePath.contractMethod,
    builder: (context, state) => const ContractMethodScreen(),
  ),
  GoRoute(
    path: EmployeePath.contractUpload,
    builder: (context, state) => const ContractUploadScreen(),
  ),
  GoRoute(
    path: EmployeePath.contractViewer,
    builder: (context, state) {
      final pdfPath = state.extra as String;
      return ContractViewerScreen(pdfPath: pdfPath);
    },
  ),
  GoRoute(
    path: EmployeePath.inviteCode,
    builder: (context, state) => const InviteCodeScreen(),
  ),
];