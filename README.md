# CUPPO

CUPPO는 마신 커피를 레시피와 메모로 기록하고 다시 탐색하는 Flutter 기반 개인 커피 저널 앱입니다.

## v2 개발 범위

현재 `v2` 브랜치는 `2.0.0+3`으로 개발 중입니다.

### Phase 1 · 안정화 / 데이터 모델

- v1 `shared_preferences` 기록 키 유지로 기존 사용자 데이터 호환
- 날짜 + 기록 시각 기준 정렬
- 월별 기록 조회 및 월간 집계 계층 분리
- 메뉴별 카페인 데이터와 월간 통계 모델 추가

### Phase 2 · 탐색 완성도

- Feed 월 선택
- 리스트 / 3열 Grid 전환
- 월별 Calendar 탐색
- 같은 날 여러 기록 선택
- 메뉴 8종 필터
- 메뉴명 / 제목 / 메모 검색

### Phase 3 · 월간 취향 / 카페인

- 가장 많이 마신 레시피 조합
- 메뉴 분포
- 아이스 / 핫 비율
- 자주 마신 시간
- 일별 카페인 흐름
- 월 총 카페인 / 잔당 평균
- 일 400mg 기준 목표선 통계

### Phase 4 · Detail / 카드 공유

- 기록 상세 레시피 4칸 요약
- 카페인 / 기록 시각 표시
- 기록 삭제
- 4:5 CUPPO 카드 렌더링
- 카드 PNG 갤러리 저장
- Android 공유 시트 공유

사진 촬영 / 사진 첨부 / 배경 제거 기능은 이번 v2 범위에서 제외합니다.

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
