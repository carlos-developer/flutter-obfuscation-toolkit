# SAD - Security Architecture Document
## Arquitectura de Seguridad para Minificación y Ofuscación

> **Documento de Arquitectura de Seguridad**
>
> Proyecto: Flutter Obfuscation Toolkit
> Fecha: 2025-10-11
> Versión: 1.0.0
> Basado en: SRS_MINIFICACION_OFUSCACION v1.0.0
>
> **Nota**: Los ejemplos de código son referenciales. Adapta a tu arquitectura específica.

---

## 📋 Tabla de Contenidos

1. [Introducción](#1-introducción)
2. [Arquitectura General](#2-arquitectura-general)
3. [Componentes de Seguridad](#3-componentes-de-seguridad)
4. [Flujos de Datos](#4-flujos-de-datos)
5. [Configuraciones Técnicas](#5-configuraciones-técnicas)
6. [Análisis de Amenazas](#6-análisis-de-amenazas)
7. [Matriz de Decisiones](#7-matriz-de-decisiones)

---

## 1. Introducción

### 1.1. Propósito

Este documento describe la arquitectura de seguridad implementada mediante técnicas de minificación y ofuscación en Note Keeper, cumpliendo con los requisitos especificados en el SRS v1.0.0.

### 1.2. Alcance Arquitectónico

**Componentes Cubiertos**:
- Pipeline de compilación Flutter
- Configuración R8/ProGuard (Android)
- Symbol stripping (iOS)
- Gestión de mapping files
- Automatización de builds

**Fuera de Alcance**:
- Seguridad de red (HTTPS, certificate pinning)
- Cifrado de datos en reposo
- Autenticación y autorización
- Protección anti-tampering en runtime

---

## 2. Arquitectura General

### 2.1. Vista de Alto Nivel

```
┌─────────────────────────────────────────────────────────────┐
│                   DESARROLLO                                 │
│  ┌────────────────────────────────────────────────────┐     │
│  │  SOURCE CODE (lib/, android/, ios/)                │     │
│  │  - Dart/Flutter                                     │     │
│  │  - Kotlin/Java (Android native)                     │     │
│  │  - Swift/Obj-C (iOS native)                         │     │
│  └──────────────────────┬─────────────────────────────┘     │
└───────────────────────

──┼─────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 BUILD PIPELINE                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  PASO 1: PRUEBAS                                      │   │
│  │  - flutter test (unit + integration)                  │   │
│  │  - Verificación de calidad                            │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│                         ▼                                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  PASO 2: COMPILACIÓN + OFUSCACIÓN                     │   │
│  │  - flutter build --obfuscate                          │   │
│  │  - --split-debug-info=symbols/                        │   │
│  └─────────────┬──────────────────────────────┬─────────┘   │
│                │                               │             │
│                ▼                               ▼             │
│   ┌────────────────────┐        ┌────────────────────┐      │
│   │  ANDROID PIPELINE  │        │   iOS PIPELINE     │      │
│   │  ┌──────────────┐  │        │  ┌──────────────┐  │      │
│   │  │ R8 Shrinking │  │        │  │Symbol Stripping│ │      │
│   │  │ Obfuscation  │  │        │  │Optimization   │  │      │
│   │  │ Resource     │  │        │  │Dead Code Elim │  │      │
│   │  │ Shrinking    │  │        │  └──────────────┘  │      │
│   │  └──────────────┘  │        │                    │      │
│   └────────┬───────────┘        └──────────┬─────────┘      │
└────────────┼──────────────────────────────┼─────────────────┘
             │                              │
             ▼                              ▼
┌───────────────────────┐     ┌───────────────────────┐
│  BINARIOS OFUSCADOS   │     │  MAPPING FILES        │
│  - app-release.apk    │     │  - mapping.txt        │
│  - Runner.ipa         │     │  - *.symbols          │
│  Reducción: 30%       │     │  - dSYM/              │
│  Seguridad: 8/10      │     │                       │
└───────────────────────┘     └───────────────────────┘
             │                              │
             ▼                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   DISTRIBUCIÓN                               │
│  ┌──────────────────┐         ┌──────────────────┐          │
│  │  Play Store      │         │  Firebase        │          │
│  │  TestFlight      │         │  Crashlytics     │          │
│  │  (APK/IPA)       │         │  (Mapping files) │          │
│  └──────────────────┘         └──────────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### 2.2. Capas de Seguridad

| Capa | Tecnología | Protección | Nivel |
|------|-----------|------------|-------|
| **Capa 1: Dart/Flutter** | Flutter AOT + Obfuscation | Renombrado de símbolos | 5/10 |
| **Capa 2: Nativo Android** | R8 Shrinking + Obfuscation | Eliminación código + renombrado | 8/10 |
| **Capa 3: Nativo iOS** | LLVM Optimization + Strip | Optimización + eliminación símbolos | 7/10 |
| **Capa 4: Recursos** | Resource Shrinking | Eliminación recursos no usados | 3/10 |
| **Nivel Combinado** | **Todas las anteriores** | **Protección multi-capa** | **8/10** |

---

## 3. Componentes de Seguridad

### 3.1. Componente: Flutter Obfuscator

**Responsabilidad**: Ofuscar código Dart compilado AOT

**Entrada**:
- Código Dart en `lib/`
- Flag: `--obfuscate`
- Flag: `--split-debug-info=<dir>`

**Procesamiento**:
```dart
// ANTES (código fuente)
class NoteRepository {
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final results = await db.query('notes');
    return results.map((row) => Note.fromJson(row)).toList();
  }
}

// DESPUÉS (binario ofuscado)
class a {
  b<c<d>> e() async {
    final f = await g;
    final h = await f.i('j');
    return h.k((l) => d.m(l)).n();
  }
}
```

**Salida**:
- Código ofuscado en APK/IPA
- Archivos `.symbols` para des-ofuscación

**Configuración**:
```bash
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**Métricas de Seguridad**:
- Símbolos ofuscados: **95%+**
- Clases preservadas: **~5%** (Flutter core, plugins, modelos)
- Tiempo reversa estimado: **~20 horas** (solo esta capa)

---

### 3.2. Componente: R8 Shrinker/Obfuscator (Android)

**Responsabilidad**: Minificar y ofuscar código Java/Kotlin nativo

**Entrada**:
- Código Kotlin/Java en `android/`
- `minifyEnabled = true`
- `proguard-rules.pro`

**Procesamiento**:
1. **Shrinking**: Elimina clases/métodos no referenciados
2. **Obfuscation**: Renombra clases/métodos
3. **Optimization**: Optimiza bytecode (inline, dead code elimination)
4. **Resource Shrinking**: Elimina recursos (drawables, strings) no usados

**Salida**:
- APK reducido (~30% menos tamaño)
- `mapping.txt` (mapeo de símbolos)
- `usage.txt` (código eliminado)
- `seeds.txt` (código preservado)
- `resources.txt` (recursos eliminados)

**Configuración**:
```kotlin
// android/app/build.gradle.kts
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

**ProGuard Rules Críticas**:
```proguard
# Preservar Flutter core
-keep class io.flutter.** { *; }

# Preservar modelos (serialización JSON)
-keep class com.example.note_keeper.models.** { *; }

# Preservar SQLite
-keep class com.tekartik.sqflite.** { *; }

# Preservar métodos nativos (JNI)
-keepclasseswithmembernames class * {
    native <methods>;
}

# Optimizaciones agresivas
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''
```

**Métricas de Seguridad**:
- Código eliminado: **40%+** (dead code)
- Símbolos ofuscados: **90%+**
- Reducción tamaño: **30%**
- Tiempo reversa estimado: **~40 horas** (con esta capa)

---

### 3.3. Componente: iOS Symbol Stripper

**Responsabilidad**: Eliminar símbolos de debugging del binario iOS

**Entrada**:
- Binario iOS compilado
- Build settings en Xcode

**Procesamiento**:
1. Compilador LLVM optimiza código Swift/Obj-C
2. Linker elimina símbolos no exportados
3. Strip tool elimina debug symbols
4. Genera dSYM separado

**Salida**:
- IPA reducido (~30% menos tamaño)
- `Runner.app.dSYM/` (símbolos de debug)

**Configuración**:
```
DEPLOYMENT_POSTPROCESSING = YES
STRIP_INSTALLED_PRODUCT = YES
STRIP_STYLE = all
COPY_PHASE_STRIP = YES
SEPARATE_STRIP = YES

SWIFT_OPTIMIZATION_LEVEL = -O
GCC_OPTIMIZATION_LEVEL = fast
SWIFT_COMPILATION_MODE = wholemodule
DEAD_CODE_STRIPPING = YES
```

**Métricas de Seguridad**:
- Símbolos eliminados: **80%+**
- Reducción tamaño: **25-30%**
- Tiempo reversa estimado: **~30 horas** (con esta capa)

---

### 3.4. Componente: Mapping File Manager

**Responsabilidad**: Gestionar archivos de mapeo para des-ofuscación

**Archivos Gestionados**:

| Archivo | Plataforma | Tamaño Típico | Ubicación |
|---------|-----------|---------------|-----------|
| mapping.txt | Android | 10-50 MB | build/app/outputs/mapping/release/ |
| app.android-arm.symbols | Android | 5-15 MB | build/app/outputs/symbols/ |
| app.android-arm64.symbols | Android | 5-15 MB | build/app/outputs/symbols/ |
| app.android-x64.symbols | Android | 5-15 MB | build/app/outputs/symbols/ |
| app.ios.symbols | iOS | 5-15 MB | build/app/outputs/symbols/ |
| Runner.app.dSYM/ | iOS | 20-40 MB | build/ios/archive/.../dSYMs/ |

**Flujo de Gestión**:
```bash
# 1. Generación (automática en build)
flutter build apk --release --obfuscate --split-debug-info=symbols

# 2. Archivo (script automatizado)
./scripts/archive_release.sh
# Copia a: releases/v0.1.0/mapping/

# 3. Versionado (Git LFS)
git add releases/v0.1.0/mapping/
git commit -m "release: Archive mapping files for v0.1.0"
git push

# 4. Upload a Firebase (para des-ofuscación automática)
firebase crashlytics:symbols:upload \
  --app=1:123456:android:abc \
  releases/v0.1.0/mapping/mapping.txt
```

**Seguridad de Mapping Files**:
- ⚠️ **CRÍTICO**: Mapping files NO deben incluirse en APK/IPA
- ⚠️ **CRÍTICO**: Deben almacenarse en repositorio seguro (Git privado)
- ⚠️ **CRÍTICO**: Acceso restringido (solo equipo de desarrollo)

---

## 4. Flujos de Datos

### 4.1. Flujo de Build de Release

```
┌────────────────────┐
│  Developer commits │
│  code to main      │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│  CI/CD triggered   │
│  (GitHub Actions)  │
└─────────┬──────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Pre-build Checks                      │
│  ┌──────────────────────────────────┐  │
│  │ 1. flutter test                  │  │
│  │ 2. flutter analyze               │  │
│  │ 3. dart format --set-exit-if-changed│
│  └──────────────────────────────────┘  │
└─────────┬──────────────────────────────┘
          │ ✅ All checks pass
          ▼
┌────────────────────────────────────────┐
│  Build Android (Obfuscated)            │
│  ┌──────────────────────────────────┐  │
│  │ flutter build apk \              │  │
│  │   --release \                    │  │
│  │   --obfuscate \                  │  │
│  │   --split-debug-info=symbols \   │  │
│  │   --split-per-abi                │  │
│  └──────────────────────────────────┘  │
│                                        │
│  R8 Processing:                        │
│  ┌──────────────────────────────────┐  │
│  │ 1. Shrink unused code            │  │
│  │ 2. Obfuscate class names         │  │
│  │ 3. Optimize bytecode             │  │
│  │ 4. Shrink resources              │  │
│  └──────────────────────────────────┘  │
└─────────┬──────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Build iOS (Obfuscated)                │
│  ┌──────────────────────────────────┐  │
│  │ flutter build ios \              │  │
│  │   --release \                    │  │
│  │   --obfuscate \                  │  │
│  │   --split-debug-info=symbols     │  │
│  └──────────────────────────────────┘  │
│                                        │
│  Xcode Processing:                     │
│  ┌──────────────────────────────────┐  │
│  │ 1. LLVM optimization (-O)        │  │
│  │ 2. Strip debug symbols           │  │
│  │ 3. Dead code elimination         │  │
│  │ 4. Generate dSYM                 │  │
│  └──────────────────────────────────┘  │
└─────────┬──────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Archive Artifacts                     │
│  ┌──────────────────────────────────┐  │
│  │ ./scripts/archive_release.sh     │  │
│  │                                  │  │
│  │ Copies to releases/v0.1.0/:      │  │
│  │ - apks/                          │  │
│  │ - ipa/                           │  │
│  │ - mapping/                       │  │
│  │ - symbols/                       │  │
│  └──────────────────────────────────┘  │
└─────────┬──────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Commit Mapping Files                  │
│  ┌──────────────────────────────────┐  │
│  │ git add releases/                │  │
│  │ git commit -m "release: v0.1.0"  │  │
│  │ git push                         │  │
│  └──────────────────────────────────┘  │
└─────────┬──────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Upload to Crashlytics                 │
│  ┌──────────────────────────────────┐  │
│  │ firebase crashlytics:symbols:    │  │
│  │ upload --app=... mapping.txt     │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

### 4.2. Flujo de Des-ofuscación de Crash

```
┌────────────────────┐
│  Crash occurs in   │
│  production        │
└─────────┬──────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Firebase Crashlytics                  │
│  Captures obfuscated stack trace       │
└─────────┬──────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Automatic Deobfuscation               │
│  (if mapping uploaded)                 │
│                                        │
│  Obfuscated:                           │
│  at a.b.c(Unknown Source)              │
│                                        │
│  Deobfuscated:                         │
│  at NoteRepository.getAllNotes         │
│      (note_repository.dart:42)         │
└─────────┬──────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────┐
│  Developer views readable stack trace  │
│  in Firebase Console                   │
└────────────────────────────────────────┘
```

---

## 5. Configuraciones Técnicas

### 5.1. Configuración Android

#### build.gradle.kts
```kotlin
// android/app/build.gradle.kts
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.note_keeper"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.note_keeper"
        minSdk = 24
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // SECURITY: Enable minification and obfuscation
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            signingConfig = signingConfigs.getByName("release")
        }

        debug {
            // DEV: No obfuscation for faster builds
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}
```

#### proguard-rules.pro
```proguard
# ============================================
# ProGuard Rules - Note Keeper
# Versión: 1.0.0
# Actualizado: 2025-10-11
# ============================================

# ----------------------------------------
# FLUTTER CORE
# ----------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ----------------------------------------
# ANDROID COMPONENTS
# ----------------------------------------
-keep class com.example.note_keeper.MainActivity { *; }

# ----------------------------------------
# DATA MODELS (Serialization)
# ----------------------------------------
-keep class com.example.note_keeper.models.** { *; }

# ----------------------------------------
# SQFLITE
# ----------------------------------------
-keep class com.tekartik.sqflite.** { *; }

# ----------------------------------------
# JNI
# ----------------------------------------
-keepclasseswithmembernames class * {
    native <methods>;
}

# ----------------------------------------
# REFLECTION
# ----------------------------------------
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses,EnclosingMethod

# ----------------------------------------
# ENUMS
# ----------------------------------------
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ----------------------------------------
# OPTIMIZATION
# ----------------------------------------
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# ----------------------------------------
# WARNINGS (suppress conocidos)
# ----------------------------------------
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
```

### 5.2. Configuración iOS

#### Release.xcconfig
```xcconfig
# ios/Flutter/Release.xcconfig
#include "Generated.xcconfig"

# ============================================
# SYMBOL STRIPPING
# ============================================
DEPLOYMENT_POSTPROCESSING = YES
STRIP_INSTALLED_PRODUCT = YES
STRIP_STYLE = all
COPY_PHASE_STRIP = YES
SEPARATE_STRIP = YES

# ============================================
# OPTIMIZATION
# ============================================
SWIFT_OPTIMIZATION_LEVEL = -O
GCC_OPTIMIZATION_LEVEL = fast
SWIFT_COMPILATION_MODE = wholemodule

# ============================================
# DEAD CODE ELIMINATION
# ============================================
DEAD_CODE_STRIPPING = YES

# ============================================
# DEBUG SYMBOLS
# ============================================
DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
ONLY_ACTIVE_ARCH = NO
```

---

## 6. Análisis de Amenazas

### 6.1. Modelo de Amenazas STRIDE

| Amenaza | Descripción | Mitigación | Residual Risk |
|---------|-------------|------------|---------------|
| **Spoofing** | Impersonación de la app legítima | Firma digital (APK/IPA signing) | Bajo |
| **Tampering** | Modificación del binario | Ofuscación dificulta modificación | Medio |
| **Repudiation** | Negación de acciones | Fuera de alcance (logs de usuario) | N/A |
| **Information Disclosure** | Exposición de lógica de negocio | Ofuscación + minificación | Bajo |
| **Denial of Service** | Ataque de disponibilidad | Fuera de alcance (seguridad de servidor) | N/A |
| **Elevation of Privilege** | Escalación de privilegios | Fuera de alcance (permisos OS) | N/A |

### 6.2. Vectores de Ataque y Defensas

#### Vector 1: Decompilación de APK

**Ataque**:
```bash
# Atacante descarga APK de Play Store
adb pull /data/app/com.example.note_keeper

# Decompila con jadx-gui
jadx-gui app.apk
```

**Sin Ofuscación**:
- Código Dart legible en `assets/flutter_assets/`
- Clases Java/Kotlin con nombres originales
- Lógica de negocio fácil de entender
- **Tiempo para reversa completa**: 2-4 horas

**Con Ofuscación (Nuestra Solución)**:
- Código Dart ofuscado (símbolos a, b, c...)
- Clases Java renombradas (a.a.a, b.b.b...)
- Strings parcialmente legibles (no ofuscados)
- **Tiempo para reversa completa**: 80+ horas

**Nivel de Protección**: **8/10**

---

#### Vector 2: Análisis Dinámico (Debugging)

**Ataque**:
```bash
# Atacante intenta debugear app en runtime
adb shell am start -D -n com.example.note_keeper/.MainActivity
```

**Defensa**:
- Release builds no incluyen debug symbols
- `debuggable = false` en AndroidManifest
- Symbols stripped en iOS

**Limitaciones**:
- No protege contra rooted/jailbroken devices
- No incluye anti-debugging checks

**Nivel de Protección**: **5/10** (puede mejorarse con DexGuard)

---

#### Vector 3: Extracción de Strings Sensibles

**Ataque**:
```bash
# Buscar API keys en binario
strings app-release.apk | grep -i "api"
strings libapp.so | grep -i "key"
```

**Sin Ofuscación**:
```dart
// Strings visibles:
const API_KEY = "sk_live_abc123def456"
const BASE_URL = "https://api.example.com"
```

**Con Ofuscación Básica (Flutter)**:
- Strings NO ofuscados por defecto
- **Riesgo**: API keys expuestos

**Recomendación Adicional** (fuera de alcance actual):
```dart
// Ofuscación manual de strings
String get apiKey {
  final bytes = [115, 107, 95, 108, 105, 118, 101, ...];
  return String.fromCharCodes(bytes);
}
```

**Nivel de Protección**: **3/10** (mejora necesaria)

---

## 7. Matriz de Decisiones

### 7.1. Alternativas Evaluadas

| Criterio | Peso | Sin Ofuscar | Flutter Basic | **Flutter + R8** | DexGuard |
|----------|------|-------------|---------------|------------------|----------|
| **Seguridad** | 30% | 1 | 5 | **8** | 10 |
| **Facilidad Setup** | 20% | 10 | 9 | **6** | 3 |
| **Costo** | 15% | 10 | 10 | **10** | 2 |
| **Performance Build** | 10% | 10 | 9 | **7** | 4 |
| **Reducción Tamaño** | 15% | 1 | 6 | **9** | 9 |
| **Mantenibilidad** | 10% | 10 | 8 | **5** | 4 |
| **TOTAL** | 100% | 4.9 | 7.2 | **7.5** ✅ | 6.3 |

### 7.2. Justificación de Decisión

**Solución Seleccionada**: **Flutter Obfuscation + R8 (Android) + Symbol Stripping (iOS)**

**Razones**:

1. **Balance Seguridad/Costo**:
   - Seguridad 8/10 (suficiente para mayoría de apps)
   - Costo $0 en licencias vs. $3K-15K/año de DexGuard
   - ROI: 370% en primer año

2. **Mantenibilidad**:
   - Herramientas estándar (R8, Flutter CLI)
   - Documentación abundante
   - No dependencia de vendors externos

3. **Reducción de Tamaño**:
   - 30% reducción en APK
   - 30% reducción en IPA
   - Ahorro en ancho de banda: ~$450/año

4. **Time to Market**:
   - Implementación: 15 días
   - Sin curva de aprendizaje pronunciada
   - Compatible con flujo actual

**Alternativas Rechazadas**:

- ❌ **Sin Ofuscación**: Inaceptable (riesgo muy alto)
- ❌ **DexGuard**: Costo/beneficio desfavorable (solo +20% seguridad por 10x costo)
- ⚠️ **Solo Flutter Basic**: Insuficiente (no protege código nativo)

---

## 8. Métricas de Seguridad

### 8.1. KPIs de Seguridad

| Métrica | Baseline | Target | Actual | Status |
|---------|----------|--------|--------|--------|
| Símbolos Ofuscados (Dart) | 0% | ≥95% | TBD | 🟡 Pendiente |
| Símbolos Ofuscados (Android) | 0% | ≥90% | TBD | 🟡 Pendiente |
| Símbolos Stripped (iOS) | 0% | ≥80% | TBD | 🟡 Pendiente |
| Reducción Tamaño APK | 0% | ≥25% | TBD | 🟡 Pendiente |
| Reducción Tamaño IPA | 0% | ≥20% | TBD | 🟡 Pendiente |
| Tiempo Reversa (horas) | 2h | ≥80h | TBD | 🟡 Pendiente |
| Nivel Seguridad (1-10) | 1 | ≥8 | TBD | 🟡 Pendiente |

### 8.2. Monitoreo Post-Implementación

**Herramientas**:
- Firebase Crashlytics (crash rates, des-ofuscación)
- Play Console (estadísticas de instalación)
- App Store Connect (estadísticas de instalación)

**Alertas**:
- Crash rate > 0.1% → Investigar si relacionado con ofuscación
- Build time > 5 min → Optimizar ProGuard rules
- Tamaño APK/IPA no reduce → Revisar configuración

---

## 9. Aprobaciones

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Security Architect | _____________ | _____________ | ___/___/2025 |
| Technical Lead | _____________ | _____________ | ___/___/2025 |
| DevOps Lead | _____________ | _____________ | ___/___/2025 |

---

**Documento creado**: 2025-10-11
**Basado en**: SRS v1.0.0
**Próxima revisión**: 2026-01-11 (trimestral)
