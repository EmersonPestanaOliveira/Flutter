import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

fun googleMapsApiKey(): String {
    val dartDefines = providers.gradleProperty("dart-defines").orNull
    if (!dartDefines.isNullOrBlank()) {
        dartDefines.split(',')
            .mapNotNull { encoded ->
                runCatching {
                    String(Base64.getDecoder().decode(encoded))
                }.getOrNull()
            }
            .firstOrNull { decoded -> decoded.startsWith("GOOGLE_MAPS_API_KEY=") }
            ?.substringAfter('=')
            ?.takeIf { key -> key.isNotBlank() }
            ?.let { key -> return key }
    }

    val localProperties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use(localProperties::load)
        localProperties.getProperty("GOOGLE_MAPS_API_KEY")
            ?.takeIf { key -> key.isNotBlank() }
            ?.let { key -> return key }
    }

    return System.getenv("GOOGLE_MAPS_API_KEY") ?: ""
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.12.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "com.emerson.gabriel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.emerson.gabriel"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey()
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}