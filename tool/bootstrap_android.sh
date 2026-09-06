#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter가 설치되어 있지 않습니다. Flutter SDK 설치 후 다시 실행하세요."
  exit 1
fi

ASSET_ZIP="$ROOT/tool/assets_bundle/assets.zip"
if [[ ! -f "$ASSET_ZIP" ]]; then
  echo "tool/assets_bundle/assets.zip 이 없습니다."
  exit 1
fi

python3 - <<PYASSETS
from pathlib import Path
from zipfile import ZipFile
root = Path(r"$ROOT")
bundle = root / "tool" / "assets_bundle" / "assets.zip"
with ZipFile(bundle) as z:
    z.extractall(root)
PYASSETS

flutter create --no-pub --platforms=android --org com.cuppo --project-name coffeejournal "$TMP/coffeejournal"
rm -rf "$ROOT/android"
cp -R "$TMP/coffeejournal/android" "$ROOT/android"
python3 "$ROOT/tool/patch_android.py"
cd "$ROOT"
flutter pub get

echo
echo "완료. 다음 명령으로 실행하세요:"
echo "  flutter run"
