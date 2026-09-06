from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
app = root / "android" / "app"
kts = app / "build.gradle.kts"
groovy = app / "build.gradle"

if kts.exists():
    text = kts.read_text(encoding="utf-8")
    if "keystoreProperties = Properties()" not in text:
        text = (
            "import java.util.Properties\n"
            "import java.io.FileInputStream\n\n"
            "val keystoreProperties = Properties()\n"
            "val keystorePropertiesFile = rootProject.file(\"key.properties\")\n"
            "if (keystorePropertiesFile.exists()) {\n"
            "    keystoreProperties.load(FileInputStream(keystorePropertiesFile))\n"
            "}\n\n" + text
        )

    if 'create("release")' not in text:
        signing = '''    signingConfigs {\n        create("release") {\n            keyAlias = keystoreProperties["keyAlias"] as String\n            keyPassword = keystoreProperties["keyPassword"] as String\n            storeFile = file(keystoreProperties["storeFile"] as String)\n            storePassword = keystoreProperties["storePassword"] as String\n        }\n    }\n\n'''
        text = text.replace("    buildTypes {", signing + "    buildTypes {", 1)

    text = text.replace(
        'signingConfig = signingConfigs.getByName("debug")',
        'signingConfig = signingConfigs.getByName("release")',
    )
    kts.write_text(text, encoding="utf-8")
    print("Configured release signing in build.gradle.kts")

elif groovy.exists():
    text = groovy.read_text(encoding="utf-8")
    if "keystoreProperties = new Properties()" not in text:
        text = (
            "def keystoreProperties = new Properties()\n"
            "def keystorePropertiesFile = rootProject.file('key.properties')\n"
            "if (keystorePropertiesFile.exists()) {\n"
            "    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))\n"
            "}\n\n" + text
        )

    if "signingConfigs {" not in text:
        signing = '''    signingConfigs {\n        release {\n            keyAlias keystoreProperties['keyAlias']\n            keyPassword keystoreProperties['keyPassword']\n            storeFile file(keystoreProperties['storeFile'])\n            storePassword keystoreProperties['storePassword']\n        }\n    }\n\n'''
        text = text.replace("    buildTypes {", signing + "    buildTypes {", 1)

    text = re.sub(r"signingConfig\s+signingConfigs\.debug", "signingConfig signingConfigs.release", text)
    groovy.write_text(text, encoding="utf-8")
    print("Configured release signing in build.gradle")
else:
    raise SystemExit("android/app/build.gradle(.kts) not found; run bootstrap_android first")
