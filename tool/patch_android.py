from pathlib import Path
import shutil
import re

root = Path(__file__).resolve().parents[1]
android = root / 'android'
if not android.exists():
    raise SystemExit('android/ 폴더가 없습니다. 먼저 bootstrap 스크립트를 실행하세요.')

# App label
for manifest in android.rglob('AndroidManifest.xml'):
    text = manifest.read_text(encoding='utf-8')
    text = re.sub(r'android:label="[^"]+"', 'android:label="CUPPO"', text)
    manifest.write_text(text, encoding='utf-8')

# Compile / target API 36. Supports Kotlin DSL and Groovy templates.
for gradle in [android/'app'/'build.gradle.kts', android/'app'/'build.gradle']:
    if not gradle.exists():
        continue
    text = gradle.read_text(encoding='utf-8')
    replacements = {
        'compileSdk = flutter.compileSdkVersion': 'compileSdk = 36',
        'targetSdk = flutter.targetSdkVersion': 'targetSdk = 36',
        'compileSdkVersion flutter.compileSdkVersion': 'compileSdkVersion 36',
        'targetSdkVersion flutter.targetSdkVersion': 'targetSdkVersion 36',
    }
    for old, new in replacements.items():
        text = text.replace(old, new)
    text = re.sub(r'compileSdk\s*=\s*\d+', 'compileSdk = 36', text)
    text = re.sub(r'targetSdk\s*=\s*\d+', 'targetSdk = 36', text)
    text = re.sub(r'compileSdkVersion\s+\d+', 'compileSdkVersion 36', text)
    text = re.sub(r'targetSdkVersion\s+\d+', 'targetSdkVersion 36', text)
    gradle.write_text(text, encoding='utf-8')

src_root = root / 'platform_assets' / 'android'
res = android / 'app' / 'src' / 'main' / 'res'
for src_dir in src_root.glob('mipmap-*'):
    dst_dir = res / src_dir.name
    dst_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src_dir/'ic_launcher.png', dst_dir/'ic_launcher.png')

for gradle in [android/'app'/'build.gradle.kts', android/'app'/'build.gradle']:
    if not gradle.exists():
        continue
    text = gradle.read_text(encoding='utf-8')
    text = re.sub(r'namespace\s*=\s*"[^"]+"', 'namespace = "com.cuppo.coffeejournal"', text)
    text = re.sub(r'applicationId\s*=\s*"[^"]+"', 'applicationId = "com.cuppo.coffeejournal"', text)
    text = re.sub(r'namespace\s+"[^"]+"', 'namespace "com.cuppo.coffeejournal"', text)
    text = re.sub(r'applicationId\s+"[^"]+"', 'applicationId "com.cuppo.coffeejournal"', text)
    gradle.write_text(text, encoding='utf-8')

print('Android 설정 완료: com.cuppo.coffeejournal / targetSdk 36 / CUPPO 아이콘')
