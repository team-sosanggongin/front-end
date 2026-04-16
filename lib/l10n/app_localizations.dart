import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @kakaoLoginButton.
  ///
  /// In ko, this message translates to:
  /// **'카카오 로그인'**
  String get kakaoLoginButton;

  /// No description provided for @startWithKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오계정으로 시작하기'**
  String get startWithKakao;

  /// No description provided for @loginFailError.
  ///
  /// In ko, this message translates to:
  /// **'로그인에 실패했습니다. 다시 시도해 주세요.'**
  String get loginFailError;

  /// No description provided for @phoneVerificationTitle.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 인증'**
  String get phoneVerificationTitle;

  /// No description provided for @phoneVerificationSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'안전한 서비스 이용을 위해 본인 인증을 진행합니다'**
  String get phoneVerificationSubtitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰 번호'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In ko, this message translates to:
  /// **'01012345678'**
  String get phoneNumberHint;

  /// No description provided for @getAuthCodeButton.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 받기'**
  String get getAuthCodeButton;

  /// No description provided for @verifyAuthCodeTitle.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 확인'**
  String get verifyAuthCodeTitle;

  /// No description provided for @verifyAuthCodeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'휴대폰으로 전송된 6자리 번호를 입력해주세요'**
  String get verifyAuthCodeSubtitle;

  /// No description provided for @invalidAuthCodeError.
  ///
  /// In ko, this message translates to:
  /// **'인증번호가 올바르지 않습니다. 다시 확인해주세요'**
  String get invalidAuthCodeError;

  /// No description provided for @resendAuthCodeButton.
  ///
  /// In ko, this message translates to:
  /// **'인증번호 재발송'**
  String get resendAuthCodeButton;

  /// No description provided for @privacyConsentTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 수집 및 이용 동의'**
  String get privacyConsentTitle;

  /// No description provided for @privacySection1Title.
  ///
  /// In ko, this message translates to:
  /// **'1. 수집하는 개인정보 항목'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In ko, this message translates to:
  /// **'회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집하고 있습니다.'**
  String get privacySection1Content;

  /// No description provided for @privacyRequiredItems.
  ///
  /// In ko, this message translates to:
  /// **'필수항목: 이름, 휴대전화번호'**
  String get privacyRequiredItems;

  /// No description provided for @privacyOptionalItems.
  ///
  /// In ko, this message translates to:
  /// **'선택항목: 이메일 주소, 프로필 사진'**
  String get privacyOptionalItems;

  /// No description provided for @privacyAutoCollectedItems.
  ///
  /// In ko, this message translates to:
  /// **'자동 수집 항목: 접속 로그, 쿠키, 접속 IP 정보'**
  String get privacyAutoCollectedItems;

  /// No description provided for @privacySection2Title.
  ///
  /// In ko, this message translates to:
  /// **'2. 개인정보의 수집 및 이용목적'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In ko, this message translates to:
  /// **'수집한 개인정보는 다음의 목적을 위해 활용됩니다.'**
  String get privacySection2Content;

  /// No description provided for @privacyUseMemberManagement.
  ///
  /// In ko, this message translates to:
  /// **'회원 가입 및 관리'**
  String get privacyUseMemberManagement;

  /// No description provided for @privacyUseServiceProvision.
  ///
  /// In ko, this message translates to:
  /// **'서비스 제공 및 계약 이행'**
  String get privacyUseServiceProvision;

  /// No description provided for @privacyUseAttendanceSalary.
  ///
  /// In ko, this message translates to:
  /// **'근태 관리 및 급여 지급'**
  String get privacyUseAttendanceSalary;

  /// No description provided for @privacyUseNoticeDelivery.
  ///
  /// In ko, this message translates to:
  /// **'고지사항 전달 및 공지사항 발송'**
  String get privacyUseNoticeDelivery;

  /// No description provided for @privacyUseIdentityVerification.
  ///
  /// In ko, this message translates to:
  /// **'본인 확인 및 인증'**
  String get privacyUseIdentityVerification;

  /// No description provided for @privacySection3Title.
  ///
  /// In ko, this message translates to:
  /// **'3. 개인정보의 보유 및 이용기간'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In ko, this message translates to:
  /// **'회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.'**
  String get privacySection3Content;

  /// No description provided for @privacyRetentionWithdrawal.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴 시: 즉시 삭제'**
  String get privacyRetentionWithdrawal;

  /// No description provided for @privacyRetentionLegal.
  ///
  /// In ko, this message translates to:
  /// **'법령에 따른 보관: 관련 법령에서 정한 기간'**
  String get privacyRetentionLegal;

  /// No description provided for @salaryConsentTitle.
  ///
  /// In ko, this message translates to:
  /// **'급여 정보 수집 동의'**
  String get salaryConsentTitle;

  /// No description provided for @salarySection1Title.
  ///
  /// In ko, this message translates to:
  /// **'1. 수집하는 급여 정보'**
  String get salarySection1Title;

  /// No description provided for @salarySection1Content.
  ///
  /// In ko, this message translates to:
  /// **'회사는 정확한 급여 지급 및 관리를 위해 다음과 같은 정보를 수집합니다.'**
  String get salarySection1Content;

  /// No description provided for @salaryBasePay.
  ///
  /// In ko, this message translates to:
  /// **'기본급 및 수당 정보'**
  String get salaryBasePay;

  /// No description provided for @salaryWorkHours.
  ///
  /// In ko, this message translates to:
  /// **'근무 시간 및 근태 정보'**
  String get salaryWorkHours;

  /// No description provided for @salaryOvertimeHours.
  ///
  /// In ko, this message translates to:
  /// **'연장근무, 야간근무, 휴일근무 시간'**
  String get salaryOvertimeHours;

  /// No description provided for @salaryBankAccount.
  ///
  /// In ko, this message translates to:
  /// **'급여 지급 계좌 정보'**
  String get salaryBankAccount;

  /// No description provided for @salaryTaxInsurance.
  ///
  /// In ko, this message translates to:
  /// **'소득세 및 4대 보험 관련 정보'**
  String get salaryTaxInsurance;

  /// No description provided for @salaryLeaveHistory.
  ///
  /// In ko, this message translates to:
  /// **'연차 사용 내역'**
  String get salaryLeaveHistory;

  /// No description provided for @salarySection2Title.
  ///
  /// In ko, this message translates to:
  /// **'2. 급여 정보의 이용 목적'**
  String get salarySection2Title;

  /// No description provided for @salarySection2Content.
  ///
  /// In ko, this message translates to:
  /// **'수집한 급여 정보는 다음의 목적으로 이용됩니다.'**
  String get salarySection2Content;

  /// No description provided for @salaryUseCalculation.
  ///
  /// In ko, this message translates to:
  /// **'정확한 급여 계산 및 지급'**
  String get salaryUseCalculation;

  /// No description provided for @salaryUsePayslip.
  ///
  /// In ko, this message translates to:
  /// **'급여 명세서 작성 및 제공'**
  String get salaryUsePayslip;

  /// No description provided for @salaryUseInsurance.
  ///
  /// In ko, this message translates to:
  /// **'4대 보험 신고 및 관리'**
  String get salaryUseInsurance;

  /// No description provided for @salaryUseTax.
  ///
  /// In ko, this message translates to:
  /// **'소득세 원천징수 및 연말정산'**
  String get salaryUseTax;

  /// No description provided for @salaryUseLegalRecord.
  ///
  /// In ko, this message translates to:
  /// **'근로기준법에 따른 법정 기록 유지'**
  String get salaryUseLegalRecord;

  /// No description provided for @salaryUseDispute.
  ///
  /// In ko, this message translates to:
  /// **'급여 관련 분쟁 및 분쟁 해결'**
  String get salaryUseDispute;

  /// No description provided for @salarySection3Title.
  ///
  /// In ko, this message translates to:
  /// **'3. 급여 정보의 보유 및 이용 기간'**
  String get salarySection3Title;

  /// No description provided for @salarySection3Content.
  ///
  /// In ko, this message translates to:
  /// **'급여 관련 정보는 관련 법령에 따라 다음과 같이 보관됩니다.'**
  String get salarySection3Content;

  /// No description provided for @enterAccountInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'계좌 정보를 입력해 주세요'**
  String get enterAccountInfoTitle;

  /// No description provided for @registerAccountSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'급여 수령에 사용될 계좌를 등록해 주세요'**
  String get registerAccountSubtitle;

  /// No description provided for @bankLabel.
  ///
  /// In ko, this message translates to:
  /// **'은행'**
  String get bankLabel;

  /// No description provided for @selectBankHint.
  ///
  /// In ko, this message translates to:
  /// **'은행을 선택하세요'**
  String get selectBankHint;

  /// No description provided for @accountNumberLabel.
  ///
  /// In ko, this message translates to:
  /// **'계좌번호'**
  String get accountNumberLabel;

  /// No description provided for @accountNumberHint.
  ///
  /// In ko, this message translates to:
  /// **'\'-\' 없이 숫자만 입력'**
  String get accountNumberHint;

  /// No description provided for @accountAliasLabel.
  ///
  /// In ko, this message translates to:
  /// **'계좌 별칭'**
  String get accountAliasLabel;

  /// No description provided for @accountAliasHint.
  ///
  /// In ko, this message translates to:
  /// **'예) 급여계좌, 생활비계좌'**
  String get accountAliasHint;

  /// No description provided for @noticeLabel.
  ///
  /// In ko, this message translates to:
  /// **'안내사항'**
  String get noticeLabel;

  /// No description provided for @accountRegistrationNotice.
  ///
  /// In ko, this message translates to:
  /// **'입력하신 계좌는 급여 수령 계좌로만 사용되며, 본인 명의의 계좌만 등록 가능합니다.'**
  String get accountRegistrationNotice;

  /// No description provided for @registerButton.
  ///
  /// In ko, this message translates to:
  /// **'등록하기'**
  String get registerButton;

  /// No description provided for @noRegisteredAccounts.
  ///
  /// In ko, this message translates to:
  /// **'등록된 계좌가 없습니다.'**
  String get noRegisteredAccounts;

  /// No description provided for @addAccountButton.
  ///
  /// In ko, this message translates to:
  /// **'+ 계좌 추가'**
  String get addAccountButton;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ko, this message translates to:
  /// **'계좌 삭제'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In ko, this message translates to:
  /// **'해당 계좌를 삭제하시겠습니까?'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteButton.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get deleteButton;

  /// No description provided for @changeButton.
  ///
  /// In ko, this message translates to:
  /// **'변경'**
  String get changeButton;

  /// No description provided for @accountHolderLabel.
  ///
  /// In ko, this message translates to:
  /// **'예금주'**
  String get accountHolderLabel;

  /// No description provided for @accountInfoHeaderTitle.
  ///
  /// In ko, this message translates to:
  /// **'계좌 정보'**
  String get accountInfoHeaderTitle;

  /// No description provided for @accountInfoMenuLabel.
  ///
  /// In ko, this message translates to:
  /// **'계좌 정보'**
  String get accountInfoMenuLabel;

  /// No description provided for @homeBannerTitle.
  ///
  /// In ko, this message translates to:
  /// **'새로운 교육 시스템'**
  String get homeBannerTitle;

  /// No description provided for @homeBannerSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'직원 교육을 더 쉽게 관리하세요'**
  String get homeBannerSubtitle;

  /// No description provided for @noticesMenuLabel.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get noticesMenuLabel;

  /// No description provided for @noticesHeaderTitle.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get noticesHeaderTitle;

  /// No description provided for @myPageHeaderTitle.
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get myPageHeaderTitle;

  /// No description provided for @viewProfileLink.
  ///
  /// In ko, this message translates to:
  /// **'프로필 보기'**
  String get viewProfileLink;

  /// No description provided for @noNotices.
  ///
  /// In ko, this message translates to:
  /// **'등록된 공지사항이 없습니다.'**
  String get noNotices;

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'소상공인'**
  String get appTitle;

  /// No description provided for @confirmButton.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirmButton;

  /// No description provided for @cancelButton.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancelButton;

  /// No description provided for @skipButton.
  ///
  /// In ko, this message translates to:
  /// **'나중에 하기'**
  String get skipButton;

  /// No description provided for @agreeButton.
  ///
  /// In ko, this message translates to:
  /// **'위 내용에 동의합니다'**
  String get agreeButton;

  /// No description provided for @newBadge.
  ///
  /// In ko, this message translates to:
  /// **'NEW'**
  String get newBadge;

  /// No description provided for @networkError.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 오류가 발생했습니다.'**
  String get networkError;

  /// No description provided for @retryButton.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retryButton;

  /// No description provided for @maintenanceDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 점검 중'**
  String get maintenanceDialogTitle;

  /// No description provided for @maintenanceStartLabel.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get maintenanceStartLabel;

  /// No description provided for @maintenanceEndLabel.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get maintenanceEndLabel;

  /// No description provided for @forceUpdateDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'업데이트 필요'**
  String get forceUpdateDialogTitle;

  /// No description provided for @forceUpdateDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용을 위해 최신 버전으로 업데이트해 주세요.'**
  String get forceUpdateDialogMessage;

  /// No description provided for @optionalUpdateDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 버전 안내'**
  String get optionalUpdateDialogTitle;

  /// No description provided for @optionalUpdateDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'더 나은 서비스를 위해 업데이트를 권장합니다.'**
  String get optionalUpdateDialogMessage;

  /// No description provided for @updateDialogLatestVersion.
  ///
  /// In ko, this message translates to:
  /// **'최신 버전: {version}'**
  String updateDialogLatestVersion(String version);

  /// No description provided for @updateButton.
  ///
  /// In ko, this message translates to:
  /// **'업데이트'**
  String get updateButton;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ko':
      return SKo();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
