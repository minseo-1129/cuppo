#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter가 설치되어 있지 않습니다. Flutter SDK 설치 후 다시 실행하세요."
  exit 1
fi

if [[ ! -d "$ROOT/assets" ]]; then
  echo "assets/ 폴더가 없습니다. CUPPO 런타임 에셋을 repository의 assets/에 추가하세요."
  exit 1
fi

KEY_PROPERTIES_BACKUP="$TMP/key.properties"
if [[ -f "$ROOT/android/key.properties" ]]; then
  cp "$ROOT/android/key.properties" "$KEY_PROPERTIES_BACKUP"
fi

flutter create --no-pub --platforms=android --org com.cuppo --project-name coffeejournal "$TMP/coffeejournal"
rm -rf "$ROOT/android"
cp -R "$TMP/coffeejournal/android" "$ROOT/android"
python3 "$ROOT/tool/patch_android.py"
python3 "$ROOT/tool/configure_release_signing.py"

if [[ -f "$KEY_PROPERTIES_BACKUP" ]]; then
  cp "$KEY_PROPERTIES_BACKUP" "$ROOT/android/key.properties"
fi

cd "$ROOT"
flutter pub get

echo
echo "완료. 다음 명령으로 실행하세요:"
echo "  flutter run"
