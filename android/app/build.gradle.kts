plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter Gradle Plugin باید بعد از Android و Kotlin بیاد
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

// بارگذاری key.properties برای امضای Release
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.mho.quize"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.14033849"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.mho.quize"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
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

// اضافه کردن Maven محلی برای JARهای مورد نیاز
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("C:/android-maven-repo") // مسیر JARهای lint-checks و uast و intellij-core
        }
    }
}

dependencies {
    // Native JARها
    implementation(files("libs/armeabi_v7a_release-1.0.0-ddf47dd3ff96dbde6d9c614db0d7f019d7c7a2b7.jar"))
    implementation(files("libs/arm64_v8a_release-1.0.0-ddf47dd3ff96dbde6d9c614db0d7f019d7c7a2b7.jar"))
    implementation(files("libs/x86_64_release-1.0.0-ddf47dd3ff96dbde6d9c614db0d7f019d7c7a2b7.jar"))

    // Dependencies با exclude برای Kotlin DSL
    implementation("com.android.tools.lint:lint-checks:31.9.1")

    implementation("com.android.tools.external.org-jetbrains:uast:31.9.1") {
        exclude(group = "org.jetbrains", module = "annotations")
    }

    implementation("com.android.tools.external.com-intellij:intellij-core:31.9.1") {
        exclude(group = "org.jetbrains", module = "annotations")
    }
}



flutter {
    source = "../.."
}
