# 🔒 Guía de Migración - Ofuscación y Minificación Flutter

> **Aplica ofuscación y minificación a cualquier proyecto Flutter en menos de 10 minutos**

---

## 📋 Índice

1. [Requisitos Previos](#requisitos-previos)
2. [Método Automático (Recomendado)](#método-automático-recomendado)
3. [Método Manual](#método-manual)
4. [Validación](#validación)
5. [Troubleshooting](#troubleshooting)
6. [FAQ](#faq)

---

## 🎯 Requisitos Previos

### Software Necesario

| Herramienta | Versión Mínima | Verificación |
|-------------|----------------|--------------|
| Flutter SDK | ≥3.9.2 | `flutter --version` |
| Android Studio | Latest | - |
| Xcode (macOS) | ≥15.0 | `xcodebuild -version` |
| Git | Any | `git --version` |

### Conocimientos Necesarios

- ✅ Comandos básicos de terminal
- ✅ Estructura de proyectos Flutter
- ✅ Git básico (commit, branch)

---

## 🚀 Método Automático (Recomendado)

### Opción A: Usando el Script de Setup

1. **Copia los archivos necesarios** al proyecto destino:

   ```bash
   # Desde este proyecto (template)
   cp -r scripts/ /path/to/tu-proyecto/

   cd /path/to/tu-proyecto
   ```

2. **Ejecuta el script de setup**:

   ```bash
   ./scripts/setup_obfuscation.sh
   ```

3. **Sigue las instrucciones interactivas**:
   - Selecciona plataformas (Android/iOS/Ambas)
   - El script configurará automáticamente tu proyecto
   - Revisa los archivos generados

4. **Personaliza la configuración**:
   ```bash
   # Edita proguard-rules.pro
   nano android/app/proguard-rules.pro

   # Reemplaza 'com.example.app' con tu applicationId
   # Agrega reglas para tus modelos específicos
   ```

5. **Valida la configuración**:
   ```bash
   ./scripts/build_release_obfuscated.sh
   ```

**Tiempo estimado**: 5 minutos

---

### Opción B: Clonar como Template

Si quieres usar este proyecto como base para nuevos proyectos:

1. **Crea un nuevo repositorio desde el template**:
   ```bash
   # En GitHub: "Use this template"
   # O clona y elimina el historial git:
   git clone <este-repo> mi-nuevo-proyecto
   cd mi-nuevo-proyecto
   rm -rf .git
   git init
   ```

2. **Adapta a tu proyecto**:
   - Renombra paquetes en `android/` e `ios/`
   - Actualiza `pubspec.yaml`
   - Modifica `proguard-rules.pro` con tu applicationId

**Tiempo estimado**: 15 minutos

---

## 🔧 Método Manual

Si prefieres configurar todo manualmente o entender cada paso:

### Paso 1: Configuración Android (R8 + ProGuard)

#### 1.1 Modificar `android/app/build.gradle.kts` (o `.gradle`)

**Para Kotlin DSL** (`build.gradle.kts`):

```kotlin
android {
    defaultConfig {
        // ...
        multiDexEnabled = true  // ← AGREGAR
    }

    buildTypes {
        release {
            // ← AGREGAR ESTAS LÍNEAS
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
```

**Para Groovy DSL** (`build.gradle`):

```groovy
android {
    defaultConfig {
        // ...
        multiDexEnabled true  // ← AGREGAR
    }

    buildTypes {
        release {
            // ← AGREGAR ESTAS LÍNEAS
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'

            signingConfig signingConfigs.debug
        }
    }
}
```

#### 1.2 Crear `android/app/proguard-rules.pro`

Copia el contenido desde `android/app/proguard-rules.pro` de este proyecto o usa el template mínimo:

```proguard
# Flutter Core
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Tu MainActivity (REEMPLAZA com.example.app)
-keep class com.TU_PACKAGE.MainActivity { *; }

# JNI
-keepclasseswithmembernames class * {
    native <methods>;
}

# Reflection attributes
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# AndroidX
-keep class ** extends androidx.lifecycle.ViewModel { *; }
-keep class ** extends androidx.lifecycle.AndroidViewModel { *; }

# Google Play Core (si Flutter lo usa)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
```

**⚠️ IMPORTANTE**: Reemplaza `com.example.app` con tu `applicationId` real.

---

### Paso 2: Configuración iOS (Symbol Stripping)

#### 2.1 Opción A: Usando Xcode (Más fácil)

1. Abre `ios/Runner.xcworkspace` en Xcode
2. Selecciona el target "Runner"
3. Ve a "Build Settings"
4. Busca y configura (para **Release** y **Profile**):

   | Setting | Valor |
   |---------|-------|
   | Dead Code Stripping | **YES** |
   | Strip Debug Symbols During Copy | **YES** |
   | Strip Style | **Non-Global Symbols** |
   | Strip Swift Symbols | **YES** |
   | Symbols Hidden by Default | **YES** |
   | Deployment Postprocessing | **YES** |

#### 2.2 Opción B: Editar project.pbxproj manualmente

1. Abre `ios/Runner.xcodeproj/project.pbxproj`
2. Busca las secciones que contienen `/* Release */` y `/* Profile */`
3. Agrega estas configuraciones en ambas:

```
DEAD_CODE_STRIPPING = YES;
DEPLOYMENT_POSTPROCESSING = YES;
STRIP_INSTALLED_PRODUCT = YES;
STRIP_STYLE = "non-global";
STRIP_SWIFT_SYMBOLS = YES;
SYMBOLS_HIDDEN_BY_DEFAULT = YES;
```

---

### Paso 3: Copiar Scripts de Automatización

```bash
# Copiar scripts desde este proyecto
cp scripts/build_release_obfuscated.sh tu-proyecto/scripts/
cp scripts/deobfuscate.sh tu-proyecto/scripts/

# Hacerlos ejecutables
chmod +x tu-proyecto/scripts/*.sh
```

---

### Paso 4: Actualizar .gitignore

Agrega al `.gitignore` de tu proyecto:

```gitignore
# Obfuscation artifacts
build/app/outputs/mapping/
build/app/outputs/symbols/
build/symbols/
*.backup
temp/
```

---

## ✅ Validación

### 1. Verificar Configuración

```bash
# Android: Verificar que R8 está habilitado
grep "minifyEnabled" android/app/build.gradle*

# iOS: Verificar symbol stripping
grep "STRIP_INSTALLED_PRODUCT" ios/Runner.xcodeproj/project.pbxproj
```

### 2. Build de Prueba

```bash
# Ejecutar build con ofuscación
./scripts/build_release_obfuscated.sh
```

**Resultados esperados**:
- ✅ Build exitoso en ~30 segundos
- ✅ APKs generados (13-17 MB cada uno)
- ✅ `mapping.txt` generado (2-5 MB)
- ✅ Símbolos Flutter generados (3 archivos)

### 3. Verificar Ofuscación

```bash
# Descomprimir APK
unzip -q build/app/outputs/apk/release/app-arm64-v8a-release.apk -d /tmp/apk_check

# Buscar nombres de clases (no deberían aparecer)
strings /tmp/apk_check/lib/arm64-v8a/libapp.so | grep "TuClasePrincipal"

# Limpiar
rm -rf /tmp/apk_check
```

**Resultado esperado**: No debería encontrar nombres de tus clases.

---

## 🔍 Troubleshooting

### Problema 1: Build falla con R8

**Error**: `Missing class X`, `Warning: can't find referenced class`

**Solución**:
1. Agrega reglas en `proguard-rules.pro`:
   ```proguard
   -dontwarn nombre.del.paquete.**
   -keep class nombre.del.paquete.** { *; }
   ```

2. Identifica la clase faltante en el error
3. Agrega regla específica o preserva el paquete completo

### Problema 2: App crashea después de ofuscación

**Causa**: R8 eliminó código que se usa via reflection (JSON, etc.)

**Solución**:
1. Identifica las clases del crash en Firebase/logs
2. Des-ofusca el stack trace:
   ```bash
   ./scripts/deobfuscate.sh -p android -s crash.txt
   ```
3. Agrega reglas ProGuard para esas clases:
   ```proguard
   -keep class com.tuapp.models.** { *; }
   ```

### Problema 3: APK sigue siendo grande

**Verificación**:
```bash
# ¿R8 está realmente habilitado?
./gradlew :app:assembleRelease --info | grep "minification"
```

**Posibles causas**:
- R8 no habilitado correctamente
- No estás usando `--split-per-abi`
- Assets grandes en `assets/`

**Solución**:
- Verifica `isMinifyEnabled = true` en release
- Usa `flutter build apk --split-per-abi`
- Revisa y comprime assets

### Problema 4: Xcode build falla (iOS)

**Error**: ModuleCache compilation error

**Causa**: Xcode 16.2 tiene un bug conocido

**Solución**:
1. Downgrade a Xcode 15.4
2. O ejecuta en CI/CD con Xcode 15.x
3. O espera Xcode 16.3

---

## 📊 Métricas Esperadas

### Reducción de Tamaño

| Plataforma | Baseline | Con Ofuscación | Reducción |
|------------|----------|----------------|-----------|
| Android (arm64) | ~40-50 MB | ~15-20 MB | **60-65%** |
| Android (armv7) | ~35-45 MB | ~12-18 MB | **65-70%** |
| iOS (arm64) | ~25-30 MB | ~18-22 MB | **20-30%** |

### Tiempo de Build

| Configuración | Tiempo |
|---------------|--------|
| Sin ofuscación | ~20 segundos |
| Con ofuscación | ~30 segundos |
| Overhead | **+50%** (aceptable) |

---

## 🎓 FAQ

### ¿Afecta el performance de la app?

**No**. La ofuscación es en build-time. El código ejecutable es el mismo, solo con nombres diferentes.

### ¿Puedo des-ofuscar crashes de producción?

**Sí**, usando el `mapping.txt`:
```bash
./scripts/deobfuscate.sh -p android -s crash_log.txt
```

### ¿Necesito hacer esto para cada release?

**Sí**, y debes **archivar** los archivos de mapping de cada versión:
```bash
cp build/app/outputs/mapping/release/mapping.txt releases/v1.2.3/
```

### ¿Funciona con Flutter Web?

**No directamente**. Flutter Web usa JavaScript minificado automáticamente. Para ofuscación adicional, necesitas herramientas específicas de JS.

### ¿Es reversible?

La ofuscación NO es reversible sin los archivos de mapping. Por eso es crítico **respaldar** `mapping.txt` y los símbolos Flutter.

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [Flutter Code Obfuscation](https://docs.flutter.dev/deployment/obfuscate)
- [Android R8 Documentation](https://developer.android.com/studio/build/shrink-code)
- [ProGuard Manual](https://www.guardsquare.com/manual/home)

### Documentación de Este Proyecto

- `docs/01_SRS_MINIFICACION_OFUSCACION.md` - Especificación completa
- `docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md` - Guía técnica detallada
- `docs/05_OPM_PROCEDIMIENTOS_OPERACIONALES.md` - Procedimientos operacionales
- `METRICAS_IMPLEMENTACION.md` - Métricas y resultados

---

## ✅ Checklist de Migración

Usa este checklist para asegurarte de que todo está configurado:

- [ ] R8 habilitado en `build.gradle.kts`
- [ ] `proguard-rules.pro` creado y personalizado
- [ ] Symbol stripping configurado en iOS
- [ ] Scripts copiados y ejecutables
- [ ] `.gitignore` actualizado
- [ ] Build de prueba exitoso
- [ ] Ofuscación verificada en binario
- [ ] `mapping.txt` generado correctamente
- [ ] Símbolos Flutter generados
- [ ] Script de des-ofuscación probado
- [ ] Documentación leída

---

## 🚀 Próximos Pasos

Después de migrar:

1. **Testing exhaustivo**: Prueba todas las funcionalidades
2. **CI/CD**: Integra los scripts en tu pipeline
3. **Monitoring**: Configura Firebase Crashlytics con des-ofuscación
4. **Releases**: Archiva mapping files de cada versión

---

**¿Necesitas ayuda?** Revisa `docs/05_OPM_PROCEDIMIENTOS_OPERACIONALES.md` para troubleshooting detallado.

---

**Última actualización**: 2025-10-11
**Versión**: 1.0.0
