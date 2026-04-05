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
