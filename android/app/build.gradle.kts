plugins {
    id 'com.android.application'
    id 'kotlin-android'
}

android {
    namespace = "com.mho.quize"
    compileSdk = 34 // یا همون flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.mho.quize"
        minSdk = 21 // یا flutter.minSdkVersion
        targetSdk = 34 // یا flutter.targetSdkVersion
        versionCode = 1 // یا flutter.versionCode
        versionName = "1.0.0" // یا flutter.versionName

        // برای multidex اگر نیاز شد
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
            signingConfig signingConfigs.release // اگه میخوای دیباگ هم با همون keystore باشه
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    // اگر لازم بود flavor اضافه کنید
    // flavorDimensions "version"
    // productFlavors { ... }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"
    implementation 'androidx.multidex:multidex:2.0.1'
    implementation "androidx.core:core-ktx:1.12.0"
    implementation "androidx.appcompat:appcompat:1.7.0"
    implementation "com.google.android.material:material:1.11.0"
}

// برای پروژه Flutter، باقی کدها توسط Flutter مدیریت می‌شوند.
apply plugin: 'com.google.gms.google-services' // اگر firebase استفاده می‌کنید
س
