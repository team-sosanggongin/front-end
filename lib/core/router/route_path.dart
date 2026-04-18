abstract class RoutePath {
  static const splash = '/splash';
  static const accountVerification = '/account-verification';
}

abstract class AuthPath {
  static const login = '/login';
  static const phoneVerification = '/phone-verification';
  static const phoneCode = '/phone-code';
}

abstract class ConsentPath {
  static const privacy = '/privacy-consent';
  static const salary = '/salary-consent';
}

abstract class HomePath {
  static const root = '/home';
  static const notices = '/home/notices';
  static String noticeDetail(String id) => '/home/notices/$id';
}

abstract class MyPath {
  static const root = '/my';
  static const accounts = '/my/accounts';
}

abstract class RolePath {
  static const root   = '/role';
  static const detail = '/role/detail';
  static const add    = '/role/add';
}

abstract class EmployeePath {
  static const list           = '/employee';
  static const detail         = '/employee/detail';
  static const roleSelect     = '/employee/add/role-select';
  static const contractMethod = '/employee/add/contract-method';
  static const contractUpload = '/employee/add/contract-upload';
  static const contractViewer = '/employee/add/contract-viewer';
  static const inviteCode     = '/employee/add/invite-code';
}