plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter plugin must be after Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nalata"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.nalata"
        minSdk = flutter.minSdkVersion
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

dependencies {
    // Firebase BOM — use sem versões nas dependências Firebase específicas
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
    // exemplo: implementation("com.google.firebase:firebase-auth-ktx")
}

// indica onde está o projeto Flutter
flutter {
    source = "../.."
}

// no Kotlin DSL, aplique o plugin do Google Services assim (no final do arquivo)
apply(plugin = "com.google.gms.google-services")
