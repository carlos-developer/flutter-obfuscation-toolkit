# 🔧 Troubleshooting Avanzado - Ofuscación Flutter

> Casos especiales, problemas comunes y soluciones detalladas

---

## 📋 Índice

1. [Problemas de Build](#problemas-de-build)
2. [Crashes en Producción](#crashes-en-producción)
3. [Problemas de Plugins](#problemas-de-plugins)
4. [Casos Especiales por Framework](#casos-especiales-por-framework)
5. [Performance Issues](#performance-issues)
6. [Xcode/iOS Específicos](#xcodeios-específicos)
7. [Gradle/Android Específicos](#gradleandroid-específicos)
8. [Des-ofuscación Avanzada](#des-ofuscación-avanzada)

---

## 🔨 Problemas de Build

### Error: "Duplicate class found in modules"

**Síntoma**:
```
Duplicate class X found in modules:
  - module1.jar
  - module2.jar
```

**Causa**: Conflicto de dependencias (dos versiones del mismo paquete).

**Solución**:
1. Identifica las dependencias conflictivas:
   ```bash
   cd android && ./gradlew app:dependencies
   ```

2. Excluye la duplicada en `android/app/build.gradle.kts`:
   ```kotlin
   dependencies {
       implementation("com.example:library:1.0") {
           exclude(group = "com.conflicting", module = "module")
       }
   }
   ```

3. O fuerza una versión específica:
   ```kotlin
   configurations.all {
       resolutionStrategy {
           force("com.example:library:1.0.0")
       }
   }
   ```

---

### Error: "Expiry of build resource lock"

**Síntoma**:
```
Timeout waiting to lock buildscript class cache
```

**Causa**: Proceso Gradle colgado o daemon corrupto.

**Solución**:
```bash
# Detener daemons
cd android && ./gradlew --stop

# Limpiar cache
rm -rf ~/.gradle/caches/
rm -rf android/.gradle/

# Reintentar build
flutter clean
flutter build apk --release --obfuscate --split-debug-info=build/symbols/android
```

---

### Error: "R8: Missing class X" después de agregar ProGuard rule

**Síntoma**: Agregaste `-keep class X { *; }` pero sigue fallando.

**Causa**: La clase realmente no existe en el classpath (typo o dependencia faltante).

**Solución**:
1. Verifica el nombre completo de la clase (case-sensitive):
   ```bash
   # Buscar en tus fuentes
   find android -name "*.java" -o -name "*.kt" | xargs grep "class MiClase"
   ```

2. Si es de una librería, verifica que esté en `pubspec.yaml`

3. Usa `-dontwarn` si la clase es opcional:
   ```proguard
   -dontwarn com.optional.library.**
   ```

---

### Error: "Unresolved reference: BuildConfig"

**Síntoma**: Kotlin no encuentra `BuildConfig` después de habilitar R8.

**Solución**: Agrega en `proguard-rules.pro`:
```proguard
-keep class **.BuildConfig { *; }
```

---

## 💥 Crashes en Producción

### Crash: NullPointerException en clase ofuscada

**Stack trace obfuscado**:
```
java.lang.NullPointerException
    at com.example.a.b.c(Unknown Source:12)
    at com.example.d.e.f(Unknown Source:45)
```

**Solución paso a paso**:

1. **Des-ofuscar el stack trace**:
   ```bash
   ./scripts/deobfuscate.sh -p android -s crash.txt
   ```

2. **Resultado des-ofuscado**:
   ```
   java.lang.NullPointerException
       at com.example.myapp.services.UserService.getUser(UserService.kt:12)
       at com.example.myapp.ui.ProfileScreen.loadProfile(ProfileScreen.kt:45)
   ```

3. **Identificar la causa**: En este caso, `UserService.getUser()` retorna null.

4. **Si el crash es porque R8 eliminó código**:
   - Agrega la clase en `proguard-rules.pro`:
     ```proguard
     -keep class com.example.myapp.services.UserService { *; }
     -keep class com.example.myapp.models.User { *; }
     ```

5. **Rebuild y probar**.

---

### Crash: JSON serialization falla (Gson, json_serializable)

**Síntoma**: Modelos JSON no se deserializan, retornan null o valores por defecto.

**Causa**: R8 eliminó getters/setters o constructores necesarios.

**Solución para `json_serializable`**:
```proguard
# Preservar modelos generados
-keep class com.example.myapp.models.** { *; }
-keep class **\$serializer { *; }

# Preservar anotaciones
-keepattributes *Annotation*

# Si usas fromJson/toJson generados
-keepclassmembers class com.example.myapp.models.** {
    public <init>(...);
    public <fields>;
}
```

**Solución para `Gson`**:
```proguard
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Tus modelos
-keep class com.example.myapp.models.** { *; }
```

---

### Crash: IllegalAccessError al usar reflection

**Síntoma**:
```
java.lang.IllegalAccessError: Method 'void X.Y()' is inaccessible
```

**Causa**: R8 cambió el modificador de acceso a private.

**Solución**:
```proguard
# Permitir modificación de acceso
-allowaccessmodification

# O preservar métodos específicos
-keepclassmembers class com.example.MyClass {
    public void myMethod();
}
```

---

## 🔌 Problemas de Plugins

### Plugin: sqflite

**Síntoma**: Base de datos no se crea, queries fallan silenciosamente.

**Solución**:
```proguard
-keep class com.tekartik.sqflite.** { *; }
-keep class android.database.** { *; }
```

---

### Plugin: firebase_messaging

**Síntoma**: Notificaciones push no llegan o crashean al recibirlas.

**Solución**:
```proguard
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Tu servicio de notificaciones
-keep class com.example.myapp.MyFirebaseMessagingService { *; }

# Mantener métodos onMessage, onNewToken
-keepclassmembers class * extends com.google.firebase.messaging.FirebaseMessagingService {
    public void onMessageReceived(...);
    public void onNewToken(...);
}
```

---

### Plugin: image_picker / camera

**Síntoma**: FileProvider no encuentra el archivo o crashea al tomar foto.

**Solución**:
```proguard
-keep class androidx.core.content.FileProvider { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class io.flutter.plugins.camera.** { *; }
```

---

### Plugin: url_launcher

**Síntoma**: URLs no se abren, crashea al intentar abrir navegador.

**Solución**:
```proguard
-keep class io.flutter.plugins.urllauncher.** { *; }
-keep class android.content.Intent { *; }
```

---

### Plugin: shared_preferences

**Síntoma**: Preferencias no se guardan o se pierden.

**Solución**:
```proguard
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class android.content.SharedPreferences { *; }
```

---

### Plugin: webview_flutter

**Síntoma**: WebView en blanco, JavaScript no funciona.

**Solución**:
```proguard
-keep class io.flutter.plugins.webviewflutter.** { *; }
-keep class android.webkit.** { *; }

# JavaScript Interface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
```

---

## 🎨 Casos Especiales por Framework

### Usando Riverpod

**Problema**: Providers no se encuentran, StateNotifier crashea.

**Solución**:
```proguard
-keep class ** extends riverpod.StateNotifier { *; }
-keep class ** implements riverpod.ProviderBase { *; }

# Tus providers
-keep class com.example.myapp.providers.** { *; }
```

---

### Usando GetX

**Problema**: Controllers no se inyectan, dependencias fallan.

**Solución**:
```proguard
-keep class ** extends get.GetxController { *; }
-keep class get.Get { *; }

# Tus controllers
-keep class com.example.myapp.controllers.** { *; }
```

---

### Usando Bloc

**Problema**: Events o States no se mapean correctamente.

**Solución**:
```proguard
-keep class ** extends bloc.Bloc { *; }
-keep class ** extends bloc.BlocEvent { *; }
-keep class ** extends bloc.BlocState { *; }

# Tus blocs
-keep class com.example.myapp.bloc.** { *; }
```

---

### Usando Hive (database)

**Problema**: TypeAdapter no se encuentra, objetos no se serializan.

**Solución**:
```proguard
-keep class hive.** { *; }
-keep class ** extends hive.TypeAdapter { *; }

# Tus adapters generados
-keep class **.g.dart { *; }

# Tus modelos
-keep class com.example.myapp.models.** { *; }
```

---

### Usando Dio (HTTP client)

**Problema**: Interceptors no funcionan, requests fallan.

**Solución**:
```proguard
-keep class dio.** { *; }
-keep class ** extends dio.Interceptor { *; }

# Retrofit-style (si usas retrofit_dio)
-keep class retrofit.** { *; }
-keepclassmembers class ** {
    @retrofit.http.** <methods>;
}
```

---

## 🐌 Performance Issues

### Build time aumenta más de 2x

**Causa**: R8 haciendo demasiadas optimizaciones.

**Solución**: Reducir passes de optimización en `proguard-rules.pro`:
```proguard
# En lugar de 5 passes
-optimizationpasses 5

# Usa 3 para builds más rápidos
-optimizationpasses 3
```

---

### APK sigue siendo grande (>30 MB por ABI)

**Verificaciones**:

1. **¿R8 está realmente habilitado?**
   ```bash
   grep "minifyEnabled.*true" android/app/build.gradle*
   ```

2. **¿Usaste --split-per-abi?**
   ```bash
   ls -lh build/app/outputs/apk/release/
   # Deberías ver 3 APKs separados
   ```

3. **¿Hay assets grandes?**
   ```bash
   du -sh assets/*
   # Comprime imágenes, audio, etc.
   ```

4. **¿Hay dependencias innecesarias?**
   ```bash
   flutter pub deps | grep "^├── "
   # Elimina paquetes que no uses
   ```

---

### App inicia más lento después de ofuscación

**Causa probable**: NO es la ofuscación (es cosmética), es otra cosa.

**Verificar**:
1. ¿Aumentó el tamaño del código Dart?
2. ¿Agregaste lógica de inicialización?
3. ¿Hay más plugins cargándose?

**Profiling**:
```bash
flutter run --release --profile
# Usa DevTools para perfilar
```

---

## 🍎 Xcode/iOS Específicos

### Error: "Unable to rename temporary .pcm file" (Xcode 16.2)

**Síntoma**: Build de iOS falla con errores de ModuleCache.

**Causa**: Bug conocido de Xcode 16.2.

**Soluciones**:

1. **Opción A: Downgrade a Xcode 15.4**
   ```bash
   # Descargar de developer.apple.com
   # Instalar Xcode 15.4
   sudo xcode-select -s /Applications/Xcode-15.4.app
   ```

2. **Opción B: Usar CI/CD con Xcode 15.x**
   ```yaml
   # GitHub Actions
   - uses: maxim-lobanov/setup-xcode@v1
     with:
       xcode-version: '15.4'
   ```

3. **Opción C: Esperar Xcode 16.3** (fix esperado)

---

### Error: "unsupported preprocessor directive" en Release.xcconfig

**Síntoma**: Build de iOS falla con errores como:
```
Error (Xcode): unsupported preprocessor directive '============================================'
Error (Xcode): unsupported preprocessor directive 'SYMBOL'
Error (Xcode): unsupported preprocessor directive 'OPTIMIZATION'
```

**Causa**: Los archivos `.xcconfig` **NO soportan comentarios** con `#` (excepto para includes).

**Solución**: Remover TODOS los comentarios del archivo `Release.xcconfig`.

**❌ INCORRECTO** (con comentarios):
```xcconfig
#include "Generated.xcconfig"

# ============================================
# SYMBOL STRIPPING
# ============================================
DEPLOYMENT_POSTPROCESSING = YES
STRIP_INSTALLED_PRODUCT = YES
```

**✅ CORRECTO** (sin comentarios):
```xcconfig
#include "Generated.xcconfig"

DEPLOYMENT_POSTPROCESSING = YES
STRIP_INSTALLED_PRODUCT = YES
STRIP_STYLE = all
COPY_PHASE_STRIP = YES
SEPARATE_STRIP = YES

SWIFT_OPTIMIZATION_LEVEL = -O
GCC_OPTIMIZATION_LEVEL = fast
SWIFT_COMPILATION_MODE = wholemodule

DEAD_CODE_STRIPPING = YES

DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
ONLY_ACTIVE_ARCH = NO
```

**Referencia**: Usa el template correcto en `templates/Release.xcconfig.template`

**Estado**: ✅ Problema documentado y resuelto

---

### Error: "No such module 'Flutter'"

**Síntoma**: Build de iOS falla diciendo que no encuentra el módulo Flutter.

**Solución**:
```bash
cd ios
rm -rf Pods/ Podfile.lock
pod cache clean --all
pod install
cd ..
flutter clean
flutter build ios --release
```

---

### Warning: "Bitcode is deprecated"

**Síntoma**: Warning en build de iOS sobre Bitcode.

**Solución**: Deshabilitar Bitcode en Xcode:
1. Abrir `ios/Runner.xcworkspace`
2. Build Settings → Search "bitcode"
3. Set `ENABLE_BITCODE = NO`

O en `project.pbxproj`:
```
ENABLE_BITCODE = NO;
```

---

### Error: "Code signing failed"

**Síntoma**: Build de iOS falla en codesign.

**Solución para desarrollo**:
```bash
# Usar signing automático
flutter build ios --release --no-codesign
```

**Solución para producción**:
1. Configura provisioning profiles en Xcode
2. Verifica que el certificate esté instalado en Keychain

---

## 🤖 Gradle/Android Específicos

### Error: "Could not resolve all files for configuration"

**Síntoma**: Gradle no puede descargar dependencias.

**Solución**:
1. Verifica internet
2. Limpiar cache:
   ```bash
   cd android && ./gradlew clean --refresh-dependencies
   ```
3. Agregar repositorios en `android/build.gradle`:
   ```groovy
   allprojects {
       repositories {
           google()
           mavenCentral()
           jcenter() // Si es necesario (deprecado)
       }
   }
   ```

---

### Error: "Gradle version X is required. Current version is Y"

**Síntoma**: Versión de Gradle incompatible.

**Solución**: Actualizar en `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-all.zip
```

Luego:
```bash
cd android && ./gradlew wrapper --gradle-version=8.0
```

---

### Error: "Android Gradle plugin version X requires Java Y"

**Síntoma**: Versión de Java incompatible.

**Solución**:
1. Verificar Java instalado:
   ```bash
   java -version
   ```

2. Instalar Java 17 (recomendado para AGP 8.x):
   ```bash
   # macOS
   brew install openjdk@17
   export JAVA_HOME=$(/usr/libexec/java_home -v 17)
   ```

---

### MultiDex build falla

**Síntoma**: Build falla con "Cannot fit requested classes in a single dex file".

**Solución**: Ya deberías tener `multiDexEnabled = true`, pero si falla:

1. Agrega en `android/app/build.gradle.kts`:
   ```kotlin
   dependencies {
       implementation("androidx.multidex:multidex:2.0.1")
   }
   ```

2. En tu `MainActivity.kt`:
   ```kotlin
   import androidx.multidex.MultiDexApplication

   class MyApplication : MultiDexApplication() {
       // ...
   }
   ```

---

## 🔍 Des-ofuscación Avanzada

### Des-ofuscar crash de Firebase Crashlytics

**Paso 1: Descargar stack trace**
```bash
# Desde Firebase Console → Crashlytics
# O usando CLI:
firebase crashlytics:issues --app=YOUR_APP_ID
```

**Paso 2: Des-ofuscar**
```bash
./scripts/deobfuscate.sh -p android -s firebase_crash.txt
```

**Paso 3: Subir mapping a Firebase** (para auto-desobfuscar)
```bash
firebase crashlytics:symbols:upload \
  --app=YOUR_APP_ID \
  build/app/outputs/mapping/release
```

---

### Des-ofuscar crash de Google Play Console

**Paso 1: Descargar ANR/Crash**
1. Play Console → App Quality → Android vitals → Crashes
2. Click en crash → Download
3. Copiar stack trace a archivo

**Paso 2: Des-ofuscar**
```bash
./scripts/deobfuscate.sh -p android -s play_console_crash.txt -m releases/v1.0.0/mapping.txt
```

---

### Des-ofuscar crash de iOS (dSYM)

**Paso 1: Obtener crash log**
```bash
# Desde Xcode → Devices → View Device Logs
# O desde App Store Connect → TestFlight → Crashes
```

**Paso 2: Symbolicate**
```bash
# Opción A: Usando script
./scripts/deobfuscate.sh -p ios -s ios_crash.txt -y releases/v1.0.0/symbols/ios

# Opción B: Usando symbolicatecrash
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
symbolicatecrash crash.crash Runner.app.dSYM > crash_symbolicated.txt
```

---

### Matching exacto de versión

**Problema**: Tienes el stack trace pero no sabes qué mapping.txt usar.

**Solución**: Buscar por build number en Firebase/Crashlytics o App Store Connect.

**Organización recomendada**:
```
releases/
├── v1.0.0-build-123/
│   ├── mapping.txt
│   ├── symbols/
│   └── metadata.json
├── v1.0.1-build-124/
│   ├── mapping.txt
│   ├── symbols/
│   └── metadata.json
```

**metadata.json**:
```json
{
  "version": "1.0.0",
  "buildNumber": 123,
  "flutterVersion": "3.35.5",
  "buildDate": "2025-10-11",
  "gitCommit": "abc123"
}
```

---

## 📚 Recursos Adicionales

### Herramientas de Debugging

- **Android Studio APK Analyzer**: Analizar APKs
  ```bash
  # Desde Android Studio
  Build → Analyze APK → Seleccionar APK
  ```

- **apktool**: Decompiler APKs
  ```bash
  apktool d app-release.apk -o output/
  ```

- **dex2jar + JD-GUI**: Ver código Java decompilado
  ```bash
  d2j-dex2jar.sh app-release.apk
  # Abrir .jar con JD-GUI
  ```

### Verificación de Ofuscación

```bash
# Android: Verificar clases ofuscadas
unzip -q app-release.apk -d /tmp/apk
strings /tmp/apk/classes.dex | grep "com/example/myapp"
# No deberían aparecer tus clases

# iOS: Verificar símbolos stripped
nm -a Runner.app/Runner | grep "MyClass"
# No deberían aparecer tus clases
```

---

## 🆘 Cuando Todo Falla

### Reset completo

```bash
# Flutter
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Android
cd android
./gradlew clean
rm -rf .gradle/ build/
cd ..

# iOS
cd ios
rm -rf Pods/ Podfile.lock
pod cache clean --all
rm -rf build/ DerivedData/
cd ..

# Reinstalar dependencias
flutter pub get
cd ios && pod install && cd ..

# Build desde cero
flutter build apk --release --obfuscate --split-debug-info=build/symbols/android
```

---

### Deshabilitar temporalmente R8 (para debugging)

En `android/app/build.gradle.kts`:
```kotlin
buildTypes {
    release {
        // Comentar temporalmente
        // isMinifyEnabled = true
        // isShrinkResources = true
        isMinifyEnabled = false
        isShrinkResources = false
    }
}
```

**⚠️ IMPORTANTE**: NO commitees esto, solo para debugging local.

---

### Buscar ayuda

1. **Flutter GitHub Issues**: https://github.com/flutter/flutter/issues
2. **Stack Overflow**: Tag `flutter` + `obfuscation`
3. **ProGuard GitHub**: https://github.com/Guardsquare/proguard
4. **R8 Issues**: https://issuetracker.google.com/issues?q=componentid:192709%2B

---

**Última actualización**: 2025-10-11
**Versión**: 1.0.0
