// ARB 파일 병합 스크립트
// 실행: dart run merge_arb.dart
//
// 역할:
//   lib/l10n/ 안의 ARB 파일들을  합쳐
//   app_ko.arb / app_en.arb 로 만듬
//
// 사용법:
//   1. 각자 담당 ARB 파일 수정 (auth_ko.arb, consent_ko.arb 등)
//   2. dart run merge_arb.dart
//   3. flutter gen-l10n
//
//   auth_ko/en.arb    → 로그인, 전화번호 인증
//   consent_ko/en.arb → 개인정보/급여 동의
//   account_ko/en.arb → 계좌 등록/관리
//   home_ko/en.arb    → 홈, 공지, 마이페이지
//   common_ko/en.arb  → 공통 (버튼, 에러 메시지 등)

import 'dart:convert';
import 'dart:io';

void main() {
  const l10nDir = 'lib/l10n/src'; // 피처 ARB 파일 위치
  const outputDir = 'lib/l10n';   // 합쳐진 파일 출력 위치
  const locales = ['ko', 'en'];

  // 합칠 피처 파일 순서 (app은 공통이라 마지막에 합침)
  const featureFiles = [
    'auth',
    'consent',
    'account',
    'home',
    'common', // 공통 (버튼, 에러 메시지 등)
  ];

  for (final locale in locales) {
    final merged = <String, dynamic>{
      '@@locale': locale,
    };

    // 피처 파일들 순서대로 합치기
    for (final feature in featureFiles) {
      final file = File('$l10nDir/${feature}_$locale.arb');
      if (!file.existsSync()) {
        print('⚠️  파일 없음: ${file.path} (건너뜀)');
        continue;
      }

      final content = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final entry in content.entries) {
        // @@locale은 이미 설정했으므로 스킵
        if (entry.key == '@@locale') continue;

        // 중복 키 검사
        if (merged.containsKey(entry.key)) {
          print(' 중복 키 발견: "${entry.key}" in ${feature}_$locale.arb');
          exit(1);
        }

        merged[entry.key] = entry.value;
      }
    }

    // 결과를 app_locale.arb에 덮어쓰기
    final output = File('$outputDir/app_$locale.arb');
    const encoder = JsonEncoder.withIndent('  ');
    output.writeAsStringSync(encoder.convert(merged));
    print(' app_$locale.arb 생성 완료 (${merged.length - 1}개 키)');
  }

  print(' 완료! 이제 flutter gen-l10n 실행하세요.');
}