# CUPPO Google Play 릴리즈 체크리스트

## 현재 Play / 프로젝트 버전
- 앱 표시 이름: `CUPPO`
- Dart 프로젝트: `cuppo`
- Android applicationId / package name: `com.cuppo.coffeejournal`
- Google Play 내부 테스트 최신 버전: versionCode `1` / versionName `1.0.0`
- 다음 배포 예정 버전: versionCode `2` / versionName `0.2.0`
- `pubspec.yaml`: `0.2.0+2`
- Android targetSdk: `36` (bootstrap 후 패치)

> Google Play 업데이트에서는 기존에 업로드된 값보다 큰 `versionCode`가 필요합니다.
> 표시 버전인 `versionName`은 `0.2.0`으로 사용할 수 있으므로 이번 배포는 `0.2.0+2`로 진행합니다.

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
1. 앱을 실제 기기에서 충분히 테스트
2. Play Console에 등록한 upload key(keystore)를 준비
3. GitHub Repository Secrets에 아래 4개 값을 등록
   - `ANDROID_KEYSTORE_BASE64`
   - `ANDROID_KEY_ALIAS`
   - `ANDROID_KEY_PASSWORD`
   - `ANDROID_STORE_PASSWORD`
4. `pubspec.yaml`이 `0.2.0+2`인지 확인
5. GitHub Actions → **Android Release AAB** → Run workflow
6. 성공 후 `cuppo-v0.2.0-build-2-aab` artifact에서 `app-release.aab` 다운로드
7. Play Console 내부 테스트 트랙에 새 출시를 만들고 AAB 업로드

## GitHub Actions 배포 흐름
배포 workflow는 다음 순서로 동작합니다.
1. Flutter / Java / Android API 36 준비
2. `ANDROID_KEYSTORE_BASE64`를 임시 keystore 파일로 복원
3. Android 프로젝트 bootstrap
4. release signing 설정 적용
5. `flutter analyze`
6. `flutter test`
7. signed `flutter build appbundle --release`
8. Play 업로드용 AAB artifact 저장

> 업로드 키 파일과 비밀번호는 절대 Git에 커밋하지 않습니다.

## 배포 후 확인
- Play Console에 표시되는 새 versionCode가 `2`인지 확인
- 표시 버전이 `0.2.0`인지 확인
- 내부 테스터 계정에서 업데이트 설치 확인
- 주요 화면과 기록 저장/조회 동작 확인
