# CUPPO

CUPPO는 마신 커피를 레시피와 메모로 기록하고 다시 탐색하는 Flutter 기반 개인 커피 저널 앱입니다.

## v1 범위

- 온보딩
- 기록 피드 / 3열 갤러리
- 메뉴 8종
- 온도 / 우유 / 시럽 / 장식 선택
- 제목 / 메모 저장
- 기록 상세 / 삭제
- 월별 캘린더
- 검색 / 메뉴 필터
- 다크 모드
- 로컬 저장 (`shared_preferences`)

사진/배경 제거, 취향 리포트, 홈 위젯은 후속 버전 범위입니다.

## 로컬 실행

Flutter SDK 설치 후:

```bash
./tool/bootstrap_android.sh
flutter run
```

Windows PowerShell:

```powershell
./tool/bootstrap_android.ps1
flutter run
```

`bootstrap_android` 스크립트는 저장소의 런타임 에셋 번들을 복원한 뒤 Android 프로젝트를 생성하고 다음 설정을 적용합니다.

- applicationId: `com.cuppo.coffeejournal`
- targetSdk / compileSdk: 36
- 앱 이름: CUPPO

런타임 이미지 번들은 `tool/assets_bundle/assets.zip`에 바이너리 ZIP으로 저장되어 CI와 로컬 부트스트랩에서 동일하게 사용됩니다.

## 검증

```bash
flutter analyze
flutter test
flutter build appbundle --release
```

GitHub Actions에서도 같은 흐름으로 Android 빌드를 검증합니다.

## Play 배포

Play Console에 올릴 최종 AAB는 개인 업로드 키로 서명해야 합니다. 저장소에는 키/비밀번호를 커밋하지 않습니다. 자세한 절차는 `PLAY_RELEASE_CHECKLIST.md`를 확인하세요.
