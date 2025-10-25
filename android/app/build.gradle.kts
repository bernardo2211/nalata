plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter plugin must be after Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nalata"
    compileSdk = flutter.compileSdkVersion

    // 🔧 Define o NDK compatível com os plugins Firebase
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.nalata"

        // 🔧 Define manualmente o minSdk = 23
        minSdk = 23

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}



flutter {
    source = "../.."
}

// 🔧 Importante — plugin do Google Services no final
apply(plugin = "com.google.gms.google-services")
