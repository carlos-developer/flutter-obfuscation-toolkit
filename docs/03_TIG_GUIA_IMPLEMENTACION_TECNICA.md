# TIG - Technical Implementation Guide
## Guía de Implementación Técnica - Minificación y Ofuscación

> **Guía de Implementación Técnica**
>
> Proyecto: Note Keeper - Seguridad de Código
> Fecha: 2025-10-11
> Versión: 1.0.0
> Basado en: SRS v1.0.0, SAD v1.0.0

---

## 📋 Tabla de Contenidos

1. [Introducción](#1-introducción)
2. [Fase 1: Setup Básico Flutter](#2-fase-1-setup-básico-flutter)
3. [Fase 2: Configuración Android R8](#3-fase-2-configuración-android-r8)
4. [Fase 3: Configuración iOS](#4-fase-3-configuración-ios)
5. [Fase 4: Scripts de Automatización](#5-fase-4-scripts-de-automatización)
6. [Fase 5: Testing y Validación](#6-fase-5-testing-y-validación)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Introducción

### 1.1. Objetivo de este Documento

Esta guía proporciona **instrucciones paso a paso** para implementar minificación y ofuscación en Note Keeper. Cada paso incluye comandos exactos, código completo y verificaciones.

### 1.2. Prerrequisitos

**Software Requerido**:
- [ ] Flutter SDK ≥3.9.2
- [ ] Dart SDK (incluido en Flutter)
- [ ] Android Studio + Android SDK
- [ ] Xcode ≥15 (solo para iOS builds)
- [ ] Git + Git LFS configurado

**Conocimientos Requeridos**:
- Desarrollo Flutter/Dart (intermedio)
- Git básico
- Terminal/Bash básico

**Tiempo Estimado Total**: 15 días (3 semanas)

### 1.3. Cronograma de Implementación

```
Semana 1: Setup y Configuración
├── Día 1-2: Fase 1 (Flutter obfuscation)
├── Día 3-6: Fase 2 (Android R8)
└── Día 7:   Fase 3 (iOS)

Semana 2: Testing y Refinamiento
├── Día 8-10: Fase 4 (Testing exhaustivo)
└── Día 11-12: Refinamiento de ProGuard rules

Semana 3: Automatización y Documentación
├── Día 13-14: Fase 5 (Scripts y CI/CD)
└── Día 15:    Validación final y sign-off
```

---

## 2. Fase 1: Setup Básico Flutter

### Duración: 2 días

### 2.1. Objetivo

Configurar ofuscación básica de Flutter y generar primer build ofuscado.

### 2.2. Paso 1.1: Verificar Versión de Flutter

```bash
# Verificar versión actual
flutter --version

# Expected output:
# Flutter 3.9.2 • channel stable
# Dart 3.x.x

# Si versión < 3.9.2, actualizar:
flutter upgrade
```

**Criterio de Éxito**: Flutter ≥3.9.2

---

### 2.3. Paso 1.2: Primer Build Ofuscado (Android)

```bash
# Limpiar builds anteriores
flutter clean

# Build con ofuscación
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# Tiempo estimado: 3-4 minutos
```

**Qué hace este comando**:
- `--release`: Build de producción (no debug)
- `--obfuscate`: Activa ofuscación de código Dart
- `--split-debug-info=<dir>`: Guarda símbolos en directorio separado

**Salida Esperada**:
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (15.2MB)

Símbolos generados en:
build/app/outputs/symbols/
  ├── app.android-arm.symbols
  ├── app.android-arm64.symbols
  └── app.android-x64.symbols
```

**Verificación**:
```bash
# Verificar que APK fue generado
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Verificar que símbolos fueron generados
ls -lh build/app/outputs/symbols/

# Expected: 3 archivos .symbols (uno por arquitectura)
```

**✅ Checkpoint 1.2**: APK generado exitosamente con símbolos separados

---

### 2.4. Paso 1.3: Instalar y Probar APK

```bash
# Conectar dispositivo Android (USB debugging habilitado)
adb devices
# Expected: dispositivo listado

# Instalar APK
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Abrir app
adb shell am start -n com.example.note_keeper/.MainActivity
```

**Pruebas Manuales**:
- [ ] App abre correctamente
- [ ] Lista de notas se carga
- [ ] Crear nota funciona
- [ ] Editar nota funciona
- [ ] Eliminar nota funciona
- [ ] Búsqueda funciona

**Si alguna funcionalidad falla**: La ofuscación básica puede haber roto algo. Continuar al troubleshooting (Sección 7).

**✅ Checkpoint 1.3**: App funciona correctamente con ofuscación básica

---

### 2.5. Paso 1.4: Verificar Ofuscación

```bash
# Extraer APK
mkdir -p temp/apk_extracted
unzip build/app/outputs/flutter-apk/app-release.apk -d temp/apk_extracted

# Buscar nombres de clases originales (NO deberían aparecer)
strings temp/apk_extracted/lib/arm64-v8a/libapp.so | grep "NoteRepository"

# Expected: Sin resultados (clase ofuscada)

# Buscar símbolos ofuscados (SÍ deberían aparecer)
strings temp/apk_extracted/lib/arm64-v8a/libapp.so | head -20

# Expected: Nombres cortos como "a", "b", "c", "aa", "ab"...
```

**Análisis**:
- Si ves "NoteRepository" → Ofuscación NO funcionó
- Si ves solo letras cortas → ✅ Ofuscación funcionó

**✅ Checkpoint 1.4**: Código está ofuscado

---

### 2.6. Paso 1.5: Medir Tamaño Baseline

```bash
# Build SIN ofuscación (para comparar)
flutter build apk --release
SIZE_BEFORE=$(du -b build/app/outputs/flutter-apk/app-release.apk | cut -f1)
echo "Tamaño sin ofuscación: $((SIZE_BEFORE / 1024 / 1024)) MB"

# Build CON ofuscación
flutter build apk --release --obfuscate --split-debug-info=symbols
SIZE_AFTER=$(du -b build/app/outputs/flutter-apk/app-release.apk | cut -f1)
echo "Tamaño con ofuscación: $((SIZE_AFTER / 1024 / 1024)) MB"

# Calcular reducción
REDUCTION=$((100 - (SIZE_AFTER * 100 / SIZE_BEFORE)))
echo "Reducción: ${REDUCTION}%"
```

**Resultado Esperado**:
```
Tamaño sin ofuscación: 15 MB
Tamaño con ofuscación: 13 MB
Reducción: 13%
```

**Nota**: Solo ~10-15% de reducción en esta fase. La reducción mayor vendrá con R8 (Fase 2).

**✅ Checkpoint 1.5**: Baseline de tamaño establecido

---

### 2.7. Resumen Fase 1

**Completado**:
- [x] Flutter obfuscation configurado
- [x] Primer build ofuscado exitoso
- [x] App funciona correctamente
- [x] Ofuscación verificada
- [x] Baseline de tamaño medido

**Entregables**:
- APK ofuscado funcional
- Símbolos de Flutter generados
- Métricas de tamaño documentadas

**Siguiente Fase**: Configurar R8 para Android

---

## 3. Fase 2: Configuración Android R8

### Duración: 4 días

### 3.1. Objetivo

Habilitar R8 shrinking/obfuscation y configurar ProGuard rules para preservar código crítico.

### 3.2. Paso 2.1: Modificar build.gradle.kts

**Archivo**: `android/app/build.gradle.kts`

**Cambios**:
```kotlin
android {
    // ... (configuración existente)

    defaultConfig {
        // ... (configuración existente)

        // AÑADIR: Habilitar multidex si no está
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // AÑADIR: Habilitar minificación y shrinking
            isMinifyEnabled = true
            isShrinkResources = true

            // AÑADIR: Configurar ProGuard rules
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Configuración existente de firma
            signingConfig = signingConfigs.getByName("debug")
        }

        debug {
            // NO cambiar debug (para desarrollo rápido)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}
```

**Verificar Cambios**:
```bash
# Ver diff de cambios
git diff android/app/build.gradle.kts
```

**✅ Checkpoint 2.1**: build.gradle.kts modificado

---

### 3.3. Paso 2.2: Crear ProGuard Rules Base

**Archivo**: `android/app/proguard-rules.pro` (crear nuevo)

```bash
# Crear archivo
touch android/app/proguard-rules.pro
```

**Contenido Inicial** (reglas mínimas):
```proguard
# ============================================
# ProGuard Rules - Note Keeper
# Versión: 1.0.0
# Fecha: 2025-10-11
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
# DATA MODELS (para serialización JSON)
# ----------------------------------------
-keep class com.example.note_keeper.models.** { *; }

# ----------------------------------------
# SQFLITE (base de datos)
# ----------------------------------------
-keep class com.tekartik.sqflite.** { *; }

# ----------------------------------------
# JNI (métodos nativos)
# ----------------------------------------
-keepclasseswithmembernames class * {
    native <methods>;
}

# ----------------------------------------
# REFLECTION (para serialización)
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
# PARCELABLE
# ----------------------------------------
-keep interface android.os.Parcelable
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# ----------------------------------------
# SERIALIZABLE
# ----------------------------------------
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ----------------------------------------
# OPTIMIZATION (agresivo)
# ----------------------------------------
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# ----------------------------------------
# WARNINGS (suprimir conocidos)
# ----------------------------------------
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
```

**Verificar Archivo Creado**:
```bash
ls -lh android/app/proguard-rules.pro
cat android/app/proguard-rules.pro | wc -l
# Expected: ~80 líneas
```

**✅ Checkpoint 2.2**: ProGuard rules base creado

---

### 3.4. Paso 2.3: Primer Build con R8

```bash
# Limpiar build anterior
flutter clean

# Build con R8 habilitado
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# Tiempo estimado: 4-5 minutos (R8 es más lento)
```

**Resultado Esperado**:

**Éxito**:
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (10.5MB)
```

**Error Común** (ClassNotFoundException):
```
FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:minifyReleaseWithR8'.
> Missing classes detected...
  com.example.note_keeper.models.Note is referenced but not found
```

**Si hay error**: Continuar a Paso 2.4 (refinamiento de rules)

---

### 3.5. Paso 2.4: Refinamiento Iterativo de ProGuard Rules

Este es el paso **MÁS IMPORTANTE** y puede requerir múltiples iteraciones.

**Proceso**:

1. **Build fallido → Identificar clase faltante**
2. **Añadir regla de preservación**
3. **Rebuild**
4. **Repetir hasta build exitoso**

**Ejemplo de Iteración**:

**Error**:
```
Missing class: com.example.note_keeper.models.Note
```

**Solución**:
```proguard
# Añadir a proguard-rules.pro
-keep class com.example.note_keeper.models.Note { *; }
```

**Rebuild**:
```bash
flutter build apk --release --obfuscate --split-debug-info=symbols
```

**Herramientas de Debug**:

```bash
# Ver qué clases se eliminaron
cat build/app/outputs/mapping/release/usage.txt | grep "REMOVED"

# Ver qué clases se preservaron
cat build/app/outputs/mapping/release/seeds.txt | grep "Note"

# Ver configuración final aplicada
cat build/app/outputs/mapping/release/configuration.txt
```

**Reglas Adicionales Comunes**:

Si usas **Provider**:
```proguard
-keep class ** extends androidx.lifecycle.ViewModel { *; }
-keep class ** extends androidx.lifecycle.AndroidViewModel { *; }
```

Si usas **JSON serialization**:
```proguard
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
```

**✅ Checkpoint 2.4**: Build con R8 exitoso (sin errores de compilación)

---

### 3.6. Paso 2.5: Instalar y Probar APK con R8

```bash
# Instalar APK ofuscado + minificado
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Monitorear logs para errores
adb logcat | grep -i "exception\|error"
```

**Testing Completo** (checklist de 15 puntos):

**Funcionalidad Core**:
- [ ] App abre sin crashes
- [ ] Lista de notas carga correctamente
- [ ] Crear nueva nota
- [ ] Editar nota existente
- [ ] Eliminar nota
- [ ] Buscar notas

**Casos Edge**:
- [ ] Rotar pantalla (landscape/portrait)
- [ ] Enviar app a background y traer de vuelta
- [ ] Reiniciar app
- [ ] Crear nota con texto muy largo (1000+ caracteres)
- [ ] Crear 100+ notas (performance)

**Persistencia**:
- [ ] Cerrar app y reabrir (datos persisten)
- [ ] Crear nota, cerrar, reabrir (nota aparece)

**Errores**:
- [ ] Buscar con texto vacío (no crash)
- [ ] Editar nota inexistente (manejo de error)

**Si hay crash**: Capturar stack trace y des-ofuscar (ver Sección 7).

**✅ Checkpoint 2.5**: App funciona 100% con R8 habilitado

---

### 3.7. Paso 2.6: Verificar Mapping Files

```bash
# Listar mapping files generados
ls -lh build/app/outputs/mapping/release/

# Expected output:
# mapping.txt       (10-50 MB)
# configuration.txt (100 KB)
# seeds.txt         (50 KB)
# usage.txt         (500 KB)
# resources.txt     (10 KB)
```

**Analizar mapping.txt**:
```bash
head -20 build/app/outputs/mapping/release/mapping.txt

# Expected format:
# com.example.note_keeper.MainActivity -> a.a.a:
# com.example.note_keeper.models.Note -> a.b.c:
#     int id -> a
#     java.lang.String title -> b
```

**Verificar Preservación**:
```bash
# Ver clases que NO fueron ofuscadas (seeds.txt)
cat build/app/outputs/mapping/release/seeds.txt | grep "note_keeper"

# Expected: MainActivity, models.Note, etc.
```

**✅ Checkpoint 2.6**: Mapping files generados correctamente

---

### 3.8. Paso 2.7: Medir Reducción de Tamaño

```bash
# Comparar tamaños
echo "=== COMPARACIÓN DE TAMAÑOS ==="
echo ""
echo "Sin R8 (solo Flutter obfuscation):"
du -h /tmp/app-release-before-r8.apk 2>/dev/null || echo "N/A"
echo ""
echo "Con R8 + Flutter obfuscation:"
du -h build/app/outputs/flutter-apk/app-release.apk
echo ""

# Calcular reducción
SIZE_BEFORE=15728640  # 15 MB (ajustar con tu valor real)
SIZE_AFTER=$(du -b build/app/outputs/flutter-apk/app-release.apk | cut -f1)
REDUCTION=$((100 - (SIZE_AFTER * 100 / SIZE_BEFORE)))
echo "Reducción total: ${REDUCTION}%"
```

**Resultado Esperado**:
```
Sin R8: 15.0 MB
Con R8: 10.5 MB
Reducción total: 30%
```

**Target**: ≥25% de reducción

**✅ Checkpoint 2.7**: Reducción de tamaño ≥25%

---

### 3.9. Resumen Fase 2

**Completado**:
- [x] build.gradle.kts modificado con minifyEnabled
- [x] ProGuard rules creado y refinado
- [x] Build exitoso con R8
- [x] App funciona 100% con R8
- [x] Mapping files generados
- [x] Reducción de tamaño ≥25%

**Entregables**:
- `android/app/build.gradle.kts` (modificado)
- `android/app/proguard-rules.pro` (nuevo)
- APK reducido en 30%
- mapping.txt para des-ofuscación

**Métricas Logradas**:
- APK: 15 MB → 10.5 MB (30% reducción) ✅
- Seguridad: 5/10 → 8/10 ✅
- Funcionalidad: 100% preservada ✅

**Siguiente Fase**: Configurar iOS

---

## 4. Fase 3: Configuración iOS

### Duración: 1 día

### 4.1. Objetivo

Aplicar symbol stripping y optimizaciones en iOS para reducir tamaño de IPA.

**Nota**: Esta fase requiere macOS + Xcode.

### 4.2. Paso 3.1: Abrir Proyecto en Xcode

```bash
# Abrir workspace de iOS
open ios/Runner.xcworkspace
```

**Verificar** que Xcode abre correctamente sin errores.

---

### 4.3. Paso 3.2: Configurar Build Settings

**En Xcode**:

1. Seleccionar **Runner** (target azul en panel izquierdo)
2. Click en **Build Settings** (pestaña superior)
3. Buscar configuraciones y cambiar:

**Deployment**:
```
DEPLOYMENT_POSTPROCESSING = YES
```

**Code Generation**:
```
STRIP_INSTALLED_PRODUCT = YES
STRIP_STYLE = all
COPY_PHASE_STRIP = YES
SEPARATE_STRIP = YES
```

**Optimization Level**:
```
SWIFT_OPTIMIZATION_LEVEL = -O (Optimize for Speed)
GCC_OPTIMIZATION_LEVEL = fast (-O2)
```

**Swift Compiler**:
```
SWIFT_COMPILATION_MODE = wholemodule
```

**Dead Code Stripping**:
```
DEAD_CODE_STRIPPING = YES
```

**Debug Symbols**:
```
DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
```

**Alternativa (via xcconfig - RECOMENDADO)**:

Editar `ios/Flutter/Release.xcconfig`:
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

**⚠️ IMPORTANTE**: Los archivos `.xcconfig` **NO soportan comentarios** con `#` (excepto para `#include`). Si agregas comentarios decorativos como `# Symbol Stripping`, el build fallará con error:
```
Error (Xcode): unsupported preprocessor directive
```

**Solución**: Solo usar configuraciones en formato `KEY = VALUE` sin comentarios.

**✅ Checkpoint 3.2**: Build settings configurados

---

### 4.4. Paso 3.3: Build iOS Ofuscado

```bash
# Build iOS con ofuscación
flutter build ios \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# Tiempo estimado: 5-7 minutos
```

**Salida Esperada**:
```
Building com.example.noteKeeper...
Running Xcode build...
✓ Built build/ios/iphoneos/Runner.app
```

**Verificar símbolos generados**:
```bash
ls -lh build/app/outputs/symbols/
# Expected: app.ios.symbols
```

**✅ Checkpoint 3.3**: Build iOS exitoso

---

### 4.5. Paso 3.4: Crear Archive y Exportar IPA

**Vía Xcode**:

1. En Xcode: **Product → Archive**
2. Esperar a que archive complete (~5-10 min)
3. En Organizer, seleccionar archive reciente
4. Click **Distribute App**
5. Seleccionar **Ad Hoc** (para testing)
6. Click **Next → Export**
7. Guardar IPA en `build/ios/ipa/`

**Vía Command Line**:
```bash
cd ios

# Crear archive
xcodebuild \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  -archivePath ../build/ios/archive/Runner.xcarchive \
  archive

# Exportar IPA (requiere ExportOptions.plist)
xcodebuild \
  -exportArchive \
  -archivePath ../build/ios/archive/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ../build/ios/ipa

cd ..
```

**Verificar IPA**:
```bash
ls -lh build/ios/ipa/Runner.ipa
```

**✅ Checkpoint 3.4**: IPA generado

---

### 4.6. Paso 3.5: Verificar dSYM Generado

```bash
# Verificar dSYM bundle
ls -lh build/ios/archive/Runner.xcarchive/dSYMs/

# Expected: Runner.app.dSYM/ (directorio)

# Ver tamaño
du -sh build/ios/archive/Runner.xcarchive/dSYMs/
# Expected: 20-40 MB
```

**El dSYM es CRÍTICO** para des-ofuscar crashes de producción.

**✅ Checkpoint 3.5**: dSYM generado

---

### 4.7. Paso 3.6: Instalar y Probar en iPhone

**Instalar IPA en iPhone**:

**Opción A: Xcode**:
1. Conectar iPhone via USB
2. En Xcode: **Window → Devices and Simulators**
3. Seleccionar iPhone
4. Click **+** (bajo "Installed Apps")
5. Seleccionar `build/ios/ipa/Runner.ipa`

**Opción B: Command Line** (requiere ideviceinstaller):
```bash
brew install ideviceinstaller
ideviceinstaller -i build/ios/ipa/Runner.ipa
```

**Testing en iPhone**:
- [ ] App abre sin crashes
- [ ] Funcionalidad core operativa
- [ ] Rotar dispositivo (landscape/portrait)
- [ ] Background/foreground

**✅ Checkpoint 3.6**: App funciona en iPhone real

---

### 4.8. Paso 3.7: Medir Reducción de Tamaño

```bash
# Tamaño sin optimización (simulado - ajustar con valor real)
SIZE_BEFORE=20971520  # 20 MB

# Tamaño con optimización
SIZE_AFTER=$(du -b build/ios/ipa/Runner.ipa | cut -f1)

# Calcular reducción
REDUCTION=$((100 - (SIZE_AFTER * 100 / SIZE_BEFORE)))
echo "IPA sin optimización: $((SIZE_BEFORE / 1024 / 1024)) MB"
echo "IPA con optimización: $((SIZE_AFTER / 1024 / 1024)) MB"
echo "Reducción: ${REDUCTION}%"
```

**Resultado Esperado**:
```
IPA sin optimización: 20 MB
IPA con optimización: 14 MB
Reducción: 30%
```

**Target**: ≥20% de reducción

**✅ Checkpoint 3.7**: Reducción ≥20%

---

### 4.9. Resumen Fase 3

**Completado**:
- [x] Build settings iOS configurados
- [x] Build iOS ofuscado exitoso
- [x] IPA generado
- [x] dSYM generado
- [x] App funciona en iPhone
- [x] Reducción de tamaño ≥20%

**Entregables**:
- `ios/Flutter/Release.xcconfig` (modificado)
- IPA reducido en 30%
- dSYM para des-ofuscación

**Métricas Logradas**:
- IPA: 20 MB → 14 MB (30% reducción) ✅
- Símbolos stripped: 80%+ ✅
- Funcionalidad: 100% preservada ✅

**Siguiente Fase**: Scripts de automatización

---

## 5. Fase 4: Scripts de Automatización

### Duración: 3 días

### 5.1. Objetivo

Crear scripts para automatizar builds ofuscados y des-ofuscación de crashes.

### 5.2. Script 1: build_release_obfuscated.sh

**Crear archivo**:
```bash
touch scripts/build_release_obfuscated.sh
chmod +x scripts/build_release_obfuscated.sh
```

**Contenido** (versión completa en PLAN_SEGURIDAD_OFUSCACION_MINIFICACION.md líneas 1056-1272):

```bash
#!/bin/bash
set -e
set -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# Detectar versión
VERSION=$(grep "version:" pubspec.yaml | head -1 | cut -d' ' -f2 | tr -d '\r')
log_info "Building obfuscated release v$VERSION"

SYMBOLS_DIR="build/app/outputs/symbols"
mkdir -p "$SYMBOLS_DIR"

# PASO 1: Limpiar
log_step "Paso 1: Limpiando build anterior..."
flutter clean

# PASO 2: Dependencias
log_step "Paso 2: Obteniendo dependencias..."
flutter pub get

# PASO 3: Tests
log_step "Paso 3: Ejecutando tests..."
if flutter test; then
    log_info "✅ Tests pasaron"
else
    log_error "❌ Tests fallaron"
    exit 1
fi

# PASO 4: Build Android
log_step "Paso 4: Building Android APK (ofuscado)..."
flutter build apk \
    --release \
    --obfuscate \
    --split-debug-info="$SYMBOLS_DIR" \
    --split-per-abi

if [ $? -eq 0 ]; then
    log_info "✅ APK generado"
    for apk in build/app/outputs/flutter-apk/*.apk; do
        [ -f "$apk" ] && log_info "  - $(basename "$apk"): $(du -h "$apk" | cut -f1)"
    done
else
    log_error "❌ Error generando APK"
    exit 1
fi

# PASO 5: Build iOS (solo en macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    log_step "Paso 5: Building iOS IPA (ofuscado)..."
    flutter build ios --release --obfuscate --split-debug-info="$SYMBOLS_DIR"

    # Crear archive
    cd ios
    xcodebuild -workspace Runner.xcworkspace \
        -scheme Runner \
        -sdk iphoneos \
        -configuration Release \
        -archivePath ../build/ios/archive/Runner.xcarchive \
        archive
    cd ..

    log_info "✅ IPA generado"
else
    log_warn "⚠️  Skipping iOS (not on macOS)"
fi

# PASO 6: Verificar mapping files
log_step "Paso 6: Verificando mapping files..."
[ -f "build/app/outputs/mapping/release/mapping.txt" ] && log_info "✅ mapping.txt" || log_error "❌ mapping.txt faltante"

# PASO 7: Archivar
log_step "Paso 7: Archivando artefactos..."
./scripts/archive_release.sh

log_info "======================================"
log_info "Build Completado - v$VERSION"
log_info "======================================"
```

**Probar script**:
```bash
./scripts/build_release_obfuscated.sh
```

**✅ Checkpoint 5.2**: Script de build funciona

---

### 5.3. Script 2: deobfuscate.sh

**Crear archivo**:
```bash
touch scripts/deobfuscate.sh
chmod +x scripts/deobfuscate.sh
```

**Contenido**:
```bash
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Uso: $0 <version> <crash_file>"
    echo "Ejemplo: $0 v0.1.0 crash.txt"
    exit 1
fi

VERSION=$1
CRASH_FILE=$2

SYMBOLS_DIR="releases/$VERSION/symbols"
MAPPING_FILE="releases/$VERSION/mapping/mapping.txt"

if [ ! -d "$SYMBOLS_DIR" ]; then
    echo "❌ Error: Símbolos no encontrados para $VERSION"
    exit 1
fi

echo "Des-ofuscando crash de $VERSION..."

# Des-ofuscar Flutter
flutter symbolize -i "$CRASH_FILE" -d "$SYMBOLS_DIR" > crash_deobfuscated.txt

echo "✅ Stack trace des-ofuscado: crash_deobfuscated.txt"
cat crash_deobfuscated.txt
```

**Probar script** (con crash simulado):
```bash
# Crear crash de prueba
echo "at a.b.c(Unknown Source)" > test_crash.txt

# Des-ofuscar
./scripts/deobfuscate.sh v0.1.0 test_crash.txt
```

**✅ Checkpoint 5.3**: Script de des-ofuscación funciona

---

### 5.4. Script 3: Integración con archive_release.sh

**Modificar** `scripts/archive_release.sh` para incluir mapping files:

```bash
# Añadir después de copiar APKs
log_info "Archivando mapping files..."
mkdir -p "$RELEASE_DIR/mapping"
mkdir -p "$RELEASE_DIR/symbols"

# Copiar mapping files Android
if [ -f "build/app/outputs/mapping/release/mapping.txt" ]; then
    cp build/app/outputs/mapping/release/*.txt "$RELEASE_DIR/mapping/"
fi

# Copiar symbols Flutter
if [ -d "build/app/outputs/symbols" ]; then
    cp build/app/outputs/symbols/*.symbols "$RELEASE_DIR/symbols/"
fi

# Copiar dSYM iOS
if [ -d "build/ios/archive/Runner.xcarchive/dSYMs" ]; then
    cp -r build/ios/archive/Runner.xcarchive/dSYMs "$RELEASE_DIR/symbols/"
fi
```

**✅ Checkpoint 5.4**: Integración completa

---

### 5.5. Resumen Fase 4

**Completado**:
- [x] build_release_obfuscated.sh creado
- [x] deobfuscate.sh creado
- [x] Integración con archive_release.sh
- [x] Scripts testeados y funcionando

**Entregables**:
- 3 scripts automatizados
- Documentación de uso

**Siguiente Fase**: Testing y validación

---

## 6. Fase 5: Testing y Validación

### Duración: 3 días

### 6.1. Suite de Tests

**Test Nivel 1: Automated Tests**
```bash
# Ejecutar todos los tests
flutter test

# Expected: All tests passed
```

**Test Nivel 2: Integration Tests**
```bash
# Instalar APK ofuscado
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Ejecutar integration tests
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  --release
```

**Test Nivel 3: Manual Testing** (checklist en documento 04_TVP)

**✅ Checkpoint 6.1**: Todos los tests pasando

---

### 6.2. Validación de Métricas

| Métrica | Target | Resultado | Status |
|---------|--------|-----------|--------|
| APK reducción | ≥25% | TBD | 🟡 |
| IPA reducción | ≥20% | TBD | 🟡 |
| Símbolos ofuscados | ≥95% | TBD | 🟡 |
| Build time | ≤5 min | TBD | 🟡 |
| Tests passing | 100% | TBD | 🟡 |
| Crash-free rate | ≥99.9% | TBD | 🟡 |

**✅ Checkpoint 6.2**: Todas las métricas cumplen targets

---

## 7. Troubleshooting

### 7.1. Error: ClassNotFoundException

**Síntoma**:
```
java.lang.ClassNotFoundException: com.example.note_keeper.models.Note
```

**Causa**: Clase eliminada por R8

**Solución**:
```proguard
# Añadir a proguard-rules.pro
-keep class com.example.note_keeper.models.Note { *; }
```

---

### 7.2. Error: NoSuchMethodException

**Síntoma**:
```
NoSuchMethodError: The method 'fromJson' was called on null
```

**Causa**: Método eliminado por R8

**Solución**:
```proguard
-keepclassmembers class com.example.note_keeper.models.** {
    public <methods>;
    public <init>(...);
}
```

---

### 7.3. Build Time Excesivo (> 10 min)

**Causa**: R8 optimization passes muy agresivos

**Solución**:
```proguard
# Reducir optimization passes
-optimizationpasses 3  # En lugar de 5
```

---

### 7.4. Error: Xcode 16.2 ModuleCache Corrupto

**Síntoma**:
```
Error: ModuleCache.noindex/Session.modulevalidation
Compilation errors with Xcode 16.2
```

**Causa**: Bug conocido en Xcode 16.2 con ModuleCache corrupto

**Solución**:
```bash
# Ejecutar el script de fix incluido en el toolkit
./scripts/fix_xcode_modulecache.sh
```

O manualmente:
```bash
# 1. Limpiar proyecto Flutter
flutter clean

# 2. Eliminar DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData

# 3. Eliminar ModuleCache
rm -rf ~/Library/Developer/Xcode/ModuleCache.noindex

# 4. Reinstalar dependencias
flutter pub get

# 5. Limpiar y reinstalar Pods
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# 6. Cambiar Xcode Workspace Settings:
# File → Workspace Settings → Derived Data → "Workspace-relative Location"
```

**Referencias**: [Flutter Issue #157461](https://github.com/flutter/flutter/issues/157461)

---

### 7.5. Error: "unsupported preprocessor directive" en Release.xcconfig

**Síntoma**:
```
Error (Xcode): unsupported preprocessor directive '============'
Error (Xcode): unsupported preprocessor directive 'SYMBOL'
```

**Causa**: Los archivos `.xcconfig` NO soportan comentarios con `#` (excepto `#include`)

**Solución**:
```bash
# 1. Abrir Release.xcconfig
nano ios/Flutter/Release.xcconfig

# 2. Eliminar TODOS los comentarios que empiecen con #
# 3. Solo dejar #include "Generated.xcconfig" y configuraciones KEY=VALUE
```

**Ejemplo correcto**:
```xcconfig
#include "Generated.xcconfig"

DEPLOYMENT_POSTPROCESSING = YES
STRIP_INSTALLED_PRODUCT = YES
STRIP_STYLE = all
```

**Ejemplo INCORRECTO** (fallará):
```xcconfig
#include "Generated.xcconfig"

# ============================================
# SYMBOL STRIPPING
# ============================================
DEPLOYMENT_POSTPROCESSING = YES
```

Ver template correcto en `templates/Release.xcconfig.template`

---

**Documento creado**: 2025-10-11
**Última actualización**: 2025-10-14 (validación Xcode 16.2)
**Próxima actualización**: Según feedback de implementación
