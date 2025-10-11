# SRS - Software Requirements Specification
## Minificación y Ofuscación de Código para Note Keeper

> **Especificación de Requisitos de Software (IEEE 830-1998)**
>
> Proyecto: Note Keeper - Seguridad de Código
> Fecha: 2025-10-11
> Versión: 1.0.0
> Estado: Aprobado para Implementación

---

## 📋 Tabla de Contenidos

1. [Introducción](#1-introducción)
2. [Descripción General](#2-descripción-general)
3. [Requisitos Funcionales](#3-requisitos-funcionales)
4. [Requisitos No Funcionales](#4-requisitos-no-funcionales)
5. [Restricciones y Dependencias](#5-restricciones-y-dependencias)
6. [Casos de Uso](#6-casos-de-uso)
7. [Criterios de Aceptación](#7-criterios-de-aceptación)

---

## 1. Introducción

### 1.1. Propósito del Documento

Este documento especifica los requisitos funcionales y no funcionales para la implementación de técnicas de **minificación y ofuscación de código** en la aplicación Flutter "Note Keeper". El objetivo es proteger la propiedad intelectual, dificultar la ingeniería inversa y reducir el tamaño de los binarios de distribución.

**Audiencia**:
- Desarrolladores de software
- Arquitectos de seguridad
- Testers QA
- DevOps engineers
- Product managers

### 1.2. Alcance del Sistema

#### Sistema: Note Keeper - Seguridad de Código

**Objetivos**:
1. Implementar ofuscación de código Dart/Flutter
2. Configurar minificación con R8 para Android
3. Aplicar symbol stripping para iOS
4. Reducir tamaño de binarios en ≥25%
5. Proteger contra ingeniería inversa (nivel 8/10)

**Beneficios Esperados**:
- Protección de propiedad intelectual
- Reducción de costos de ancho de banda (30% menos tamaño)
- Dificultar clonación de la aplicación
- Mantener 100% de funcionalidad

**Fuera de Alcance**:
- Cifrado de base de datos SQLite
- Ofuscación de assets (imágenes, JSON)
- Protección contra jailbreak/root detection
- Certificate pinning para APIs

### 1.3. Definiciones y Acrónimos

| Término | Definición |
|---------|------------|
| **Ofuscación** | Transformación del código para hacerlo ilegible manteniendo su funcionalidad |
| **Minificación** | Eliminación de código no utilizado (dead code) y reducción de tamaño |
| **R8** | Herramienta de Google para shrinking y obfuscation en Android |
| **ProGuard** | Herramienta legacy de ofuscación Java/Kotlin |
| **Tree Shaking** | Eliminación de código no referenciado en el árbol de dependencias |
| **Mapping File** | Archivo que mapea símbolos ofuscados a nombres originales |
| **dSYM** | Debug Symbol files de iOS |
| **AOT** | Ahead-of-Time compilation |
| **JNI** | Java Native Interface |
| **Shrinking** | Proceso de eliminación de código/recursos no utilizados |

### 1.4. Referencias

- IEEE 830-1998: Recommended Practice for Software Requirements Specifications
- [Flutter Code Obfuscation](https://docs.flutter.dev/deployment/obfuscate)
- [Android R8 Documentation](https://developer.android.com/studio/build/shrink-code)
- [iOS App Thinning](https://developer.apple.com/documentation/xcode/reducing-your-app-s-size)
- PROJECT_RULES.md (Reglas del proyecto Note Keeper)
- BEST_PRACTICES.md (Mejores prácticas del proyecto)

---

## 2. Descripción General

### 2.1. Perspectiva del Producto

El sistema de minificación y ofuscación es un **módulo de seguridad** que se integra al proceso de build de la aplicación Note Keeper. Opera como una capa de transformación entre el código fuente y los binarios distribuibles.

```
┌─────────────────────────────────────────────────────────┐
│                   CÓDIGO FUENTE                         │
│  lib/ (Dart), android/ (Kotlin), ios/ (Swift)           │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │  COMPILACIÓN FLUTTER   │
         │  + OFUSCACIÓN          │
         └───────────┬───────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
┌────────────────┐        ┌────────────────┐
│  ANDROID       │        │  iOS           │
│  R8 Shrinking  │        │  Symbol Strip  │
│  Obfuscation   │        │  Optimization  │
└───────┬────────┘        └────────┬───────┘
        │                          │
        ▼                          ▼
┌────────────────┐        ┌────────────────┐
│  APK           │        │  IPA           │
│  Ofuscado      │        │  Ofuscado      │
│  10.5 MB       │        │  14.0 MB       │
└────────────────┘        └────────────────┘
```

### 2.2. Funciones del Producto

| ID | Función | Prioridad |
|----|---------|-----------|
| F-01 | Ofuscar código Dart en compilación | Crítica |
| F-02 | Minificar código Android con R8 | Alta |
| F-03 | Eliminar símbolos de debug en iOS | Alta |
| F-04 | Generar mapping files para des-ofuscación | Crítica |
| F-05 | Preservar código crítico (modelos, plugins) | Crítica |
| F-06 | Reducir tamaño de binarios ≥25% | Alta |
| F-07 | Automatizar build ofuscado | Media |
| F-08 | Integrar con sistema de versionado de artifacts | Media |

### 2.3. Características de Usuarios

#### Usuario 1: Desarrollador

**Descripción**: Ingeniero de software que trabaja en Note Keeper

**Responsabilidades**:
- Escribir código siguiendo PROJECT_RULES.md
- Ejecutar builds locales
- Debugear crashes con mapping files

**Nivel Técnico**: Alto

**Necesidades**:
- Build rápido (< 5 min)
- Stack traces legibles con mapping files
- Documentación clara de troubleshooting

#### Usuario 2: DevOps Engineer

**Descripción**: Responsable de CI/CD y releases

**Responsabilidades**:
- Ejecutar builds de producción
- Gestionar mapping files
- Monitorear crashes post-deploy

**Nivel Técnico**: Alto

**Necesidades**:
- Scripts automatizados de build
- Versionado automático de artifacts
- Integración con Firebase Crashlytics

#### Usuario 3: Security Analyst

**Descripción**: Analista de seguridad que audita la app

**Responsabilidades**:
- Verificar nivel de ofuscación
- Auditar binarios de release
- Validar cumplimiento de requisitos de seguridad

**Nivel Técnico**: Muy Alto

**Necesidades**:
- Herramientas de análisis de binarios
- Métricas de ofuscación
- Reportes de seguridad

### 2.4. Restricciones

#### Restricciones Técnicas

1. **RT-01**: Debe ser compatible con Flutter SDK ≥3.9.2
2. **RT-02**: Debe soportar Android API 24+ (Android 7.0+)
3. **RT-03**: Debe soportar iOS 13+
4. **RT-04**: Build time máximo 5 minutos (para full build)
5. **RT-05**: Debe preservar 100% de funcionalidad

#### Restricciones de Negocio

1. **RN-01**: Sin costos de licencias adicionales (presupuesto $0)
2. **RN-02**: Implementación en ≤3 semanas (15 días laborables)
3. **RN-03**: Debe ser mantenible por equipo actual (sin expertos externos)

#### Restricciones Regulatorias

1. **RR-01**: Cumplir con lineamientos de Google Play Store
2. **RR-02**: Cumplir con lineamientos de Apple App Store
3. **RR-03**: No usar técnicas de ofuscación prohibidas (packing, encryption)

### 2.5. Supuestos y Dependencias

#### Supuestos

1. **A-01**: Equipo tiene conocimientos de Flutter y Dart
2. **A-02**: Infraestructura de CI/CD está disponible
3. **A-03**: Dispositivos de testing (Android/iOS) están disponibles
4. **A-04**: Firebase Crashlytics está configurado

#### Dependencias

1. **D-01**: Flutter SDK 3.9.2+
2. **D-02**: Android Gradle Plugin 8.0+
3. **D-03**: Xcode 15+
4. **D-04**: Git LFS para almacenamiento de mapping files
5. **D-05**: Sistema de versionado de artifacts (PLAN_VERSIONADO_ARTEFACTOS.md)

---

## 3. Requisitos Funcionales

### RF-01: Ofuscación de Código Dart

**Descripción**: El sistema debe ofuscar todo el código Dart compilado usando el flag `--obfuscate` de Flutter.

**Prioridad**: Crítica

**Entrada**:
- Código fuente Dart en `lib/`
- Comando: `flutter build apk --release --obfuscate --split-debug-info=<dir>`

**Procesamiento**:
1. Compilador AOT de Flutter renombra símbolos (clases, métodos, variables)
2. Genera mapping files en directorio especificado
3. Genera binarios con código ofuscado

**Salida**:
- APK/IPA con código ofuscado
- Archivos `.symbols` para cada arquitectura
- Mapping files para des-ofuscación

**Criterios de Aceptación**:

| ID | Criterio | Método de Verificación |
|----|----------|------------------------|
| CA-01.1 | ≥95% de símbolos renombrados a nombres cortos (a, b, c...) | Análisis de binario con strings |
| CA-01.2 | Stack traces ilegibles sin mapping file | Provocar crash y revisar log |
| CA-01.3 | Símbolos de debug generados por separado | Verificar existencia de *.symbols |
| CA-01.4 | 100% de funcionalidad preservada | Test suite completo |

**Reglas de Negocio**:

- **BR-01.1**: Solo aplicar en builds de release, no en debug
- **BR-01.2**: Mapping files deben almacenarse en `releases/vX.Y.Z/symbols/`
- **BR-01.3**: Symbols files no deben incluirse en APK/IPA final

**Test de Verificación**:
```bash
# Extraer APK y buscar nombres originales
unzip app-release.apk -d extracted/
strings extracted/lib/arm64-v8a/libapp.so | grep "NoteRepository"
# Expected: Sin resultados (clase ofuscada)
```

---

### RF-02: Minificación de Código Android (R8)

**Descripción**: El sistema debe eliminar código Java/Kotlin no utilizado usando R8.

**Prioridad**: Alta

**Entrada**:
- `minifyEnabled = true` en `android/app/build.gradle.kts`
- `shrinkResources = true`
- ProGuard rules en `android/app/proguard-rules.pro`

**Procesamiento**:
1. R8 analiza árbol de dependencias
2. Elimina clases/métodos no referenciados
3. Elimina recursos no usados (drawables, strings)
4. Genera mapping files

**Salida**:
- APK reducido en ≥25%
- mapping.txt
- usage.txt (código eliminado)
- seeds.txt (código preservado)
- resources.txt (recursos eliminados)

**Criterios de Aceptación**:

| ID | Criterio | Método de Verificación |
|----|----------|------------------------|
| CA-02.1 | minifyEnabled = true en build.gradle | Inspección de código |
| CA-02.2 | shrinkResources = true configurado | Inspección de código |
| CA-02.3 | Reducción de APK ≥25% vs. sin minificación | Comparación de tamaños |
| CA-02.4 | 0 crashes relacionados con code shrinking | Testing manual + automated |
| CA-02.5 | mapping.txt generado y archivado | Verificación de archivos |

**Reglas de Negocio**:

- **BR-02.1**: ProGuard rules deben preservar clases en AndroidManifest
- **BR-02.2**: Modelos de datos deben preservarse (serialización JSON)
- **BR-02.3**: Plugins de Flutter deben preservarse

**Test de Verificación**:
```bash
# Build sin minificación
flutter build apk --release
SIZE_BEFORE=$(du -b build/app/outputs/flutter-apk/app-release.apk | cut -f1)

# Build con minificación
# (habilitar minifyEnabled en build.gradle)
flutter build apk --release
SIZE_AFTER=$(du -b build/app/outputs/flutter-apk/app-release.apk | cut -f1)

# Calcular reducción
REDUCTION=$((100 - (SIZE_AFTER * 100 / SIZE_BEFORE)))
echo "Reducción: ${REDUCTION}%"
# Expected: ≥25%
```

---

### RF-03: Preservación de Código Crítico

**Descripción**: Ciertos componentes deben preservarse sin ofuscación para mantener funcionalidad.

**Prioridad**: Crítica

**Código a Preservar**:

| Categoría | Componentes | Justificación |
|-----------|-------------|---------------|
| Android Components | MainActivity, Services | Declarados en AndroidManifest.xml |
| Modelos de Datos | Note, todas las clases en models/ | Serialización JSON |
| Plugins Flutter | Clases io.flutter.** | Integración con engine |
| SQLite | com.tekartik.sqflite.** | Acceso a base de datos |
| JNI | Métodos nativos | Llamados desde C/C++ |

**Entrada**:
- ProGuard rules en `android/app/proguard-rules.pro`

**Procesamiento**:
- R8 lee reglas de preservación
- Excluye clases/métodos especificados de ofuscación
- Marca clases preservadas en seeds.txt

**Salida**:
- Código crítico funcional post-ofuscación
- seeds.txt listando clases preservadas

**Criterios de Aceptación**:

| ID | Criterio | Método de Verificación |
|----|----------|------------------------|
| CA-03.1 | ProGuard rules documentadas con comentarios | Code review |
| CA-03.2 | Classes críticas en seeds.txt | Inspección de seeds.txt |
| CA-03.3 | 0 crashes de ClassNotFoundException | Testing exhaustivo |
| CA-03.4 | Serialización JSON funciona | Unit tests |

**ProGuard Rules Mínimas**:
```proguard
# Preservar Flutter
-keep class io.flutter.** { *; }

# Preservar MainActivity
-keep class com.example.note_keeper.MainActivity { *; }

# Preservar modelos (serialización)
-keep class com.example.note_keeper.models.** { *; }

# Preservar SQLite
-keep class com.tekartik.sqflite.** { *; }

# Preservar métodos JNI
-keepclasseswithmembernames class * {
    native <methods>;
}
```

---

### RF-04: Generación de Mapping Files

**Descripción**: El sistema debe generar archivos de mapping para des-ofuscar stack traces.

**Prioridad**: Crítica

**Mapping Files Requeridos**:

| Archivo | Plataforma | Ubicación | Propósito |
|---------|-----------|-----------|-----------|
| mapping.txt | Android | build/app/outputs/mapping/release/ | Mapeo R8 |
| app.android-arm.symbols | Android | split-debug-info/ | Símbolos Flutter |
| app.android-arm64.symbols | Android | split-debug-info/ | Símbolos Flutter |
| app.android-x64.symbols | Android | split-debug-info/ | Símbolos Flutter |
| app.ios.symbols | iOS | split-debug-info/ | Símbolos Flutter |
| Runner.app.dSYM/ | iOS | build/ios/archive/...dSYMs/ | Símbolos nativos iOS |

**Entrada**:
- Flag `--split-debug-info=<dir>` en comando flutter build
- `STRIP_INSTALLED_PRODUCT = YES` en iOS

**Procesamiento**:
1. Flutter genera .symbols files
2. R8 genera mapping.txt
3. Xcode genera dSYM bundle

**Salida**:
- Mapping files en ubicaciones especificadas
- Archivos copiados a `releases/vX.Y.Z/mapping/`

**Criterios de Aceptación**:

| ID | Criterio | Método de Verificación |
|----|----------|------------------------|
| CA-04.1 | mapping.txt generado para Android | Verificar archivo existe |
| CA-04.2 | *.symbols generados para Flutter | Verificar 3 archivos Android |
| CA-04.3 | dSYM generado para iOS | Verificar bundle existe |
| CA-04.4 | Archivos archivados en releases/vX.Y.Z/ | Verificar estructura |
| CA-04.5 | Tamaño de mapping files razonable (< 100 MB) | du -h |

**Test de Des-ofuscación**:
```bash
# Provocar crash
adb logcat > crash.txt

# Des-ofuscar con mapping
flutter symbolize -i crash.txt -d releases/v0.1.0/symbols/

# Verificar nombres originales aparecen
grep "NoteRepository" crash_deobfuscated.txt
# Expected: Nombres de clases/métodos legibles
```

---

### RF-05: Symbol Stripping en iOS

**Descripción**: Eliminar símbolos de debugging del binario iOS.

**Prioridad**: Alta

**Entrada**:
- Build settings en Xcode

**Configuración Requerida**:
```
DEPLOYMENT_POSTPROCESSING = YES
STRIP_INSTALLED_PRODUCT = YES
STRIP_STYLE = all
COPY_PHASE_STRIP = YES
SEPARATE_STRIP = YES
```

**Procesamiento**:
- Xcode strip elimina símbolos del binario
- Genera dSYM separado con símbolos completos

**Salida**:
- IPA reducido en ≥20%
- dSYM bundle para debugging

**Criterios de Aceptación**:

| ID | Criterio | Método de Verificación |
|----|----------|------------------------|
| CA-05.1 | STRIP_INSTALLED_PRODUCT = YES | Inspección de build settings |
| CA-05.2 | Reducción de IPA ≥20% | Comparación de tamaños |
| CA-05.3 | dSYM generado correctamente | Verificar bundle |
| CA-05.4 | App funciona correctamente | Testing en dispositivo |

---

### RF-06: Automatización de Build

**Descripción**: Script automatizado para generar builds ofuscados.

**Prioridad**: Media

**Entrada**:
- Script: `scripts/build_release_obfuscated.sh`
- Versión en pubspec.yaml

**Procesamiento**:
1. Limpia build anterior
2. Ejecuta tests
3. Build Android ofuscado
4. Build iOS ofuscado
5. Verifica mapping files
6. Archiva artifacts

**Salida**:
- APK/IPA listos para distribuir
- Mapping files archivados
- Reporte de tamaños y tiempos

**Criterios de Aceptación**:

| ID | Criterio | Método de Verificación |
|----|----------|------------------------|
| CA-06.1 | Script ejecuta sin errores | Ejecución exitosa |
| CA-06.2 | Tests deben pasar antes de build | Script aborta si tests fallan |
| CA-06.3 | Build time ≤ 5 minutos | Cronómetro |
| CA-06.4 | Artifacts archivados correctamente | Verificar releases/ |

---

## 4. Requisitos No Funcionales

### RNF-01: Performance de Build

**Descripción**: El proceso de build ofuscado no debe degradar significativamente el tiempo de compilación.

**Métrica**:
```
Build sin ofuscación:     3m 24s (baseline)
Build con ofuscación:     ≤ 4m 25s (+30% máximo)
```

**Prioridad**: Alta

**Método de Medición**:
```bash
time ./scripts/build_release_obfuscated.sh
```

**Criterios de Aceptación**:

| ID | Criterio | Target | Método |
|----|----------|--------|--------|
| CA-NF-01.1 | Full build time | ≤ 5 min | Cronómetro |
| CA-NF-01.2 | Incremento vs. baseline | ≤ +30% | Comparación |
| CA-NF-01.3 | Incremental builds no afectados | 0% incremento | Builds parciales |

---

### RNF-02: Reducción de Tamaño

**Descripción**: Los binarios ofuscados deben ser significativamente más pequeños.

**Prioridad**: Alta

**Métricas Objetivo**:

| Plataforma | Baseline | Target | Reducción |
|-----------|----------|--------|-----------|
| APK (arm64) | 15.0 MB | ≤11.3 MB | ≥25% |
| APK (armv7) | 12.0 MB | ≤9.0 MB | ≥25% |
| IPA | 20.0 MB | ≤16.0 MB | ≥20% |

**Criterios de Aceptación**:

| ID | Criterio | Target | Método |
|----|----------|--------|--------|
| CA-NF-02.1 | APK arm64 reducción | ≥25% | du -h comparison |
| CA-NF-02.2 | IPA reducción | ≥20% | du -h comparison |
| CA-NF-02.3 | Sin degradación de assets | 0% pérdida calidad | Visual inspection |

---

### RNF-03: Nivel de Seguridad

**Descripción**: El código ofuscado debe alcanzar un nivel de protección sólido contra ingeniería inversa.

**Prioridad**: Crítica

**Métrica de Seguridad** (escala 1-10):

| Aspecto | Sin Ofuscación | Target | Método de Medición |
|---------|----------------|--------|---------------------|
| Legibilidad de clases | 10/10 (nombres claros) | ≤2/10 | Inspección manual |
| Recuperabilidad de lógica | 10/10 (inmediata) | ≤3/10 | Análisis de tiempo |
| Tiempo para reverse engineering | 2 horas | ≥2 semanas | Auditoría de seguridad |

**Criterios de Aceptación**:

| ID | Criterio | Target | Método |
|----|----------|--------|--------|
| CA-NF-03.1 | Nivel de seguridad general | ≥8/10 | Security audit |
| CA-NF-03.2 | Ofuscación de símbolos | ≥95% | Análisis de binario |
| CA-NF-03.3 | Tiempo para reversa completa | ≥80 horas | Penetration test |

---

### RNF-04: Mantenibilidad

**Descripción**: El sistema debe ser fácil de mantener y debugear.

**Prioridad**: Alta

**Criterios de Aceptación**:

| ID | Criterio | Target | Método |
|----|----------|--------|--------|
| CA-NF-04.1 | Documentación de ProGuard rules | 100% reglas comentadas | Code review |
| CA-NF-04.2 | Troubleshooting guide completa | ≥10 problemas comunes | Document review |
| CA-NF-04.3 | Tiempo de des-ofuscación de crash | < 5 minutos | Prueba práctica |
| CA-NF-04.4 | Onboarding de nuevo dev | < 1 día | Training session |

---

### RNF-05: Confiabilidad

**Descripción**: El proceso de ofuscación no debe introducir bugs ni crashes.

**Prioridad**: Crítica

**Criterios de Aceptación**:

| ID | Criterio | Target | Método |
|----|----------|--------|--------|
| CA-NF-05.1 | Test suite passing rate | 100% | flutter test |
| CA-NF-05.2 | Crash-free rate | ≥99.9% | Firebase Crashlytics (30 días) |
| CA-NF-05.3 | Defects introducidos | 0 | Bug tracking |
| CA-NF-05.4 | Funcionalidad preservada | 100% | Manual QA checklist |

---

### RNF-06: Compatibilidad

**Descripción**: Debe funcionar en todas las plataformas objetivo.

**Prioridad**: Alta

**Plataformas Soportadas**:

| Plataforma | Versión Mínima | Criterio de Aceptación |
|-----------|----------------|------------------------|
| Android | API 24 (7.0) | App funciona correctamente |
| iOS | iOS 13 | App funciona correctamente |
| Flutter SDK | 3.9.2+ | Build exitoso |
| Android Gradle Plugin | 8.0+ | Configuración compatible |
| Xcode | 15+ | Build exitoso |

**Criterios de Aceptación**:

| ID | Criterio | Target | Método |
|----|----------|--------|--------|
| CA-NF-06.1 | Compatibilidad Android | API 24-34 | Testing en dispositivos |
| CA-NF-06.2 | Compatibilidad iOS | iOS 13-17 | Testing en dispositivos |
| CA-NF-06.3 | Retrocompatibilidad | 0 breaking changes | Regression testing |

---

## 5. Restricciones y Dependencias

### 5.1. Restricciones del Proyecto

#### Restricciones Técnicas

| ID | Restricción | Impacto | Mitigación |
|----|-------------|---------|------------|
| RT-01 | Flutter SDK ≥3.9.2 requerido | Alto | Actualizar SDK si necesario |
| RT-02 | Android minSdk = 24 | Medio | Sin soporte para Android 6.0 y anteriores |
| RT-03 | iOS deployment target = 13 | Medio | Sin soporte para iOS 12 y anteriores |
| RT-04 | Build time ≤ 5 min | Alto | Optimizar ProGuard rules |
| RT-05 | Tamaño de mapping files < 100 MB | Bajo | Usar compresión |

#### Restricciones de Recursos

| ID | Restricción | Impacto | Mitigación |
|----|-------------|---------|------------|
| RR-01 | Presupuesto $0 para licencias | Alto | Solo herramientas open source |
| RR-02 | 15 días laborables para implementación | Alto | Priorizar features críticas |
| RR-03 | Sin expertos externos disponibles | Medio | Training interno |
| RR-04 | Storage para mapping files (≤10 GB/año) | Bajo | Usar Git LFS |

#### Restricciones de Negocio

| ID | Restricción | Impacto | Mitigación |
|----|-------------|---------|------------|
| RN-01 | Debe cumplir lineamientos Google Play | Crítico | Validación pre-release |
| RN-02 | Debe cumplir lineamientos App Store | Crítico | Validación pre-release |
| RN-03 | No usar técnicas prohibidas (packing) | Alto | Usar solo técnicas aprobadas |

### 5.2. Dependencias Externas

| ID | Dependencia | Versión | Criticidad | Proveedor |
|----|-------------|---------|------------|-----------|
| DEP-01 | Flutter SDK | ≥3.9.2 | Crítica | Google |
| DEP-02 | Android Gradle Plugin | ≥8.0 | Crítica | Google |
| DEP-03 | R8 | Latest (via AGP) | Crítica | Google |
| DEP-04 | Xcode | ≥15 | Alta | Apple |
| DEP-05 | Git LFS | ≥2.0 | Media | Git |
| DEP-06 | Firebase Crashlytics | Latest | Media | Google |

### 5.3. Supuestos

| ID | Supuesto | Riesgo si Inválido | Probabilidad Invalidez |
|----|----------|--------------------|-----------------------|
| SUP-01 | Equipo conoce Flutter/Dart | Retraso 1-2 semanas | Baja (5%) |
| SUP-02 | CI/CD disponible | Builds manuales requeridos | Baja (10%) |
| SUP-03 | Dispositivos testing disponibles | Testing incompleto | Media (20%) |
| SUP-04 | Firebase Crashlytics configurado | Monitoreo manual requerido | Baja (5%) |
| SUP-05 | Git repo con LFS habilitado | Storage alternativo requerido | Muy Baja (2%) |

---

## 6. Casos de Uso

### UC-01: Desarrollador Genera Build Local Ofuscado

**Actor Principal**: Desarrollador

**Precondiciones**:
- Código está commiteado
- Tests pasando
- Flutter SDK instalado

**Flujo Principal**:
1. Desarrollador ejecuta: `./scripts/build_release_obfuscated.sh`
2. Script limpia builds anteriores
3. Script ejecuta tests (unit + integration)
4. Script genera APK ofuscado para Android
5. Script genera IPA ofuscado para iOS (si en macOS)
6. Script verifica mapping files generados
7. Script archiva artifacts en `releases/v0.1.0/`
8. Script muestra resumen de tamaños y tiempos

**Postcondiciones**:
- APK/IPA listos para instalar
- Mapping files archivados
- Tiempo total ≤ 5 minutos

**Flujos Alternativos**:

**FA-01**: Tests fallan
1. En paso 3, si tests fallan
2. Script aborta con mensaje de error
3. Desarrollador arregla tests
4. Reintenta desde paso 1

**FA-02**: Build falla por ProGuard
1. En paso 4, si R8 reporta ClassNotFoundException
2. Script muestra error con clase faltante
3. Desarrollador añade regla a proguard-rules.pro
4. Reintenta desde paso 1

---

### UC-02: DevOps Genera Release para Producción

**Actor Principal**: DevOps Engineer

**Precondiciones**:
- Tag de versión creado (ej. v0.2.0)
- CI/CD configurado
- Secrets de firmas configurados

**Flujo Principal**:
1. DevOps crea tag: `git tag v0.2.0`
2. DevOps push tag: `git push origin v0.2.0`
3. GitHub Actions se activa automáticamente
4. Action ejecuta `build_release_obfuscated.sh`
5. Action sube APK/IPA a artifacts
6. Action sube mapping files a artifacts
7. Action commitea mapping files a repo
8. DevOps descarga APK/IPA de artifacts
9. DevOps distribuye via Play Store / TestFlight

**Postcondiciones**:
- APK/IPA en Play Store / TestFlight
- Mapping files en Git
- Símbolos en Firebase Crashlytics

**Flujos Alternativos**:

**FA-01**: Build falla en CI
1. En paso 4, si build falla
2. DevOps recibe notificación por email
3. DevOps revisa logs de GitHub Actions
4. DevOps identifica problema (ej. keystore expirado)
5. DevOps arregla problema
6. Reintenta desde paso 1

---

### UC-03: Security Analyst Audita Nivel de Ofuscación

**Actor Principal**: Security Analyst

**Precondiciones**:
- APK de release disponible
- Herramientas de análisis instaladas (APKTool, jadx-gui)

**Flujo Principal**:
1. Analyst descarga APK de release
2. Analyst extrae APK: `apktool d app-release.apk`
3. Analyst inspecciona libapp.so con strings
4. Analyst verifica nombres de clases ofuscados
5. Analyst calcula % de símbolos ofuscados
6. Analyst intenta des-compilar con jadx-gui
7. Analyst estima tiempo para reverse engineering
8. Analyst genera reporte de seguridad

**Postcondiciones**:
- Reporte de seguridad generado
- Nivel de ofuscación cuantificado (1-10)
- Recomendaciones de mejora (si aplica)

**Criterio de Éxito**:
- Nivel de seguridad ≥8/10
- ≥95% de símbolos ofuscados
- Tiempo estimado de reversa ≥80 horas

---

### UC-04: Desarrollador Des-ofusca Crash de Producción

**Actor Principal**: Desarrollador

**Precondiciones**:
- Crash reportado en Firebase Crashlytics
- Mapping files disponibles para versión afectada

**Flujo Principal**:
1. Desarrollador abre Firebase Console
2. Desarrollador copia stack trace ofuscado
3. Desarrollador guarda en archivo: `crash.txt`
4. Desarrollador ejecuta: `./scripts/deobfuscate.sh v0.1.0 crash.txt`
5. Script identifica versión y carga mapping files
6. Script des-ofusca stack trace con flutter symbolize
7. Script genera: `crash_deobfuscated.txt`
8. Desarrollador lee stack trace con nombres originales
9. Desarrollador identifica bug y crea fix

**Postcondiciones**:
- Stack trace legible
- Bug identificado
- Fix implementado

**Tiempo Total**: < 5 minutos

**Flujos Alternativos**:

**FA-01**: Mapping files no encontrados
1. En paso 5, si mapping files no existen
2. Script muestra error: "Mapping files for v0.1.0 not found"
3. Desarrollador verifica que versión fue archivada
4. Si no archivada, des-ofuscación imposible
5. Desarrollador intenta inferir bug del contexto

---

## 7. Criterios de Aceptación

### 7.1. Criterios de Aceptación Global

El sistema será aceptado cuando **TODOS** los siguientes criterios se cumplan:

#### Funcionalidad

- [ ] **CA-G-01**: RF-01 a RF-06 implementados y verificados
- [ ] **CA-G-02**: 100% de test suite pasando (unit + integration + widget)
- [ ] **CA-G-03**: 0 crashes en testing manual (checklist de 50+ casos)
- [ ] **CA-G-04**: Todas las features de Note Keeper operativas

#### Performance

- [ ] **CA-G-05**: Build time ≤ 5 minutos (full build)
- [ ] **CA-G-06**: APK reducido ≥25% vs. baseline
- [ ] **CA-G-07**: IPA reducido ≥20% vs. baseline
- [ ] **CA-G-08**: App inicia en < 3 segundos

#### Seguridad

- [ ] **CA-G-09**: Nivel de ofuscación ≥8/10 (auditoría externa)
- [ ] **CA-G-10**: ≥95% de símbolos renombrados
- [ ] **CA-G-11**: Tiempo estimado de reversa ≥80 horas
- [ ] **CA-G-12**: No strings sensibles en texto plano

#### Mantenibilidad

- [ ] **CA-G-13**: Documentación completa (todos los docs creados)
- [ ] **CA-G-14**: Scripts automatizados funcionando
- [ ] **CA-G-15**: Troubleshooting guide con ≥10 problemas
- [ ] **CA-G-16**: Training completado (equipo capacitado)

#### Compatibilidad

- [ ] **CA-G-17**: Testing en Android 7.0, 10, 14 exitoso
- [ ] **CA-G-18**: Testing en iOS 13, 15, 17 exitoso
- [ ] **CA-G-19**: Testing en ≥6 dispositivos físicos
- [ ] **CA-G-20**: Cumplimiento Play Store/App Store verificado

### 7.2. Criterios de Aceptación por Fase

#### Fase 1: Setup Básico (Días 1-2)

- [ ] **CA-F1-01**: Flutter obfuscation configurado
- [ ] **CA-F1-02**: APK ofuscado genera exitosamente
- [ ] **CA-F1-03**: Símbolos de Flutter generados
- [ ] **CA-F1-04**: App funciona en dispositivo real

#### Fase 2: R8 y ProGuard (Días 3-6)

- [ ] **CA-F2-01**: minifyEnabled = true configurado
- [ ] **CA-F2-02**: proguard-rules.pro completo
- [ ] **CA-F2-03**: Build exitoso con R8
- [ ] **CA-F2-04**: 0 ClassNotFoundException
- [ ] **CA-F2-05**: mapping.txt generado

#### Fase 3: iOS Symbol Stripping (Día 7)

- [ ] **CA-F3-01**: STRIP_INSTALLED_PRODUCT = YES
- [ ] **CA-F3-02**: dSYM generado
- [ ] **CA-F3-03**: IPA reducido ≥20%
- [ ] **CA-F3-04**: App funciona en iPhone real

#### Fase 4: Testing (Días 8-10)

- [ ] **CA-F4-01**: Test suite completo pasando
- [ ] **CA-F4-02**: Testing manual completado
- [ ] **CA-F4-03**: Testing en ≥3 Android devices
- [ ] **CA-F4-04**: Testing en ≥2 iOS devices
- [ ] **CA-F4-05**: Crash testing y des-ofuscación OK

#### Fase 5: Automatización (Días 11-13)

- [ ] **CA-F5-01**: build_release_obfuscated.sh completo
- [ ] **CA-F5-02**: deobfuscate.sh completo
- [ ] **CA-F5-03**: Scripts ejecutan sin errores
- [ ] **CA-F5-04**: Integración con archive_release.sh

#### Fase 6: Documentación (Días 14-15)

- [ ] **CA-F6-01**: Todos los documentos creados (6 docs)
- [ ] **CA-F6-02**: README actualizado
- [ ] **CA-F6-03**: Troubleshooting guide completa
- [ ] **CA-F6-04**: Training session realizada

### 7.3. Definición de "Hecho" (Definition of Done)

Una feature/fase está **HECHA** cuando:

1. **Código**:
   - [ ] Implementado según especificación
   - [ ] Code review aprobado
   - [ ] Sin warnings de `flutter analyze`
   - [ ] Formateado con `dart format`

2. **Testing**:
   - [ ] Unit tests escritos y pasando
   - [ ] Integration tests escritos y pasando
   - [ ] Manual testing completado
   - [ ] 0 bugs conocidos

3. **Documentación**:
   - [ ] Código documentado (comentarios)
   - [ ] README actualizado (si aplica)
   - [ ] Troubleshooting actualizado (si aplica)
   - [ ] CHANGELOG actualizado

4. **Operación**:
   - [ ] Build automatizado funciona
   - [ ] Mapping files archivados
   - [ ] Verificado en dispositivo real
   - [ ] Equipo entrenado (si aplica)

---

## 8. Aprobaciones

### Firmas de Aprobación

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Technical Lead | _____________ | _____________ | ___/___/2025 |
| Security Engineer | _____________ | _____________ | ___/___/2025 |
| QA Lead | _____________ | _____________ | ___/___/2025 |
| Product Manager | _____________ | _____________ | ___/___/2025 |
| DevOps Lead | _____________ | _____________ | ___/___/2025 |

### Control de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-10-11 | Claude AI | Versión inicial del SRS |

---

**Documento creado**: 2025-10-11
**Próxima revisión**: 2026-01-11 (trimestral)
**Metodología**: IEEE 830-1998
**Estado**: Aprobado para Implementación
