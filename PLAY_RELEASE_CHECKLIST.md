# CUPPO Google Play 릴리즈 체크리스트

## 현재 프로젝트 기본값
- 앱 표시 이름: `CUPPO`
- Dart 프로젝트: `cuppo`
- Android applicationId / package name: `com.cuppo.coffeejournal`
- 앱 버전: `1.0.0+1`
- Android targetSdk: `36` (bootstrap 후 패치)
- 가격 권장: 무료
- 스토어 기본 언어 권장: 한국어(대한민국)

## 로컬 첫 실행
Windows PowerShell:
```powershell
./tool/bootstrap_android.ps1
flutter run
```

macOS / Linux:
```bash
./tool/bootstrap_android.sh
flutter run
```

## Play용 AAB 전에 꼭 할 것
1. Android Studio SDK Manager에서 Android API 36 SDK 설치
2. 앱을 실제 기기에서 충분히 테스트
3. 업로드 키(keystore)를 생성하고 Android release signing 설정
4. `pubspec.yaml`의 버전/빌드 번호 확인
5. `flutter clean && flutter pub get`
6. `flutter build appbundle --release`
7. 결과물: `build/app/outputs/bundle/release/app-release.aab`

> Flutter의 기본 생성 템플릿은 release 빌드에 debug signing을 임시로 사용할 수 있습니다.
> Play 업로드 전에는 반드시 본인의 upload key로 release signing을 설정하세요.

## v1 포함 기능
- 온보딩 3단계
- 커피 기록 피드
- 리스트 / 갤러리 보기
- 메뉴 8종
- 온도 / 우유 / 시럽 / 장식 레시피 설정
- 제목 / 메모 입력
- SharedPreferences 로컬 저장
- 기록 상세 / 삭제
- 월별 달력
- 제목·메모 검색 및 메뉴 필터
- 라이트 / 다크 모드

## v1.1 이후 권장
- 카메라 촬영 / 배경 제거
- 사진 저장 권한 및 사진 기반 카드
- 공유 카드 이미지 export
- 월간 취향 리포트
- 카페인 흐름 차트
- Android 홈 위젯
- 백업 / 복원

## GitHub Actions로 signed AAB 만들기
1. upload keystore 생성
2. GitHub Repository Secrets에 `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `ANDROID_STORE_PASSWORD` 등록
3. Actions → **Android Release AAB** → Run workflow
4. 성공 후 `cuppo-release-aab` artifact 다운로드
5. Play Console 내부 테스트 트랙에 `app-release.aab` 업로드

> 업로드 키/비밀번호는 절대 Git에 커밋하지 않습니다.
