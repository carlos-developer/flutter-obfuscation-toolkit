# ✅ Checklist de Ofuscación y Minificación Flutter

> Usa este checklist para validar que la implementación de ofuscación está correcta y completa

---

## 📋 Índice

1. [Configuración Inicial](#configuración-inicial)
2. [Validación Android](#validación-android)
3. [Validación iOS](#validación-ios)
4. [Scripts y Automatización](#scripts-y-automatización)
5. [Testing y Validación](#testing-y-validación)
6. [Preparación para Producción](#preparación-para-producción)
7. [CI/CD (Opcional)](#cicd-opcional)

---

## 🎯 Configuración Inicial

### Archivos Base

- [ ] `pubspec.yaml` existe y es válido
- [ ] Proyecto tiene directorio `android/`
- [ ] Proyecto tiene directorio `ios/` (si aplica)
- [ ] Flutter SDK versión ≥ 3.9.2
- [ ] Git inicializado en el proyecto

### Control de Versiones

- [ ] Branch de trabajo creado (ej: `feat/obfuscation`)
- [ ] `.gitignore` actualizado con exclusiones de ofuscación:
  ```gitignore
  # Obfuscation artifacts
  build/app/outputs/mapping/
  build/app/outputs/symbols/
  build/symbols/
  *.backup
  temp/
  ```

---

## 📱 Validación Android

### Configuración Gradle

- [ ] **`android/app/build.gradle.kts` (o `.gradle`) modificado**
  - [ ] `multiDexEnabled = true` agregado en `defaultConfig`
  - [ ] `isMinifyEnabled = true` en `release` buildType
  - [ ] `isShrinkResources = true` en `release` buildType
  - [ ] `proguardFiles` configurado correctamente

**Verificación**:
```bash
grep "minifyEnabled" android/app/build.gradle*
grep "shrinkResources" android/app/build.gradle*
grep "proguardFiles" android/app/build.gradle*
```

### Archivo ProGuard

- [ ] **`android/app/proguard-rules.pro` existe**
- [ ] Contiene reglas para Flutter core
- [ ] Contiene regla para MainActivity con **tu applicationId correcto**
- [ ] Contiene reglas para tus modelos de datos (si usas JSON)
- [ ] Contiene reglas para plugins que uses (sqflite, firebase, etc.)
- [ ] Contiene reglas para Google Play Core
- [ ] Contiene reglas para JNI, reflection, enums

**Verificación crítica**:
```bash
# Verificar que NO dice 'com.example.app'
grep "com.example" android/app/proguard-rules.pro

# Verificar que tiene TU applicationId
grep "MainActivity" android/app/proguard-rules.pro
```

### Build Android

- [ ] **Build release exitoso**:
  ```bash
  flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi
  ```

- [ ] **APKs generados** en `build/app/outputs/apk/release/`:
  - [ ] `app-armeabi-v7a-release.apk` (~12-18 MB)
  - [ ] `app-arm64-v8a-release.apk` (~13-20 MB)
  - [ ] `app-x86_64-release.apk` (~15-22 MB)

- [ ] **mapping.txt generado**:
  - [ ] Existe en `build/app/outputs/mapping/release/mapping.txt`
  - [ ] Tamaño: ~2-5 MB
  - [ ] Contiene mapeos de clases (abre y verifica contenido)

- [ ] **Símbolos Flutter generados**:
  - [ ] `build/symbols/android/app.android-arm.symbols`
  - [ ] `build/symbols/android/app.android-arm64.symbols`
  - [ ] `build/symbols/android/app.android-x64.symbols`

### Validación de Ofuscación Android

- [ ] **Verificar ofuscación en APK**:
  ```bash
  unzip -q build/app/outputs/apk/release/app-arm64-v8a-release.apk -d /tmp/apk_check
  strings /tmp/apk_check/lib/arm64-v8a/libapp.so | grep "TuClasePrincipal"
  # Resultado esperado: NO debería encontrar nombres de tus clases
  rm -rf /tmp/apk_check
  ```

- [ ] **Reducción de tamaño ≥ 50%**:
  - Baseline (sin R8): ~40-50 MB
  - Con R8: ~13-20 MB
  - Reducción: ≥ 60%

---

## 🍎 Validación iOS

### Configuración Xcode

- [ ] **`ios/Runner.xcodeproj/project.pbxproj` modificado**

- [ ] **Configuración Release** contiene:
  - [ ] `DEAD_CODE_STRIPPING = YES;`
  - [ ] `DEPLOYMENT_POSTPROCESSING = YES;`
  - [ ] `STRIP_INSTALLED_PRODUCT = YES;`
  - [ ] `STRIP_STYLE = "non-global";`
  - [ ] `STRIP_SWIFT_SYMBOLS = YES;`
  - [ ] `SYMBOLS_HIDDEN_BY_DEFAULT = YES;`
  - [ ] `DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";`

- [ ] **Configuración Profile** contiene las mismas settings

**Verificación**:
```bash
grep "STRIP_INSTALLED_PRODUCT" ios/Runner.xcodeproj/project.pbxproj
grep "DEAD_CODE_STRIPPING" ios/Runner.xcodeproj/project.pbxproj
```

### Build iOS

⚠️ **Nota**: Si tienes Xcode 16.2, este build puede fallar (bug conocido). Usa Xcode 15.x o CI/CD.

- [ ] **Build release exitoso**:
  ```bash
  flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios
  ```

- [ ] **Símbolos Flutter generados**:
  - [ ] `build/symbols/ios/app.ios-arm64.symbols`

- [ ] **dSYM generado** (si aplica):
  - [ ] Existe en `build/ios/archive/Runner.xcarchive/dSYMs/`

---

## 🔧 Scripts y Automatización

### Scripts Creados

- [ ] **`scripts/build_release_obfuscated.sh` existe**
  - [ ] Es ejecutable: `chmod +x scripts/build_release_obfuscated.sh`
  - [ ] Ejecuta correctamente: `./scripts/build_release_obfuscated.sh`
  - [ ] Muestra logs con colores
  - [ ] Genera reporte de artefactos
  - [ ] Valida existencia de archivos críticos

- [ ] **`scripts/deobfuscate.sh` existe**
  - [ ] Es ejecutable: `chmod +x scripts/deobfuscate.sh`
  - [ ] Muestra ayuda: `./scripts/deobfuscate.sh -h`
  - [ ] Soporta Android (ReTrace)
  - [ ] Soporta iOS (flutter symbolize)

### Verificación de Scripts

- [ ] **Build script funciona**:
  ```bash
  ./scripts/build_release_obfuscated.sh
  # Debe completar sin errores
  ```

- [ ] **Deobfuscate script funciona** (prueba con stack trace de ejemplo):
  ```bash
  echo "com.example.a.b.c" > test_crash.txt
  ./scripts/deobfuscate.sh -p android -s test_crash.txt
  rm test_crash.txt
  ```

---

## 🧪 Testing y Validación

### Testing en Dispositivo Físico

- [ ] **App instalada en dispositivo físico**:
  ```bash
  flutter install --release
  ```

- [ ] **Funcionalidades críticas verificadas**:
  - [ ] Login/autenticación funciona
  - [ ] Persistencia de datos funciona
  - [ ] Llamadas a API funcionan
  - [ ] Navegación funciona correctamente
  - [ ] Plugins funcionan (cámara, localización, etc.)
  - [ ] NO hay crashes al abrir la app
  - [ ] NO hay crashes en uso normal

### Validación de Crashes

Si la app crashea después de ofuscar:

- [ ] **Stack trace obtenido** del crash
- [ ] **Desobfuscado con script**:
  ```bash
  ./scripts/deobfuscate.sh -p android -s crash.txt
  ```
- [ ] **Clase faltante identificada**
- [ ] **Regla ProGuard agregada** para esa clase
- [ ] **Rebuild realizado**
- [ ] **Crash resuelto**

---

## 🚀 Preparación para Producción

### Archivos de Mapeo

- [ ] **Directorio `releases/` creado**:
  ```bash
  mkdir -p releases/v1.0.0
  ```

- [ ] **mapping.txt archivado**:
  ```bash
  cp build/app/outputs/mapping/release/mapping.txt releases/v1.0.0/
  ```

- [ ] **Símbolos archivados**:
  ```bash
  cp -r build/symbols/ releases/v1.0.0/
  ```

- [ ] **Documentación de versión creada**:
  ```bash
  echo "Build: $(date)" > releases/v1.0.0/README.txt
  echo "Flutter: $(flutter --version | head -1)" >> releases/v1.0.0/README.txt
  echo "Build number: XXX" >> releases/v1.0.0/README.txt
  ```

### Build Numbers

- [ ] **Build number incrementado** en cada release
- [ ] **Version name actualizado** en `pubspec.yaml`
- [ ] **Version code actualizado** en `android/app/build.gradle.kts`

### Documentación

- [ ] **CHANGELOG.md actualizado** con esta release
- [ ] **README.md actualizado** (si aplica)
- [ ] **Commit creado** con mensaje descriptivo:
  ```bash
  git add .
  git commit -m "feat(security): Implementar ofuscación y optimización de tamaño

  - Habilitar R8/ProGuard (Android)
  - Configurar symbol stripping (iOS)
  - Agregar scripts de automatización
  - Reducción de tamaño: 65%

  Ref: #123"
  ```

---

## 🔄 CI/CD (Opcional)

Si usas CI/CD (GitHub Actions, GitLab CI, etc.):

### Configuración CI/CD

- [ ] **Workflow configurado** para builds de release
- [ ] **Flutter instalado** en CI
- [ ] **Build con ofuscación ejecutado**:
  ```yaml
  - run: flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi
  ```

- [ ] **Artefactos archivados**:
  - [ ] APKs/IPAs
  - [ ] mapping.txt
  - [ ] Símbolos Flutter

- [ ] **Build number auto-incrementado** (ej: usando `${{ github.run_number }}`)

### Firebase Crashlytics (si aplica)

- [ ] **Crashlytics configurado** en el proyecto
- [ ] **mapping.txt subido automáticamente** en cada release:
  ```bash
  firebase crashlytics:symbols:upload \
    --app=YOUR_APP_ID \
    build/app/outputs/mapping/release
  ```

- [ ] **Símbolos Flutter subidos**:
  ```bash
  firebase crashlytics:symbols:upload \
    --app=YOUR_APP_ID \
    build/symbols/android
  ```

---

## 📊 Métricas de Validación

### Tamaños Esperados

| Artefacto | Tamaño Esperado | Tu Proyecto |
|-----------|-----------------|-------------|
| APK arm64 | 13-20 MB | _____ MB |
| APK armv7 | 12-18 MB | _____ MB |
| mapping.txt | 2-5 MB | _____ MB |
| Símbolos (.symbols) | 500 KB - 2 MB cada uno | _____ MB |

### Reducción de Tamaño

| Métrica | Objetivo | Tu Proyecto |
|---------|----------|-------------|
| Reducción vs baseline | ≥ 60% | _____ % |
| Build time overhead | ≤ +50% | _____ % |
| Security score | ≥ 8/10 | _____ /10 |

### Performance

- [ ] **Tiempo de build con ofuscación**: ≤ 2 minutos
- [ ] **App no tiene slowdowns** vs versión debug
- [ ] **Tamaño de instalación** reducido significativamente

---

## 🎓 Checklist Final

Antes de mergear a main/producción:

- [ ] **Todas las secciones anteriores completadas** ✅
- [ ] **Testing exhaustivo realizado** en dispositivos físicos
- [ ] **Sin crashes conocidos** en funcionalidades críticas
- [ ] **Archivos de mapeo archivados** para esta versión
- [ ] **Documentación actualizada**
- [ ] **Commit creado** con mensaje descriptivo
- [ ] **Branch pusheado** para revisión
- [ ] **Pull Request creado** (si aplica)
- [ ] **Revisión de código solicitada** (si aplica)

---

## 📝 Notas y Observaciones

Usa este espacio para anotar issues encontrados o configuraciones específicas:

```
Fecha: ___________
Version: ___________

Notas:
-
-
-
```

---

## 🆘 Troubleshooting Rápido

### ❌ Build falla con "Missing class X"

**Solución**: Agrega en `proguard-rules.pro`:
```proguard
-dontwarn nombre.del.paquete.**
-keep class nombre.del.paquete.** { *; }
```

### ❌ App crashea en producción

**Solución**:
1. Obtén stack trace del crash
2. Desobfusca: `./scripts/deobfuscate.sh -p android -s crash.txt`
3. Agrega clase en `proguard-rules.pro`

### ❌ APK sigue siendo grande

**Solución**:
- Verifica que `minifyEnabled = true`
- Verifica que usaste `--split-per-abi`
- Revisa assets grandes en `assets/`

### ❌ iOS build falla (Xcode 16.2)

**Solución**: Bug conocido. Usa Xcode 15.x o CI/CD con Xcode 15.x

---

**Última actualización**: 2025-10-11
**Versión**: 1.0.0
**Template para**: Flutter ≥ 3.9.2
