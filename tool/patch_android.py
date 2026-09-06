from pathlib import Path
import os
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

release_signing = os.getenv('CUPPO_RELEASE_SIGNING') == '1'

for gradle in [android/'app'/'build.gradle.kts', android/'app'/'build.gradle']:
    if not gradle.exists():
        continue

    text = gradle.read_text(encoding='utf-8')
    text = re.sub(r'namespace\s*=\s*"[^"]+"', 'namespace = "com.cuppo.coffeejournal"', text)
    text = re.sub(r'applicationId\s*=\s*"[^"]+"', 'applicationId = "com.cuppo.coffeejournal"', text)
    text = re.sub(r'namespace\s+"[^"]+"', 'namespace "com.cuppo.coffeejournal"', text)
    text = re.sub(r'applicationId\s+"[^"]+"', 'applicationId "com.cuppo.coffeejournal"', text)

    if release_signing:
        required_env = [
            'ANDROID_KEYSTORE_PATH',
            'ANDROID_STORE_PASSWORD',
            'ANDROID_KEY_ALIAS',
            'ANDROID_KEY_PASSWORD',
        ]
        missing = [name for name in required_env if not os.getenv(name)]
        if missing:
            raise SystemExit('릴리즈 서명 환경 변수가 없습니다: ' + ', '.join(missing))

        if gradle.suffix == '.kts':
            signing_block = '''    signingConfigs {
        create("release") {
            storeFile = file(System.getenv("ANDROID_KEYSTORE_PATH"))
            storePassword = System.getenv("ANDROID_STORE_PASSWORD")
            keyAlias = System.getenv("ANDROID_KEY_ALIAS")
            keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
        }
    }

'''
            if 'create("release")' not in text:
                text = text.replace('    buildTypes {', signing_block + '    buildTypes {', 1)
            text = text.replace(
                'signingConfig = signingConfigs.getByName("debug")',
                'signingConfig = signingConfigs.getByName("release")',
            )
        else:
            signing_block = '''    signingConfigs {
        release {
            storeFile file(System.getenv("ANDROID_KEYSTORE_PATH"))
            storePassword System.getenv("ANDROID_STORE_PASSWORD")
            keyAlias System.getenv("ANDROID_KEY_ALIAS")
            keyPassword System.getenv("ANDROID_KEY_PASSWORD")
        }
    }

'''
            if 'signingConfigs {' not in text:
                text = text.replace('    buildTypes {', signing_block + '    buildTypes {', 1)
            text = text.replace('signingConfig signingConfigs.debug', 'signingConfig signingConfigs.release')
            text = text.replace('signingConfig = signingConfigs.debug', 'signingConfig = signingConfigs.release')

    gradle.write_text(text, encoding='utf-8')

print('Android 설정 완료: com.cuppo.coffeejournal / targetSdk 36 / CUPPO 아이콘')
if release_signing:
    print('Release signing 설정 완료')
