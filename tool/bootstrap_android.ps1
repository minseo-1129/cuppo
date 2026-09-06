$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Temp = Join-Path $env:TEMP ("cuppo_flutter_" + [guid]::NewGuid().ToString())

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter가 설치되어 있지 않습니다. Flutter SDK 설치 후 다시 실행하세요."
}

$AssetZip = Join-Path $Root "tool\assets_bundle\assets.zip"
if (-not (Test-Path $AssetZip)) { throw "tool/assets_bundle/assets.zip 이 없습니다." }
python -c "import pathlib,zipfile; zipfile.ZipFile(pathlib.Path(r'$AssetZip')).extractall(r'$Root')"

New-Item -ItemType Directory -Path $Temp | Out-Null
try {
  flutter create --no-pub --platforms=android --org com.cuppo --project-name coffeejournal (Join-Path $Temp "coffeejournal")
  $Android = Join-Path $Root "android"
  if (Test-Path $Android) { Remove-Item -Recurse -Force $Android }
  Copy-Item -Recurse (Join-Path $Temp "coffeejournal\android") $Android
  python (Join-Path $Root "tool\patch_android.py")
  Push-Location $Root
  flutter pub get
  Pop-Location
  Write-Host "완료. 프로젝트 루트에서 flutter run 을 실행하세요."
}
finally {
  if (Test-Path $Temp) { Remove-Item -Recurse -Force $Temp }
}
