#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -d android ]]; then
  echo "android/ 폴더가 없어 bootstrap을 먼저 실행합니다."
  ./tool/bootstrap_android.sh
fi

if [[ ! -f android/key.properties ]]; then
  echo "android/key.properties가 없습니다."
  echo "먼저 다음을 실행하세요:"
  echo "  cp tool/key.properties.example android/key.properties"
  echo "그 다음 기존 CUPPO upload key의 비밀번호를 입력하세요."
  exit 1
fi

STORE_FILE="$(awk -F= '/^storeFile=/{sub(/^storeFile=/, ""); print; exit}' android/key.properties | tr -d '\r')"
if [[ -z "$STORE_FILE" ]]; then
  echo "android/key.properties에 storeFile이 없습니다."
  exit 1
fi

KEY_PATH="$STORE_FILE"
if command -v cygpath >/dev/null 2>&1; then
  KEY_PATH="$(cygpath -u "$STORE_FILE" 2>/dev/null || printf '%s' "$STORE_FILE")"
fi

if [[ ! -f "$KEY_PATH" && ! -f "$STORE_FILE" ]]; then
  echo "CUPPO upload key를 찾을 수 없습니다: $STORE_FILE"
  exit 1
fi

flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release

echo
echo "Done."
echo "AAB: build/app/outputs/bundle/release/app-release.aab"
