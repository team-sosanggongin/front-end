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
  /// In en, this message translates to:
  /// **'Kakao Login'**
  String get kakaoLoginButton;

  /// No description provided for @startWithKakao.
  ///
  /// In en, this message translates to:
  /// **'Start with Kakao account'**
  String get startWithKakao;

  /// No description provided for @loginFailError.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailError;

  /// No description provided for @phoneVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneVerificationTitle;

  /// No description provided for @phoneVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please verify your identity for safe service use'**
  String get phoneVerificationSubtitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'01012345678'**
  String get phoneNumberHint;

  /// No description provided for @getAuthCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Get verification code'**
  String get getAuthCodeButton;

  /// No description provided for @verifyAuthCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyAuthCodeTitle;

  /// No description provided for @verifyAuthCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your phone'**
  String get verifyAuthCodeSubtitle;

  /// No description provided for @invalidAuthCodeError.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code. Please try again.'**
  String get invalidAuthCodeError;

  /// No description provided for @resendAuthCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendAuthCodeButton;

  /// No description provided for @privacyConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Collection & Use Agreement'**
  String get privacyConsentTitle;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Personal Information Collected'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In en, this message translates to:
  /// **'The company collects the following personal information for service provision.'**
  String get privacySection1Content;

  /// No description provided for @privacyRequiredItems.
  ///
  /// In en, this message translates to:
  /// **'Required: Name, Phone number'**
  String get privacyRequiredItems;

  /// No description provided for @privacyOptionalItems.
  ///
  /// In en, this message translates to:
  /// **'Optional: Email address, Profile photo'**
  String get privacyOptionalItems;

  /// No description provided for @privacyAutoCollectedItems.
  ///
  /// In en, this message translates to:
  /// **'Auto-collected: Access logs, Cookies, IP address'**
  String get privacyAutoCollectedItems;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Purpose of Collection & Use'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In en, this message translates to:
  /// **'Collected personal information is used for the following purposes.'**
  String get privacySection2Content;

  /// No description provided for @privacyUseMemberManagement.
  ///
  /// In en, this message translates to:
  /// **'Member registration and management'**
  String get privacyUseMemberManagement;

  /// No description provided for @privacyUseServiceProvision.
  ///
  /// In en, this message translates to:
  /// **'Service provision and contract fulfillment'**
  String get privacyUseServiceProvision;

  /// No description provided for @privacyUseAttendanceSalary.
  ///
  /// In en, this message translates to:
  /// **'Attendance management and salary payment'**
  String get privacyUseAttendanceSalary;

  /// No description provided for @privacyUseNoticeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Notice delivery and announcement distribution'**
  String get privacyUseNoticeDelivery;

  /// No description provided for @privacyUseIdentityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity verification and authentication'**
  String get privacyUseIdentityVerification;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Retention Period'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In en, this message translates to:
  /// **'The company processes and retains personal information within the retention period prescribed by law or agreed upon at the time of collection.'**
  String get privacySection3Content;

  /// No description provided for @privacyRetentionWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Upon withdrawal: Immediately deleted'**
  String get privacyRetentionWithdrawal;

  /// No description provided for @privacyRetentionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal retention: As prescribed by applicable laws'**
  String get privacyRetentionLegal;

  /// No description provided for @salaryConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary Information Collection Agreement'**
  String get salaryConsentTitle;

  /// No description provided for @salarySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Salary Information Collected'**
  String get salarySection1Title;

  /// No description provided for @salarySection1Content.
  ///
  /// In en, this message translates to:
  /// **'The company collects the following information for accurate salary payment and management.'**
  String get salarySection1Content;

  /// No description provided for @salaryBasePay.
  ///
  /// In en, this message translates to:
  /// **'Base pay and allowance information'**
  String get salaryBasePay;

  /// No description provided for @salaryWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Work hours and attendance information'**
  String get salaryWorkHours;

  /// No description provided for @salaryOvertimeHours.
  ///
  /// In en, this message translates to:
  /// **'Overtime, night shift, and holiday work hours'**
  String get salaryOvertimeHours;

  /// No description provided for @salaryBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Salary payment account information'**
  String get salaryBankAccount;

  /// No description provided for @salaryTaxInsurance.
  ///
  /// In en, this message translates to:
  /// **'Income tax and social insurance information'**
  String get salaryTaxInsurance;

  /// No description provided for @salaryLeaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Annual leave usage history'**
  String get salaryLeaveHistory;

  /// No description provided for @salarySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Purpose of Use'**
  String get salarySection2Title;

  /// No description provided for @salarySection2Content.
  ///
  /// In en, this message translates to:
  /// **'Collected salary information is used for the following purposes.'**
  String get salarySection2Content;

  /// No description provided for @salaryUseCalculation.
  ///
  /// In en, this message translates to:
  /// **'Accurate salary calculation and payment'**
  String get salaryUseCalculation;

  /// No description provided for @salaryUsePayslip.
  ///
  /// In en, this message translates to:
  /// **'Payslip creation and provision'**
  String get salaryUsePayslip;

  /// No description provided for @salaryUseInsurance.
  ///
  /// In en, this message translates to:
  /// **'Social insurance reporting and management'**
  String get salaryUseInsurance;

  /// No description provided for @salaryUseTax.
  ///
  /// In en, this message translates to:
  /// **'Income tax withholding and year-end settlement'**
  String get salaryUseTax;

  /// No description provided for @salaryUseLegalRecord.
  ///
  /// In en, this message translates to:
  /// **'Legal record keeping under labor law'**
  String get salaryUseLegalRecord;

  /// No description provided for @salaryUseDispute.
  ///
  /// In en, this message translates to:
  /// **'Salary-related dispute resolution'**
  String get salaryUseDispute;

  /// No description provided for @salarySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Retention Period'**
  String get salarySection3Title;

  /// No description provided for @salarySection3Content.
  ///
  /// In en, this message translates to:
  /// **'Salary information is retained in accordance with applicable laws.'**
  String get salarySection3Content;

  /// No description provided for @enterAccountInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter account information'**
  String get enterAccountInfoTitle;

  /// No description provided for @registerAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register the account for salary payment'**
  String get registerAccountSubtitle;

  /// No description provided for @bankLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankLabel;

  /// No description provided for @selectBankHint.
  ///
  /// In en, this message translates to:
  /// **'Select a bank'**
  String get selectBankHint;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumberLabel;

  /// No description provided for @accountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Numbers only, no dashes'**
  String get accountNumberHint;

  /// No description provided for @accountAliasLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Alias'**
  String get accountAliasLabel;

  /// No description provided for @accountAliasHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Salary account, Living expenses'**
  String get accountAliasHint;

  /// No description provided for @noticeLabel.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get noticeLabel;

  /// No description provided for @accountRegistrationNotice.
  ///
  /// In en, this message translates to:
  /// **'The account will be used only for salary payment. Only accounts in your name can be registered.'**
  String get accountRegistrationNotice;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @noRegisteredAccounts.
  ///
  /// In en, this message translates to:
  /// **'No registered accounts.'**
  String get noRegisteredAccounts;

  /// No description provided for @addAccountButton.
  ///
  /// In en, this message translates to:
  /// **'+ Add account'**
  String get addAccountButton;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @changeButton.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeButton;

  /// No description provided for @accountHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Account holder'**
  String get accountHolderLabel;

  /// No description provided for @accountInfoHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfoHeaderTitle;

  /// No description provided for @accountInfoMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfoMenuLabel;

  /// No description provided for @homeBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'New Education System'**
  String get homeBannerTitle;

  /// No description provided for @homeBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage employee training more easily'**
  String get homeBannerSubtitle;

  /// No description provided for @noticesMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get noticesMenuLabel;

  /// No description provided for @noticesHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get noticesHeaderTitle;

  /// No description provided for @myPageHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get myPageHeaderTitle;

  /// No description provided for @viewProfileLink.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfileLink;

  /// No description provided for @noNotices.
  ///
  /// In en, this message translates to:
  /// **'No notices available.'**
  String get noNotices;

  /// No description provided for @roleManagementMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Role Management'**
  String get roleManagementMenuLabel;

  /// No description provided for @employeeAddMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get employeeAddMenuLabel;

  /// No description provided for @roleManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Role Management'**
  String get roleManagementTitle;

  /// No description provided for @roleAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Role'**
  String get roleAddTitle;

  /// No description provided for @rolePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Settings'**
  String get rolePermissionTitle;

  /// No description provided for @roleDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Role Detail'**
  String get roleDetailTitle;

  /// No description provided for @roleEmptyStateHeading.
  ///
  /// In en, this message translates to:
  /// **'Create your first role'**
  String get roleEmptyStateHeading;

  /// No description provided for @roleEmptyStateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up roles before inviting employees\nto manage permissions easily.'**
  String get roleEmptyStateSubtitle;

  /// No description provided for @roleEmptyStateButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get roleEmptyStateButton;

  /// No description provided for @roleAddStepOneHeading.
  ///
  /// In en, this message translates to:
  /// **'What kind of role?'**
  String get roleAddStepOneHeading;

  /// No description provided for @roleAddStepOneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default permissions will be set based on the role type.'**
  String get roleAddStepOneSubtitle;

  /// No description provided for @roleTypeManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get roleTypeManager;

  /// No description provided for @roleTypePartTimer.
  ///
  /// In en, this message translates to:
  /// **'Part-timer'**
  String get roleTypePartTimer;

  /// No description provided for @roleTypeEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get roleTypeEmployee;

  /// No description provided for @roleTypeNewRole.
  ///
  /// In en, this message translates to:
  /// **'Create New Role'**
  String get roleTypeNewRole;

  /// No description provided for @roleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Role Name'**
  String get roleNameLabel;

  /// No description provided for @roleNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekend Manager'**
  String get roleNameHint;

  /// No description provided for @rolePermissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get rolePermissionLabel;

  /// No description provided for @roleNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get roleNextButton;

  /// No description provided for @roleSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get roleSaveButton;

  /// No description provided for @roleCompleteButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get roleCompleteButton;

  /// No description provided for @roleDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get roleDeleteButton;

  /// No description provided for @roleDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this role?'**
  String get roleDeleteDialogTitle;

  /// No description provided for @roleDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Employees assigned to this role\nmay have their role removed.'**
  String get roleDeleteDialogMessage;

  /// No description provided for @permissionStaffManage.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get permissionStaffManage;

  /// No description provided for @permissionStaffManageDesc.
  ///
  /// In en, this message translates to:
  /// **'Register and manage employees'**
  String get permissionStaffManageDesc;

  /// No description provided for @permissionStoreManage.
  ///
  /// In en, this message translates to:
  /// **'Store Management'**
  String get permissionStoreManage;

  /// No description provided for @permissionStoreManageDesc.
  ///
  /// In en, this message translates to:
  /// **'View and edit store information'**
  String get permissionStoreManageDesc;

  /// No description provided for @permissionContractManage.
  ///
  /// In en, this message translates to:
  /// **'Contract Management'**
  String get permissionContractManage;

  /// No description provided for @permissionContractManageDesc.
  ///
  /// In en, this message translates to:
  /// **'Register and review contracts'**
  String get permissionContractManageDesc;

  /// No description provided for @permissionSalaryManage.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get permissionSalaryManage;

  /// No description provided for @permissionSalaryManageDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage payroll'**
  String get permissionSalaryManageDesc;

  /// No description provided for @permissionStaffInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite Staff'**
  String get permissionStaffInvite;

  /// No description provided for @permissionStaffInviteDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate and share invite codes'**
  String get permissionStaffInviteDesc;

  /// No description provided for @contractMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Employment Contract'**
  String get contractMethodTitle;

  /// No description provided for @contractMethodHeading.
  ///
  /// In en, this message translates to:
  /// **'How would you like to register?'**
  String get contractMethodHeading;

  /// No description provided for @contractMethodDirectLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF'**
  String get contractMethodDirectLabel;

  /// No description provided for @contractMethodDirectDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload a PDF file directly'**
  String get contractMethodDirectDesc;

  /// No description provided for @contractMethodTemplateLabel.
  ///
  /// In en, this message translates to:
  /// **'Load Template'**
  String get contractMethodTemplateLabel;

  /// No description provided for @contractMethodTemplateDesc.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get contractMethodTemplateDesc;

  /// No description provided for @contractUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Employment Contract'**
  String get contractUploadTitle;

  /// No description provided for @contractUploadHeading.
  ///
  /// In en, this message translates to:
  /// **'Please upload the contract'**
  String get contractUploadHeading;

  /// No description provided for @contractUploadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only PDF files are supported'**
  String get contractUploadSubtitle;

  /// No description provided for @contractUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get contractUploadButton;

  /// No description provided for @contractUploadNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get contractUploadNextButton;

  /// No description provided for @contractUploadEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a file'**
  String get contractUploadEmptyError;

  /// No description provided for @contractViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Contract'**
  String get contractViewerTitle;

  /// No description provided for @contractViewerConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get contractViewerConfirmButton;

  /// No description provided for @inviteCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCodeTitle;

  /// No description provided for @inviteCodeHeading.
  ///
  /// In en, this message translates to:
  /// **'Invite code generated!'**
  String get inviteCodeHeading;

  /// No description provided for @inviteCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share the code below with your employee'**
  String get inviteCodeSubtitle;

  /// No description provided for @inviteCodeCopyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get inviteCodeCopyButton;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get inviteCodeCopied;

  /// No description provided for @inviteCodeShareKakao.
  ///
  /// In en, this message translates to:
  /// **'Kakao'**
  String get inviteCodeShareKakao;

  /// No description provided for @inviteCodeShareLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get inviteCodeShareLine;

  /// No description provided for @inviteCodeShareOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get inviteCodeShareOther;

  /// No description provided for @inviteCodeDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get inviteCodeDoneButton;

  /// No description provided for @inviteCodeShareKakaoButton.
  ///
  /// In en, this message translates to:
  /// **'Share via KakaoTalk'**
  String get inviteCodeShareKakaoButton;

  /// No description provided for @employeeManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Management'**
  String get employeeManagementTitle;

  /// No description provided for @employeeListEmptyHeading.
  ///
  /// In en, this message translates to:
  /// **'No employees registered'**
  String get employeeListEmptyHeading;

  /// No description provided for @employeeListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add employees to get started'**
  String get employeeListEmptySubtitle;

  /// No description provided for @employeeDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Detail'**
  String get employeeDetailTitle;

  /// No description provided for @employeeRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned Role'**
  String get employeeRoleLabel;

  /// No description provided for @employeeStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get employeeStartDateLabel;

  /// No description provided for @employeeRoleChangeButton.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get employeeRoleChangeButton;

  /// No description provided for @employeeContractRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Request Contract Update'**
  String get employeeContractRequestButton;

  /// No description provided for @employeeResignButton.
  ///
  /// In en, this message translates to:
  /// **'Process Resignation'**
  String get employeeResignButton;

  /// No description provided for @employeeRoleChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Role'**
  String get employeeRoleChangeTitle;

  /// No description provided for @employeeResignDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Process resignation?'**
  String get employeeResignDialogTitle;

  /// No description provided for @employeeResignDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'All permissions will be revoked\nand the employee will be marked as resigned.'**
  String get employeeResignDialogMessage;

  /// No description provided for @employeeStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get employeeStatusActive;

  /// No description provided for @employeeStatusResigned.
  ///
  /// In en, this message translates to:
  /// **'Resigned'**
  String get employeeStatusResigned;

  /// No description provided for @employeeRoleSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get employeeRoleSelectTitle;

  /// No description provided for @employeeRoleSelectHeading.
  ///
  /// In en, this message translates to:
  /// **'Select a role to assign to the employee'**
  String get employeeRoleSelectHeading;

  /// No description provided for @employeeRoleSelectSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search roles'**
  String get employeeRoleSelectSearchHint;

  /// No description provided for @employeeRoleSelectEmpty.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get employeeRoleSelectEmpty;

  /// No description provided for @employeeRoleSelectNoRole.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find the right role?'**
  String get employeeRoleSelectNoRole;

  /// No description provided for @employeeRoleSelectCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create New Role'**
  String get employeeRoleSelectCreateButton;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Small Biz'**
  String get appTitle;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipButton;

  /// No description provided for @agreeButton.
  ///
  /// In en, this message translates to:
  /// **'I agree to the above'**
  String get agreeButton;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newBadge;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'A network error has occurred.'**
  String get networkError;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @maintenanceDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get maintenanceDialogTitle;

  /// No description provided for @maintenanceStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get maintenanceStartLabel;

  /// No description provided for @maintenanceEndLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get maintenanceEndLabel;

  /// No description provided for @forceUpdateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get forceUpdateDialogTitle;

  /// No description provided for @forceUpdateDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Please update to the latest version to continue.'**
  String get forceUpdateDialogMessage;

  /// No description provided for @optionalUpdateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'New Version Available'**
  String get optionalUpdateDialogTitle;

  /// No description provided for @optionalUpdateDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'We recommend updating for a better experience.'**
  String get optionalUpdateDialogMessage;

  /// No description provided for @updateDialogLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest version: {version}'**
  String updateDialogLatestVersion(String version);

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
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
