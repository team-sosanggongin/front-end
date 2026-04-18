// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class SKo extends S {
  SKo([String locale = 'ko']) : super(locale);

  @override
  String get kakaoLoginButton => '카카오 로그인';

  @override
  String get startWithKakao => '카카오계정으로 시작하기';

  @override
  String get loginFailError => '로그인에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get phoneVerificationTitle => '휴대폰 인증';

  @override
  String get phoneVerificationSubtitle => '안전한 서비스 이용을 위해 본인 인증을 진행합니다';

  @override
  String get phoneNumberLabel => '휴대폰 번호';

  @override
  String get phoneNumberHint => '01012345678';

  @override
  String get getAuthCodeButton => '인증번호 받기';

  @override
  String get verifyAuthCodeTitle => '인증번호 확인';

  @override
  String get verifyAuthCodeSubtitle => '휴대폰으로 전송된 6자리 번호를 입력해주세요';

  @override
  String get invalidAuthCodeError => '인증번호가 올바르지 않습니다. 다시 확인해주세요';

  @override
  String get resendAuthCodeButton => '인증번호 재발송';

  @override
  String get privacyConsentTitle => '개인정보 수집 및 이용 동의';

  @override
  String get privacySection1Title => '1. 수집하는 개인정보 항목';

  @override
  String get privacySection1Content => '회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집하고 있습니다.';

  @override
  String get privacyRequiredItems => '필수항목: 이름, 휴대전화번호';

  @override
  String get privacyOptionalItems => '선택항목: 이메일 주소, 프로필 사진';

  @override
  String get privacyAutoCollectedItems => '자동 수집 항목: 접속 로그, 쿠키, 접속 IP 정보';

  @override
  String get privacySection2Title => '2. 개인정보의 수집 및 이용목적';

  @override
  String get privacySection2Content => '수집한 개인정보는 다음의 목적을 위해 활용됩니다.';

  @override
  String get privacyUseMemberManagement => '회원 가입 및 관리';

  @override
  String get privacyUseServiceProvision => '서비스 제공 및 계약 이행';

  @override
  String get privacyUseAttendanceSalary => '근태 관리 및 급여 지급';

  @override
  String get privacyUseNoticeDelivery => '고지사항 전달 및 공지사항 발송';

  @override
  String get privacyUseIdentityVerification => '본인 확인 및 인증';

  @override
  String get privacySection3Title => '3. 개인정보의 보유 및 이용기간';

  @override
  String get privacySection3Content =>
      '회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.';

  @override
  String get privacyRetentionWithdrawal => '회원 탈퇴 시: 즉시 삭제';

  @override
  String get privacyRetentionLegal => '법령에 따른 보관: 관련 법령에서 정한 기간';

  @override
  String get salaryConsentTitle => '급여 정보 수집 동의';

  @override
  String get salarySection1Title => '1. 수집하는 급여 정보';

  @override
  String get salarySection1Content =>
      '회사는 정확한 급여 지급 및 관리를 위해 다음과 같은 정보를 수집합니다.';

  @override
  String get salaryBasePay => '기본급 및 수당 정보';

  @override
  String get salaryWorkHours => '근무 시간 및 근태 정보';

  @override
  String get salaryOvertimeHours => '연장근무, 야간근무, 휴일근무 시간';

  @override
  String get salaryBankAccount => '급여 지급 계좌 정보';

  @override
  String get salaryTaxInsurance => '소득세 및 4대 보험 관련 정보';

  @override
  String get salaryLeaveHistory => '연차 사용 내역';

  @override
  String get salarySection2Title => '2. 급여 정보의 이용 목적';

  @override
  String get salarySection2Content => '수집한 급여 정보는 다음의 목적으로 이용됩니다.';

  @override
  String get salaryUseCalculation => '정확한 급여 계산 및 지급';

  @override
  String get salaryUsePayslip => '급여 명세서 작성 및 제공';

  @override
  String get salaryUseInsurance => '4대 보험 신고 및 관리';

  @override
  String get salaryUseTax => '소득세 원천징수 및 연말정산';

  @override
  String get salaryUseLegalRecord => '근로기준법에 따른 법정 기록 유지';

  @override
  String get salaryUseDispute => '급여 관련 분쟁 및 분쟁 해결';

  @override
  String get salarySection3Title => '3. 급여 정보의 보유 및 이용 기간';

  @override
  String get salarySection3Content => '급여 관련 정보는 관련 법령에 따라 다음과 같이 보관됩니다.';

  @override
  String get enterAccountInfoTitle => '계좌 정보를 입력해 주세요';

  @override
  String get registerAccountSubtitle => '급여 수령에 사용될 계좌를 등록해 주세요';

  @override
  String get bankLabel => '은행';

  @override
  String get selectBankHint => '은행을 선택하세요';

  @override
  String get accountNumberLabel => '계좌번호';

  @override
  String get accountNumberHint => '\'-\' 없이 숫자만 입력';

  @override
  String get accountAliasLabel => '계좌 별칭';

  @override
  String get accountAliasHint => '예) 급여계좌, 생활비계좌';

  @override
  String get noticeLabel => '안내사항';

  @override
  String get accountRegistrationNotice =>
      '입력하신 계좌는 급여 수령 계좌로만 사용되며, 본인 명의의 계좌만 등록 가능합니다.';

  @override
  String get registerButton => '등록하기';

  @override
  String get noRegisteredAccounts => '등록된 계좌가 없습니다.';

  @override
  String get addAccountButton => '+ 계좌 추가';

  @override
  String get deleteAccountTitle => '계좌 삭제';

  @override
  String get deleteAccountConfirmation => '해당 계좌를 삭제하시겠습니까?';

  @override
  String get deleteButton => '삭제';

  @override
  String get changeButton => '변경';

  @override
  String get accountHolderLabel => '예금주';

  @override
  String get accountInfoHeaderTitle => '계좌 정보';

  @override
  String get accountInfoMenuLabel => '계좌 정보';

  @override
  String get homeBannerTitle => '새로운 교육 시스템';

  @override
  String get homeBannerSubtitle => '직원 교육을 더 쉽게 관리하세요';

  @override
  String get noticesMenuLabel => '공지사항';

  @override
  String get noticesHeaderTitle => '공지사항';

  @override
  String get myPageHeaderTitle => '마이페이지';

  @override
  String get viewProfileLink => '프로필 보기';

  @override
  String get noNotices => '등록된 공지사항이 없습니다.';

  @override
  String get roleManagementMenuLabel => '역할 관리';

  @override
  String get employeeAddMenuLabel => '직원 추가';

  @override
  String get roleManagementTitle => '역할 관리';

  @override
  String get roleAddTitle => '역할 추가';

  @override
  String get rolePermissionTitle => '권한 설정';

  @override
  String get roleDetailTitle => '역할 상세';

  @override
  String get roleEmptyStateHeading => '역할을 만들어보세요';

  @override
  String get roleEmptyStateSubtitle => '직원을 초대하기 전 역할을 먼저 설정하면\n권한 관리가 편리해져요';

  @override
  String get roleEmptyStateButton => '시작하기';

  @override
  String get roleAddStepOneHeading => '어떤 역할을 만들까요?';

  @override
  String get roleAddStepOneSubtitle => '역할 유형을 선택하면 기본 권한이 설정돼요';

  @override
  String get roleTypeManager => '매니저';

  @override
  String get roleTypePartTimer => '파트타이머';

  @override
  String get roleTypeEmployee => '직원';

  @override
  String get roleTypeNewRole => '새 역할 만들기';

  @override
  String get roleNameLabel => '역할 이름';

  @override
  String get roleNameHint => '예) 주말 매니저';

  @override
  String get rolePermissionLabel => '권한 설정';

  @override
  String get roleNextButton => '다음';

  @override
  String get roleSaveButton => '저장';

  @override
  String get roleCompleteButton => '완료';

  @override
  String get roleDeleteButton => '삭제';

  @override
  String get roleDeleteDialogTitle => '역할을 삭제하시겠어요?';

  @override
  String get roleDeleteDialogMessage => '이 역할에 배정된 직원이 있다면\n역할이 해제될 수 있어요.';

  @override
  String get permissionStaffManage => '직원 관리';

  @override
  String get permissionStaffManageDesc => '직원 등록 및 관리';

  @override
  String get permissionStoreManage => '매장 관리';

  @override
  String get permissionStoreManageDesc => '매장 정보 조회 및 수정';

  @override
  String get permissionContractManage => '근로계약서 관리';

  @override
  String get permissionContractManageDesc => '근로계약서 등록 및 확인';

  @override
  String get permissionSalaryManage => '급여 관리';

  @override
  String get permissionSalaryManageDesc => '급여 조회 및 관리';

  @override
  String get permissionStaffInvite => '직원 초대';

  @override
  String get permissionStaffInviteDesc => '초대코드 생성 및 공유';

  @override
  String get contractMethodTitle => '근로계약서 등록';

  @override
  String get contractMethodHeading => '어떤 방식으로 등록할까요?';

  @override
  String get contractMethodDirectLabel => 'PDF 직접 업로드';

  @override
  String get contractMethodDirectDesc => 'PDF 파일을 직접 업로드해요';

  @override
  String get contractMethodTemplateLabel => '템플릿 불러오기';

  @override
  String get contractMethodTemplateDesc => '준비 중입니다';

  @override
  String get contractUploadTitle => '근로계약서 등록';

  @override
  String get contractUploadHeading => '근로계약서를 업로드해주세요';

  @override
  String get contractUploadSubtitle => 'PDF 파일만 업로드 가능해요';

  @override
  String get contractUploadButton => '파일 선택';

  @override
  String get contractUploadNextButton => '다음';

  @override
  String get contractUploadEmptyError => '파일을 선택해주세요';

  @override
  String get contractViewerTitle => '계약서 확인';

  @override
  String get contractViewerConfirmButton => '다음';

  @override
  String get inviteCodeTitle => '초대 코드';

  @override
  String get inviteCodeHeading => '초대 코드가 생성됐어요!';

  @override
  String get inviteCodeSubtitle => '아래 코드를 직원에게 공유해주세요';

  @override
  String get inviteCodeCopyButton => '코드 복사';

  @override
  String get inviteCodeCopied => '클립보드에 복사됐어요';

  @override
  String get inviteCodeShareKakao => '카카오';

  @override
  String get inviteCodeShareLine => '라인';

  @override
  String get inviteCodeShareOther => '기타';

  @override
  String get inviteCodeDoneButton => '완료';

  @override
  String get inviteCodeShareKakaoButton => '카카오톡으로 공유하기';

  @override
  String get employeeManagementTitle => '직원 관리';

  @override
  String get employeeListEmptyHeading => '등록된 직원이 없어요';

  @override
  String get employeeListEmptySubtitle => '직원을 추가하고 관리해보세요';

  @override
  String get employeeDetailTitle => '직원 상세';

  @override
  String get employeeRoleLabel => '부여 역할';

  @override
  String get employeeStartDateLabel => '근무 시작일';

  @override
  String get employeeRoleChangeButton => '직원 롤 변경';

  @override
  String get employeeContractRequestButton => '근로계약서 수정 요청';

  @override
  String get employeeResignButton => '퇴직 처리';

  @override
  String get employeeRoleChangeTitle => '롤 변경';

  @override
  String get employeeResignDialogTitle => '퇴직 처리하시겠습니까?';

  @override
  String get employeeResignDialogMessage => '이 직원의 모든 권한이 해제되고\n퇴직 처리됩니다.';

  @override
  String get employeeStatusActive => '재직중';

  @override
  String get employeeStatusResigned => '퇴직';

  @override
  String get employeeRoleSelectTitle => '역할 선택';

  @override
  String get employeeRoleSelectHeading => '직원에게 할당할 역할을 선택해주세요';

  @override
  String get employeeRoleSelectSearchHint => '역할 검색';

  @override
  String get employeeRoleSelectEmpty => '검색 결과가 없어요';

  @override
  String get employeeRoleSelectNoRole => '알맞은 역할이 없다면?';

  @override
  String get employeeRoleSelectCreateButton => '새 역할 만들기';

  @override
  String get appTitle => '소상공인';

  @override
  String get confirmButton => '확인';

  @override
  String get cancelButton => '취소';

  @override
  String get skipButton => '나중에 하기';

  @override
  String get agreeButton => '위 내용에 동의합니다';

  @override
  String get newBadge => 'NEW';

  @override
  String get networkError => '네트워크 오류가 발생했습니다.';

  @override
  String get retryButton => '다시 시도';

  @override
  String get maintenanceDialogTitle => '서비스 점검 중';

  @override
  String get maintenanceStartLabel => '시작';

  @override
  String get maintenanceEndLabel => '종료';

  @override
  String get forceUpdateDialogTitle => '업데이트 필요';

  @override
  String get forceUpdateDialogMessage => '서비스 이용을 위해 최신 버전으로 업데이트해 주세요.';

  @override
  String get optionalUpdateDialogTitle => '새 버전 안내';

  @override
  String get optionalUpdateDialogMessage => '더 나은 서비스를 위해 업데이트를 권장합니다.';

  @override
  String updateDialogLatestVersion(String version) {
    return '최신 버전: $version';
  }

  @override
  String get updateButton => '업데이트';
}
