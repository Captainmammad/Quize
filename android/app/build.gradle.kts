android {
    namespace = "com.mho.quize"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.mho.quize"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // مسیر keystore نسبت به app/build.gradle.kts
            storeFile = file("../app/my-release-key.jks")
            storePassword = "@Mho1389"
            keyAlias = "my-key-alias"
            keyPassword = "@Mho1389"
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
            signingConfig = signingConfigs.getByName("release") // اگه میخوای دیباگ هم با همون keystore باشه
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}
