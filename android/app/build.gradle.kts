plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.io.File

android {
    namespace = "com.mho.quize"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.mho.quize"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // گرفتن متغیرهای Bitrise
    val keystoreFile = file("app/my-release-key.jks") // مسیر فایل keystore داخل پروژه
    val keystoreAlias = System.getenv("BITRISEIO_ANDROID_KEYSTORE_ALIAS")
        ?: error("Key alias env not set!")
    val keystorePassword = System.getenv("BITRISEIO_ANDROID_KEYSTORE_PASSWORD")
        ?: error("Keystore password env not set!")
    val keyPassword = System.getenv("BITRISEIO_ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD")
        ?: error("Key password env not set!")

    signingConfigs {
        create("release") {
            storeFile = keystoreFile
            keyAlias = keystoreAlias
            storePassword = keystorePassword
            keyPassword = keyPassword
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
