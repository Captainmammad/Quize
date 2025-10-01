// build.gradle (Project-level)
plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services' // برای firebase اگر استفاده می‌کنید
}

android {
    namespace = "com.mho.quize"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.mho.quize"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled true
    }

    signingConfigs {
        release {
            storeFile file("my-release-key.jks")
            storePassword "@Mho1389"
            keyAlias "my-key-alias"
            keyPassword "@Mho1389"
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            signingConfig signingConfigs.release // اگر میخوای دیباگ هم با همون keystore باشه
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"
    implementation 'androidx.multidex:multidex:2.0.1'
    implementation "androidx.core:core-ktx:1.12.0"
    implementation "androidx.appcompat:appcompat:1.7.0"
    implementation "com.google.android.material:material:1.11.0"
}

// Flutter تنظیمات خودش را مدیریت می‌کند

// ==========================
// Script پیشنهادی برای Bitrise یا خط فرمان
// ==========================

// می‌توانید این بخش را به عنوان Script Step در Bitrise اضافه کنید
// فایل: scripts/update_flutter_android.sh

/*
#!/bin/bash
set -e

echo "=========================="
echo "Updating Flutter and Dart"
echo "=========================="
flutter upgrade
flutter pub get

echo "=========================="
echo "Cleaning old build artifacts"
echo "=========================="
flutter clean

echo "=========================="
echo "Updating Gradle Wrapper"
echo "=========================="
cd android
./gradlew wrapper --gradle-version 8.3 --distribution-type all
cd ..

echo "=========================="
echo "Building APK and App Bundle"
echo "=========================="
flutter build apk --release
flutter build appbundle --release
*/

