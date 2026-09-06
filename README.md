# CUPPO — 커피 기록 앱

CUPPO 디자인 핸드오프를 Flutter로 옮긴 Android MVP입니다. 커피 메뉴와 레시피를 선택하고 제목/메모를 붙여 로컬에 저장하며, 피드·갤러리·달력·검색에서 다시 볼 수 있습니다.

## v1 기능
- 온보딩 3단계
- 커피 기록 피드 / 3열 갤러리
- 메뉴 8종
- 온도 / 우유 / 시럽 / 장식 레시피 설정
- 제목 / 메모 입력
- SharedPreferences 로컬 저장
- 기록 상세 / 삭제
- 월별 달력
- 제목·메모 검색 및 메뉴 필터
- 라이트 / 다크 모드

사진 촬영/배경 제거, 공유 카드, 취향 리포트, 카페인 차트, 홈 위젯은 v1.1 이후 범위입니다.

## 로컬 실행
준비물: Flutter stable, Android Studio, Android SDK API 36, Android 기기 또는 에뮬레이터.

macOS / Linux:
```bash
./tool/bootstrap_android.sh
flutter run
```

Windows PowerShell:
```powershell
./tool/bootstrap_android.ps1
flutter run
```

`bootstrap_android`는 현재 Flutter SDK와 호환되는 표준 Android 플랫폼을 생성한 뒤 다음 값을 적용합니다.
- applicationId / namespace: `com.cuppo.coffeejournal`
- compileSdk / targetSdk: `36`
- 앱 표시 이름: `CUPPO`
- CUPPO 런처 아이콘

## GitHub Actions
`.github/workflows/android-ci.yml`은 push/PR마다 다음을 확인합니다.
1. Android 플랫폼 생성
2. `flutter analyze`
3. `flutter test`
4. debug AAB 빌드
5. `cuppo-debug-aab` artifact 업로드

`.github/workflows/android-release.yml`은 수동 실행용 signed release AAB 빌드입니다. Repository Secrets에 아래 4개를 설정해야 합니다.
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`
- `ANDROID_STORE_PASSWORD`

keystore를 base64로 만드는 예:
```bash
base64 < upload-keystore.jks | tr -d '\n'
```

release workflow 결과물은 `cuppo-release-aab` artifact로 업로드됩니다.

## 코드 구조
- `lib/main.dart` — 앱 테마 / 시작점
- `lib/state/` — 앱 상태와 로컬 데이터
- `lib/models/coffee_record.dart` — 핵심 Record 모델
- `lib/data/menu_catalog.dart` — 메뉴, 카페인, 일러스트 규칙
- `lib/screens/record_flow/` — 메뉴 → 레시피 → 저장 흐름
- `lib/screens/feed_screen.dart` — 피드 / 갤러리
- `lib/screens/calendar_screen.dart` — 달력
- `lib/screens/search_screen.dart` — 검색 / 필터
- `lib/screens/detail_screen.dart` — 상세 / 삭제
- `tool/assets_bundle/part_*.b64` — WebP 최적화된 CUPPO 런타임/Android 아이콘 에셋 묶음. bootstrap 시 `assets/`와 `platform_assets/`로 자동 복원

## 데이터
현재는 `shared_preferences`에 JSON으로 저장합니다. 개인 로컬 기록용 v1에는 단순하고 충분합니다. 사진, 대량 데이터, 백업/동기화가 들어가는 시점에는 SQLite/Drift 또는 Isar 같은 영속 저장소로 마이그레이션하는 편이 좋습니다.

Google Play 등록 단계는 `PLAY_RELEASE_CHECKLIST.md`를 참고하세요.
