# Routes

앱의 라우트 경로 정보입니다.

## Initial Location

`/splash`

## Root Routes (`routes/root_routes.dart`)

| 경로 | 화면 | 파라미터 | 설명 |
|------|------|----------|------|
| `/splash` | `SplashScreen` | - | 스플래시 화면. 2초 후 `/login`으로 이동 |
| `/login` | `LoginScreen` | - | 카카오 로그인 화면 |
| `/phone-verification` | `PhoneVerificationScreen` | - | 휴대폰 번호 입력 |
| `/phone-code` | `PhoneCodeScreen` | `extra: String` (전화번호) | 6자리 인증번호 입력 |
| `/home` | `HomeScreen` | - | 메인 홈 화면 |

## Home Sub Routes (`routes/home_routes.dart`)

| 경로 | 화면 | 파라미터 | 설명 |
|------|------|----------|------|
| `/home/notices` | `NoticesScreen` | - | 공지사항 목록 |
| `/home/notices/:id` | `NoticeDetailScreen` | `extra: Notice` | 공지사항 상세 |

## 화면 흐름

```
/splash → /login → /phone-verification → /phone-code → /home
                                                         ├── /home/notices
                                                         │    └── /home/notices/:id
```
