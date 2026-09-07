# CUPPO Google Play 릴리즈 체크리스트

## 현재 프로젝트 기본값
- 앱 표시 이름: `CUPPO`
- Dart 프로젝트: `cuppo`
- Android applicationId / package name: `com.cuppo.coffeejournal`
- 앱 버전: `1.0.0+2`
- Android targetSdk: `36` (bootstrap 후 패치)
- 가격 권장: 무료
- 스토어 기본 언어 권장: 한국어(대한민국)

## 중요한 signing 원칙
CUPPO는 이미 Google Play 내부 테스트에 업로드된 앱입니다.

**새 upload key를 만들지 마세요.** 기존 Play 업로드에 사용한 CUPPO upload key를 계속 사용해야 합니다.

권장 로컬 키 위치:

```text
C:/dev/keys/cuppo-upload-key.jks
```

실제 key와 비밀번호는 Git에 커밋하지 않습니다.

## 로컬 첫 실행
Windows PowerShell:
```powershell
./tool/bootstrap_android.ps1
flutter run
```

Git Bash / macOS / Linux:
```bash
./tool/bootstrap_android.sh
flutter run
```

bootstrap 스크립트는 기존 `android/key.properties`가 있으면 임시 백업 후 복원하며, 생성된 Android 프로젝트에 release signing 설정을 다시 적용합니다.

## 기존 CUPPO key를 외부 키 폴더로 통일하기
기존 CUPPO upload keystore를 먼저 찾은 뒤, 새 키를 생성하지 말고 아래 위치로 복사하거나 이동하세요.

```text
C:/dev/keys/cuppo-upload-key.jks
```

그 다음:

```bash
cp tool/key.properties.example android/key.properties
```

`android/key.properties`에서 실제 기존 CUPPO key의 비밀번호만 입력합니다.

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=C:/dev/keys/cuppo-upload-key.jks
```

`keyAlias`가 기존 key에서 `upload`가 아니라면 기존 alias 값을 사용해야 합니다.

## Play용 signed AAB 빌드
Git Bash에서:

```bash
bash tool/build_release.sh
```

스크립트가 다음을 실행합니다.

1. Android 프로젝트 존재 여부 확인 / 필요 시 bootstrap
2. `android/key.properties` 확인
3. `storeFile`의 외부 CUPPO key 존재 여부 확인
4. `flutter clean`
5. `flutter pub get`
6. `flutter analyze`
7. `flutter test`
8. `flutter build appbundle --release`

결과물:

```text
build/app/outputs/bundle/release/app-release.aab
```

## Play용 AAB 전에 꼭 할 것
1. 기존 Play 업로드에 사용한 CUPPO upload key인지 확인
2. Android Studio SDK Manager에서 Android API 36 SDK 설치
3. 앱을 실제 기기에서 충분히 테스트
4. `pubspec.yaml`의 버전/빌드 번호가 Play Console의 기존 build number보다 큰지 확인
5. `bash tool/build_release.sh`
6. 생성된 `app-release.aab`를 내부 테스트 트랙에 업로드

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

## GitHub Actions
현재 `Android CI` workflow의 AAB artifact는 `cuppo-ci-aab-not-for-play`이며 Play용 signed release로 취급하지 않습니다.

Play 업로드에는 로컬에서 기존 CUPPO upload key로 만든 signed AAB를 사용하세요.
