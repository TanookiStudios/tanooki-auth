import java.util.Properties

// Wear OS app. Same application ID and signing key as the phone app, which the Wearable Data Layer
// requires before it will pass favorites between them.
val releaseSigning = Properties().apply {
    val f = file("${System.getProperty("user.home")}/.tanooki-auth-signing/android.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.tanookistudios.auth.wear"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.tanookistudios.auth"
        minSdk = 30
        targetSdk = 36
        // shortcut: fixed version; Play needs it different from the phone APK's code. Bump on each Wear release.
        versionCode = 1000001
        versionName = "0.1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets["main"].java.srcDir("../shared/src")

    signingConfigs {
        if (releaseSigning.containsKey("storeFile")) {
            create("release") {
                storeFile = file(releaseSigning.getProperty("storeFile"))
                storePassword = releaseSigning.getProperty("storePassword")
                keyAlias = releaseSigning.getProperty("keyAlias")
                keyPassword = releaseSigning.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    implementation("com.google.android.gms:play-services-wearable:19.0.0")
    testImplementation("junit:junit:4.13.2")
}
