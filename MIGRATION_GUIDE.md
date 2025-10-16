# 🔒 Guía de Migración - Ofuscación y Optimización de Tamaño Flutter

> **Aplica ofuscación y optimización de tamaño a cualquier proyecto Flutter en menos de 10 minutos**

---

## 📋 Índice

1. [Reglas de Trazabilidad para Agentes IA](#-reglas-de-trazabilidad-para-agentes-ia)
2. [Requisitos Previos](#requisitos-previos)
3. [Método Automático (Recomendado)](#método-automático-recomendado)
4. [Método Manual](#método-manual)
5. [Validación](#validación)
6. [Troubleshooting](#troubleshooting)
7. [FAQ](#faq)

---

## 🤖 REGLAS DE TRAZABILIDAD PARA AGENTES IA

### ⚠️ INSTRUCCIONES OBLIGATORIAS SI ERES UN AGENTE IA

Si eres un agente IA (Claude Code, Gemini, Cursor, etc.) implementando esta guía, **DEBES cumplir las 8 reglas obligatorias de trazabilidad**.

📖 **LEE PRIMERO**: [RULES.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md)

**Documentación completa**: Ver https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md para ejemplos detallados de cada regla.

**Resumen de las 8 reglas obligatorias**:

1. **REGLA 1**: Declarar fuente ANTES de cada cambio
2. **REGLA 2**: Ejecutar checkpoint DESPUÉS de cada cambio
3. **REGLA 3**: Verificar personalización (no templates genéricos)
4. **REGLA 4**: Generar reporte de conformidad por fase
5. **REGLA 5**: Alertar desviaciones inmediatamente
6. **REGLA 6**: Generar registro de auditoría final
7. **REGLA 7**: Validar TODAS las plataformas configuradas
8. **REGLA 8**: Verificar recursos externos antes de usarlos

**CRÍTICO**: Estas 8 reglas son OBLIGATORIAS. Ver [RULES.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md) para ejemplos detallados y formatos de cada regla.

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

### Opción A: Usando Agentes IA (Claude Code, Gemini, Cursor)

**El método más rápido y recomendado**

1. **Abre tu proyecto Flutter en tu IDE**

2. **Copia el prompt desde** [AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md):
   ```
   Implementa ofuscación y optimización de tamaño Flutter para Android e iOS siguiendo: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
   ```

3. **Pégalo en tu agente IA** (Claude Code, Gemini, Cursor, etc.)

4. **El agente automáticamente**:
   - Lee las configuraciones desde este repositorio
   - Detecta tu applicationId y plugins
   - Crea archivos personalizados en tu proyecto
   - Configura Android (R8 + ProGuard)
   - Configura iOS (Symbol Stripping)
   - Valida la implementación

5. **Valida el resultado**:
   ```bash
   flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi
   ```

**Tiempo estimado**: 5-10 minutos
**Ventaja**: No necesitas descargar ni copiar nada, todo se crea directamente en tu proyecto

---

### Opción B: Script de Setup Manual

Si no usas agentes IA:

1. **Descarga solo el script de setup**:
   ```bash
   curl -o /tmp/setup_obfuscation.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/setup_obfuscation.sh
   chmod +x /tmp/setup_obfuscation.sh
   ```

2. **Ejecuta el script** (lee templates del repositorio y crea archivos locales):
   ```bash
   cd /path/to/tu-proyecto
   /tmp/setup_obfuscation.sh
   rm /tmp/setup_obfuscation.sh
   ```

3. **Personaliza la configuración generada**:
   ```bash
   # Edita proguard-rules.pro
   nano android/app/proguard-rules.pro

   # Reemplaza 'com.example.app' con tu applicationId
   # Agrega reglas para tus modelos específicos
   ```

4. **Valida la configuración**:
   ```bash
   flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi
   ```

**Tiempo estimado**: 10 minutos
**Nota**: El script NO copia archivos del toolkit, solo crea archivos personalizados en tu proyecto

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

Crea el archivo `android/app/proguard-rules.pro` con el siguiente contenido mínimo (o consulta el template completo en: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/android/app/proguard-rules.pro):

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

#### 2.1 Opción A: Usando Release.xcconfig (Recomendado)

1. Abre `ios/Flutter/Release.xcconfig`
2. Lee el template desde el repositorio (https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/Release.xcconfig.template) o agrega directamente:

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

**⚠️ IMPORTANTE**: Los archivos `.xcconfig` **NO soportan comentarios** con `#` (excepto `#include`). Si agregas comentarios, el build fallará con error "unsupported preprocessor directive".

#### 2.2 Opción B: Usando Xcode

1. Abre `ios/Runner.xcworkspace` en Xcode
2. Selecciona el target "Runner"
3. Ve a "Build Settings"
4. Busca y configura (para **Release** y **Profile**):

   | Setting | Valor |
   |---------|-------|
   | Dead Code Stripping | **YES** |
   | Strip Debug Symbols During Copy | **YES** |
   | Strip Style | **All Symbols** |
   | Strip Swift Symbols | **YES** |
   | Symbols Hidden by Default | **YES** |
   | Deployment Postprocessing | **YES** |

#### 2.3 Opción C: Editar project.pbxproj manualmente

1. Abre `ios/Runner.xcodeproj/project.pbxproj`
2. Busca las secciones que contienen `/* Release */` y `/* Profile */`
3. Agrega estas configuraciones en ambas:

```
DEAD_CODE_STRIPPING = YES;
DEPLOYMENT_POSTPROCESSING = YES;
STRIP_INSTALLED_PRODUCT = YES;
STRIP_STYLE = "all";
STRIP_SWIFT_SYMBOLS = YES;
SYMBOLS_HIDDEN_BY_DEFAULT = YES;
```

---

### Paso 3: Crear Scripts de Automatización

Crea los scripts en tu proyecto leyendo el contenido desde el repositorio:

```bash
# Crear directorio scripts
mkdir -p scripts

# Descargar y crear build_release_obfuscated.sh
curl -o scripts/build_release_obfuscated.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
chmod +x scripts/build_release_obfuscated.sh

# Descargar y crear deobfuscate.sh
curl -o scripts/deobfuscate.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh
chmod +x scripts/deobfuscate.sh

# Descargar y crear fix_xcode_modulecache.sh
curl -o scripts/fix_xcode_modulecache.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/fix_xcode_modulecache.sh
chmod +x scripts/fix_xcode_modulecache.sh
```

**Nota**: Estos scripts son independientes y no contaminan tu proyecto con archivos del toolkit. Solo agregan funcionalidad de build y troubleshooting.

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

**⚠️ IMPORTANTE**: La validación es **CRÍTICA** para confirmar que la ofuscación está realmente funcionando, no solo configurada.

### 🤖 Validación Automática (Recomendado)

El método más rápido y completo. Ejecuta el script de validación:

```bash
# Opción 1: Si tienes el toolkit descargado
./scripts/validate-implementation.sh

# Opción 2: Desde URL (sin descargar nada)
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
```

**Este script automáticamente:**
1. ✅ Detecta qué plataformas configuraste (Android, iOS, o ambas)
2. ✅ Valida archivos de configuración
3. ✅ Ejecuta builds de prueba para CADA plataforma configurada
4. ✅ **Valida técnicamente que la ofuscación está funcionando**
5. ✅ Genera reporte completo con exit code 0 si todo está OK

**Resultado esperado**: Exit code 0 y mensaje "IMPLEMENTACIÓN CERTIFICADA"

**Ver documentación completa**: [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md)

---

### 🔧 Validación Manual (Opcional)

Si prefieres validar manualmente paso a paso:

### Phase 1: Verificar Configuración

Verifica solo las plataformas que configuraste:

```bash
# Si configuraste Android: Verificar que R8 está habilitado
grep "minifyEnabled" android/app/build.gradle*

# Si configuraste iOS: Verificar symbol stripping
grep "STRIP_INSTALLED_PRODUCT" ios/Flutter/Release.xcconfig
```

---

### Phase 2: Build de Plataformas Configuradas

**⚠️ IMPORTANTE**: Construye y valida **cada plataforma que configuraste**. Puedes configurar:
- Solo Android
- Solo iOS
- Ambas plataformas

#### 2.1 Build Android (Si configuraste Android)

**Solo ejecuta esto si configuraste la ofuscación para Android.**

```bash
# Limpiar builds previos
flutter clean

# Build Android con ofuscación
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android \
  --split-per-abi
```

**Resultados esperados Android**:
- ✅ Build exitoso en ~30 segundos
- ✅ APKs generados (13-17 MB cada uno)
- ✅ `mapping.txt` generado (2-5 MB)
- ✅ Símbolos Flutter Android generados (3 archivos .symbols)

**Verificar archivos Android**:
```bash
# Verificar APKs generados
ls -lh build/app/outputs/flutter-apk/

# Verificar mapping.txt
ls -lh build/app/outputs/mapping/release/mapping.txt

# Verificar símbolos Android
ls -lh build/symbols/android/
```

#### 2.2 Build iOS (Si configuraste iOS)

**Solo ejecuta esto si configuraste la ofuscación para iOS. Requiere macOS.**

```bash
# Build iOS con ofuscación
flutter build ios \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/ios
```

**Resultados esperados iOS**:
- ✅ Build exitoso en ~3-5 minutos
- ✅ Runner.app generado
- ✅ Símbolos Flutter iOS generados
- ✅ dSYM generado (en archive)

**Verificar archivos iOS**:
```bash
# Verificar Runner.app
ls -lh build/ios/Release-iphoneos/Runner.app/

# Verificar símbolos iOS
ls -lh build/symbols/ios/

# Verificar binario stripped
file build/ios/Release-iphoneos/Runner.app/Runner
# Expected: "stripped" en output
```

---

### Phase 3: Validación Técnica

**⚠️ CRÍTICO**: La validación confirma que la ofuscación está **realmente funcionando**, no solo configurada.

**Validación Automática (Recomendada)**:
```bash
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
```

**Expected**: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

**¿Qué valida este script?**
- ✅ **Android**: R8 activo, mapping.txt >10k líneas, dead code elimination, ofuscación Dart en binario
- ✅ **iOS**: Binario stripped, tamaño optimizado, símbolos separados, nm falla al leer símbolos

**Validación Manual y Técnica Profunda**:

Para validación paso a paso o inspección técnica de binarios, ver documentación completa:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

---

## 🔍 Troubleshooting

**Problemas comunes y soluciones rápidas**:

| Problema | Solución Rápida | Documentación Completa |
|----------|-----------------|------------------------|
| **Build falla con R8** | Agregar `-keep class` y `-dontwarn` en `proguard-rules.pro` | [TROUBLESHOOTING_ADVANCED.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md) |
| **App crashea después** | Des-ofuscar stack trace: `./scripts/deobfuscate.sh -p android -s crash.txt` | [TROUBLESHOOTING_ADVANCED.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md) |
| **APK sigue grande** | Verificar R8 habilitado + usar `--split-per-abi` | [TROUBLESHOOTING_ADVANCED.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md) |
| **Xcode 16.2 ModuleCache Error** | Ver guía específica iOS → | [IOS_MANUAL_STEPS.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IOS_MANUAL_STEPS.md) |
| **unsupported preprocessor** | Eliminar comentarios `#` de Release.xcconfig | [TROUBLESHOOTING_ADVANCED.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md) |

**30+ problemas categorizados por framework** (Riverpod, GetX, Bloc, Hive, Dio, Firebase):
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

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

## 🔍 Checklist de Validación Final (Para Agentes IA)

**IMPORTANTE**: Antes de marcar la implementación como completa, verifica cada punto:

### Paso 1: Detectar Plataformas Configuradas

```bash
# ¿Android configurado?
grep -q "isMinifyEnabled" android/app/build.gradle* && echo "✅ Android" || echo "⬜ Android no configurado"

# ¿iOS configurado?
grep -q "STRIP_INSTALLED_PRODUCT" ios/Flutter/Release.xcconfig && echo "✅ iOS" || echo "⬜ iOS no configurado"
```

### Paso 2: Validar CADA Plataforma Configurada

**Si configuraste Android**:
- [ ] Build ejecutado: `flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi`
- [ ] APKs generados: `ls build/app/outputs/flutter-apk/*.apk`
- [ ] mapping.txt existe: `test -f build/app/outputs/mapping/release/mapping.txt`
- [ ] Símbolos Android generados: `test -d build/symbols/android`

**Si configuraste iOS**:
- [ ] Build ejecutado: `flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios`
- [ ] Runner.app generado: `test -d build/ios/Release-iphoneos/Runner.app`
- [ ] Binario stripped: `file build/ios/Release-iphoneos/Runner.app/Runner | grep -q stripped`
- [ ] Símbolos iOS generados: `test -d build/symbols/ios`

### Paso 3: Ejecutar Validación Automática

- [ ] Script ejecutado: `curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash`
- [ ] Exit code 0 (sin errores)
- [ ] Todas las validaciones pasaron

### ❌ NO Marques como Completo Si:

- Configuraste 2 plataformas pero solo validaste 1
- El script de validación falló
- Hay builds que no ejecutaste
- Asumiste que funciona sin verificar

### ✅ SOLO Marca como Completo Cuando:

1. Detectaste qué plataformas configuraste
2. Validaste CADA una con su build correspondiente
3. El script validate-implementation.sh retornó exit code 0
4. Generaste la auditoría final incluyendo TODAS las plataformas

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

**Última actualización**: 2025-10-14
**Versión**: 1.0.0
**Filosofía**: Agentes IA leen desde repositorio y crean archivos en TU proyecto - NO copiar
