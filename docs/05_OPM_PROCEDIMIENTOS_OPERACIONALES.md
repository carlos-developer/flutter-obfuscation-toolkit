# OPM - Operations & Procedures Manual
## Manual de Procedimientos Operacionales

> **Manual de Procedimientos Operacionales**
>
> Proyecto: Note Keeper - Seguridad de Código
> Fecha: 2025-10-11
> Versión: 1.0.0

---

## 📋 Tabla de Contenidos

1. [Introducción](#1-introducción)
2. [Procedimientos Diarios](#2-procedimientos-diarios)
3. [Procedimiento de Release](#3-procedimiento-de-release)
4. [Monitoreo y Alertas](#4-monitoreo-y-alertas)
5. [Troubleshooting Guide](#5-troubleshooting-guide)
6. [Maintenance](#6-maintenance)
7. [Respaldo y Recuperación](#7-respaldo-y-recuperación)

---

## 1. Introducción

### 1.1. Propósito

Este manual describe los procedimientos operacionales para mantener el sistema de minificación y ofuscación de Note Keeper.

### 1.2. Audiencia

- DevOps Engineers
- Desarrolladores Senior
- Technical Leads
- Soporte de Producción

### 1.3. Procedimientos Cubiertos

- Build de releases ofuscados
- Des-ofuscación de crashes
- Monitoreo de métricas
- Troubleshooting de problemas comunes
- Mantenimiento de mapping files

---

## 2. Procedimientos Diarios

### 2.1. PROC-001: Build de Desarrollo Local

**Frecuencia**: Cada vez que se necesita probar build ofuscado

**Responsable**: Desarrollador

**Pasos**:

```bash
# 1. Verificar que cambios están commiteados
git status
# Expected: Working tree clean

# 2. Ejecutar tests
flutter test
# Expected: All tests passed

# 3. Build ofuscado
./scripts/build_release_obfuscated.sh

# 4. Instalar en dispositivo
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# 5. Testing manual rápido (5 min)
# - Crear nota
# - Editar nota
# - Eliminar nota
# - Buscar nota
```

**Tiempo Estimado**: 10-15 minutos

**Salida Esperada**: APK instalado y funcional

---

### 2.2. PROC-002: Verificar Tamaño de APK/IPA

**Frecuencia**: Después de cada build

**Responsable**: Desarrollador/DevOps

**Comando**:
```bash
# APK
du -h build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# IPA (si en macOS)
du -h build/ios/ipa/Runner.ipa
```

**Thresholds**:
- APK: ≤ 11.3 MB ✅
- APK: 11.3-12 MB ⚠️ (investigar)
- APK: > 12 MB ❌ (problema)

**Acción si excede**:
1. Revisar assets añadidos recientemente
2. Verificar que shrinkResources = true
3. Analizar con APK Analyzer

---

### 2.3. PROC-003: Verificar Tests Pasando

**Frecuencia**: Antes de cada commit

**Responsable**: Desarrollador

**Comando**:
```bash
# Tests unitarios
flutter test

# Expected output:
# 00:05 +50: All tests passed!
```

**Si algún test falla**:
```bash
# Ver detalles del fallo
flutter test --reporter expanded

# Corregir test o código
# Reintenta

r hasta que todos pasen
```

---

## 3. Procedimiento de Release

### 3.1. PROC-004: Release a Producción (Completo)

**Frecuencia**: Cada release (1-2 semanas)

**Responsable**: DevOps Lead

**Duración**: 2-3 horas

**Pre-requisitos**:
- [ ] Todos los tests pasando
- [ ] Code review completado
- [ ] versión incrementada en pubspec.yaml
- [ ] CHANGELOG.md actualizado

**Pasos**:

#### Paso 1: Preparación (10 min)

```bash
# 1.1. Verificar versión
grep "version:" pubspec.yaml
# Expected: version: 0.2.0

# 1.2. Verificar tag no existe
git tag | grep v0.2.0
# Expected: Sin output (tag no existe aún)

# 1.3. Verificar rama correcta
git branch --show-current
# Expected: main o release/v0.2.0

# 1.4. Pull latest
git pull origin main
```

#### Paso 2: Build Ofuscado (15 min)

```bash
# 2.1. Limpiar builds anteriores
flutter clean
rm -rf build/

# 2.2. Build automatizado
./scripts/build_release_obfuscated.sh

# 2.3. Verificar éxito
echo $?
# Expected: 0 (sin errores)

# 2.4. Verificar artifacts generados
ls -lh build/app/outputs/flutter-apk/
ls -lh build/app/outputs/mapping/release/
ls -lh build/app/outputs/symbols/

# Expected: APKs, mapping.txt, *.symbols
```

#### Paso 3: Testing Pre-Release (30 min)

```bash
# 3.1. Instalar en dispositivo de prueba
adb devices
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# 3.2. Testing manual (checklist en TVP documento)
# - Funcionalidad core (10 min)
# - Casos edge (10 min)
# - Performance (10 min)

# 3.3. Documentar resultados
# Crear archivo: test_results_v0.2.0.md
```

#### Paso 4: Archivar Artifacts (5 min)

```bash
# 4.1. Archivar (ejecutado por build script)
# Ya ejecutado en paso 2.2

# 4.2. Verificar archivado
ls -lh releases/v0.2.0/
# Expected: apks/, mapping/, symbols/

# 4.3. Verificar checksums
cat releases/v0.2.0/checksums.txt
```

#### Paso 5: Commit Mapping Files (5 min)

```bash
# 5.1. Añadir releases/
git add releases/v0.2.0/

# 5.2. Commit
git commit -m "release: Archive mapping files for v0.2.0

Generated mapping files and symbols for production release v0.2.0

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# 5.3. Push
git push origin main
```

#### Paso 6: Crear Tag (2 min)

```bash
# 6.1. Crear tag anotado
git tag -a v0.2.0 -m "Release v0.2.0

Features:
- Feature 1
- Feature 2

Security:
- Obfuscated build with R8
- 30% size reduction"

# 6.2. Push tag
git push origin v0.2.0
```

#### Paso 7: Upload a Firebase Crashlytics (5 min)

```bash
# 7.1. Upload Android mapping
firebase crashlytics:symbols:upload \
  --app=1:123456:android:abc \
  releases/v0.2.0/mapping/mapping.txt

# 7.2. Upload iOS dSYM (si aplica)
firebase crashlytics:symbols:upload \
  --app=1:123456:ios:xyz \
  releases/v0.2.0/symbols/Runner.app.dSYM

# 7.3. Verificar en Firebase Console
open https://console.firebase.google.com/project/note-keeper/crashlytics
```

#### Paso 8: Upload a Play Store (30 min)

**Via Play Console**:
1. Abrir https://play.google.com/console
2. Seleccionar Note Keeper
3. Producción → Crear nueva versión
4. Upload APKs:
   - app-armeabi-v7a-release.apk
   - app-arm64-v8a-release.apk
   - app-x86_64-release.apk
5. Añadir notas de versión (desde CHANGELOG.md)
6. Guardar → Revisar → Publicar

#### Paso 9: Upload a TestFlight (30 min)

**Via App Store Connect**:
1. Abrir https://appstoreconnect.apple.com
2. Seleccionar Note Keeper
3. TestFlight → Builds
4. Upload IPA (vía Xcode Organizer)
5. Esperar procesamiento (~15 min)
6. Añadir a grupo de testing
7. Submit for review (si es primer build)

#### Paso 10: Post-Release Monitoring (continuo)

```bash
# 10.1. Monitorear Firebase Crashlytics
# Ver dashboard cada hora primeras 24h

# 10.2. Monitorear Play Console
# Revisar crash rate, ANRs

# 10.3. Monitorear user feedback
# Revisar reviews en Play Store/App Store
```

**Checklist Final**:
- [ ] APKs subidos a Play Store
- [ ] IPA subido a TestFlight
- [ ] Mapping files commiteados a Git
- [ ] Mapping files subidos a Firebase
- [ ] Tag creado y pusheado
- [ ] Monitoring activado
- [ ] Equipo notificado

---

## 4. Monitoreo y Alertas

### 4.1. PROC-005: Monitoreo Diario de Crashes

**Frecuencia**: Diario (primeros 7 días post-release), luego semanal

**Responsable**: DevOps / Support

**Dashboard**: https://console.firebase.google.com/project/note-keeper/crashlytics

**Métricas a Revisar**:

| Métrica | Threshold | Acción |
|---------|-----------|--------|
| **Crash-free rate** | ≥ 99.9% ✅ | Ninguna |
| **Crash-free rate** | 99.0-99.9% ⚠️ | Investigar top crashes |
| **Crash-free rate** | < 99.0% ❌ | Hotfix urgente |
| **Crashes nuevos** | 0 ✅ | Ninguna |
| **Crashes nuevos** | 1-5 ⚠️ | Investigar y prioritizar |
| **Crashes nuevos** | > 5 ❌ | Rollback considerar |

**Procedimiento si crash rate > 1%**:
1. Identificar top 3 crashes
2. Des-ofuscar stack traces (PROC-006)
3. Crear issues en GitHub
4. Prioritizar fixes
5. Evaluar hotfix vs. esperar próximo release

---

### 4.2. PROC-006: Des-ofuscar Crash de Producción

**Frecuencia**: Cuando sea necesario

**Responsable**: Desarrollador on-call

**Duración**: 5-10 minutos

**Pasos**:

```bash
# 1. Abrir Firebase Crashlytics
open https://console.firebase.google.com/.../crashlytics

# 2. Seleccionar crash
# Click en crash → Ver detalles

# 3. Copiar stack trace
# Si está des-ofuscado automáticamente ✅ (skip resto)
# Si está ofuscado (símbolos a.b.c) → continuar

# 4. Guardar stack trace
cat > crash_prod.txt << 'EOF'
Exception: xxx
    at a.b.c(Unknown Source)
    at d.e.f(Unknown Source:42)
EOF

# 5. Identificar versión del crash
VERSION="v0.2.0"  # Desde crash report

# 6. Des-ofuscar
./scripts/deobfuscate.sh $VERSION crash_prod.txt

# 7. Analizar stack trace legible
cat crash_deobfuscated.txt

# Expected output:
# Exception: xxx
#     at NoteRepository.getAllNotes(note_repository.dart:42)
#     at NoteListViewModel.loadNotes(note_list_viewmodel.dart:27)

# 8. Identificar bug y crear issue
# Ejemplo: Bug en getAllNotes línea 42
```

**Troubleshooting**:

**Error: "Mapping files not found"**
```bash
# Verificar que mappings fueron archivados
ls releases/$VERSION/mapping/

# Si no existen, des-ofuscación imposible
# Lección: SIEMPRE archivar mapping files
```

---

### 4.3. PROC-007: Alertas Automáticas

**Configurar alertas en Firebase**:

1. Abrir Firebase Console → Alertas
2. Crear alerta:
   - **Tipo**: Crash rate increased
   - **Threshold**: > 1%
   - **Notificar**: Email a team@example.com
   - **Frecuencia**: Immediately

3. Crear alerta:
   - **Tipo**: New crash detected
   - **Threshold**: > 5 crashes
   - **Notificar**: Slack #alerts
   - **Frecuencia**: Every 1 hour

---

## 5. Troubleshooting Guide

### 5.1. ISSUE-001: Build Falla con R8

**Síntoma**:
```
FAILURE: Build failed with an exception.
Missing class: com.example.note_keeper.models.Note
```

**Diagnóstico**:
```bash
# Ver qué clases R8 intentó eliminar
cat build/app/outputs/mapping/release/usage.txt | grep "Note"
```

**Solución**:
```proguard
# Añadir a android/app/proguard-rules.pro
-keep class com.example.note_keeper.models.Note { *; }
```

**Verificar**:
```bash
flutter clean
flutter build apk --release --obfuscate --split-debug-info=symbols
```

---

### 5.2. ISSUE-002: App Crashea Post-Ofuscación

**Síntoma**: App funciona en debug, crashea en release ofuscado

**Diagnóstico**:
```bash
# 1. Instalar APK ofuscado
adb install -r app-release.apk

# 2. Monitorear logs
adb logcat | grep -i "exception"

# 3. Capturar stack trace
adb logcat > crash_log.txt

# 4. Buscar ClassNotFoundException o NoSuchMethodError
```

**Causas Comunes**:

| Error | Causa | Solución |
|-------|-------|----------|
| ClassNotFoundException | Clase eliminada por R8 | Añadir -keep class |
| NoSuchMethodError | Método eliminado por R8 | Añadir -keepclassmembers |
| NullPointerException | Reflexión rota | Preservar clase usada vía reflexión |

**Solución General**:
1. Identificar clase/método faltante del stack trace
2. Añadir regla ProGuard específica
3. Rebuild y retest

---

### 5.3. ISSUE-003: Build Time Excesivo (> 10 min)

**Diagnóstico**:
```bash
# Medir tiempo de cada fase
time flutter clean
time flutter pub get
time flutter build apk --release --obfuscate --split-debug-info=symbols
```

**Optimizaciones**:

**Opción 1: Reducir optimization passes**
```proguard
# En proguard-rules.pro
-optimizationpasses 3  # En lugar de 5
```

**Opción 2: Deshabilitar shrinkResources temporalmente**
```kotlin
// android/app/build.gradle.kts (solo para dev)
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = false  // Deshabilitar temporalmente
    }
}
```

**Opción 3: Usar build cache**
```bash
# Habilitar cache de Gradle
export GRADLE_OPTS="-Dorg.gradle.caching=true"
```

---

### 5.4. ISSUE-004: Mapping Files Muy Grandes (> 100 MB)

**Diagnóstico**:
```bash
du -h releases/v0.2.0/mapping/
```

**Optimización**:
```bash
# Comprimir mapping files
cd releases/v0.2.0/mapping/
gzip *.txt
# mapping.txt → mapping.txt.gz (80% reducción típica)

# Actualizar Git LFS
git lfs track "*.txt.gz"
```

---

### 5.5. ISSUE-005: Firebase No Des-ofusca Automáticamente

**Diagnóstico**:
- Crash aparece en Firebase con símbolos ofuscados (a.b.c)

**Causa**: Mapping files no subidos a Firebase

**Solución**:
```bash
# 1. Verificar mapping file existe
ls releases/v0.2.0/mapping/mapping.txt

# 2. Upload manualmente
firebase crashlytics:symbols:upload \
  --app=1:123456:android:abc \
  releases/v0.2.0/mapping/mapping.txt

# 3. Esperar ~10 min para procesamiento

# 4. Verificar en Firebase Console
# Crashes deberían mostrar nombres legibles
```

---

## 6. Maintenance

### 6.1. PROC-008: Limpieza de Builds Antiguos

**Frecuencia**: Mensual

**Responsable**: DevOps

**Pasos**:
```bash
# 1. Listar releases antiguos (> 6 meses)
ls -lt releases/ | tail -10

# 2. Archivar a storage de largo plazo (opcional)
tar -czf releases_archive_2024_Q1.tar.gz releases/v0.1.0 releases/v0.1.1
aws s3 cp releases_archive_2024_Q1.tar.gz s3://note-keeper-archives/

# 3. Eliminar localmente (mantener últimos 3 releases)
# CUIDADO: Verificar que están en Git LFS
rm -rf releases/v0.1.0

# 4. Git cleanup
git add releases/
git commit -m "chore: Archive old releases"
git push
```

---

### 6.2. PROC-009: Actualización de Dependencias

**Frecuencia**: Mensual o cuando hay security updates

**Pasos**:
```bash
# 1. Actualizar Flutter SDK
flutter upgrade

# 2. Actualizar dependencias
flutter pub upgrade

# 3. Ejecutar tests
flutter test

# 4. Build de prueba ofuscado
./scripts/build_release_obfuscated.sh

# 5. Testing manual exhaustivo
# (checklist de TVP documento)

# 6. Si todo OK, commit
git add pubspec.lock
git commit -m "chore: Update dependencies"
git push
```

**Cuidado Especial**:
- Actualización de sqflite puede requerir ajustes en ProGuard rules
- Actualización de go_router puede afectar navegación

---

### 6.3. PROC-010: Auditoría de Seguridad Trimestral

**Frecuencia**: Cada 3 meses

**Responsable**: Security Team

**Checklist**:
1. [ ] Análisis de binarios (APK/IPA) con herramientas:
   - jadx-gui (decompilación)
   - APKTool (análisis estructural)
   - strings (búsqueda de texto plano)

2. [ ] Verificar métricas de ofuscación:
   - % de símbolos ofuscados ≥ 95%
   - Reducción de tamaño ≥ 25%

3. [ ] Revisar ProGuard rules:
   - ¿Hay clases preservadas innecesariamente?
   - ¿Se pueden hacer reglas más específicas?

4. [ ] Estimar tiempo de ingeniería inversa:
   - Contratar security analyst externo
   - Medir tiempo para extraer lógica core

5. [ ] Generar reporte:
   - Nivel de seguridad (1-10)
   - Vulnerabilidades encontradas
   - Recomendaciones de mejora

---

## 7. Respaldo y Recuperación

### 7.1. PROC-011: Respaldo de Mapping Files

**Frecuencia**: Después de cada release

**Responsable**: DevOps

**Estrategia**: Git LFS + S3 backup

**Pasos**:
```bash
# 1. Mapping files ya están en Git (automático via archive_release.sh)
git log --oneline | grep "release: Archive"

# 2. Backup adicional a S3 (opcional)
VERSION="v0.2.0"
tar -czf mapping_${VERSION}.tar.gz releases/$VERSION/mapping/

aws s3 cp mapping_${VERSION}.tar.gz \
  s3://note-keeper-backups/mappings/ \
  --storage-class STANDARD_IA

# 3. Verificar integridad
aws s3 ls s3://note-keeper-backups/mappings/
```

---

### 7.2. PROC-012: Recuperación de Mapping Files

**Escenario**: Mapping files perdidos localmente

**Pasos**:
```bash
# Opción 1: Desde Git
git checkout releases/v0.2.0/mapping/

# Opción 2: Desde S3 backup
aws s3 cp s3://note-keeper-backups/mappings/mapping_v0.2.0.tar.gz .
tar -xzf mapping_v0.2.0.tar.gz
```

---

### 7.3. PROC-013: Rollback de Release

**Escenario**: Release v0.2.0 tiene issue crítico

**Pasos**:

```bash
# 1. Identificar última versión estable
VERSION_STABLE="v0.1.9"

# 2. Checkout a tag estable
git checkout tags/$VERSION_STABLE

# 3. Build de emergencia
./scripts/build_release_obfuscated.sh

# 4. Upload urgente a Play Store (hotfix track)
# - Seleccionar "Release urgente"
# - Upload APKs
# - Publicar inmediatamente

# 5. Comunicar a usuarios
# - Anuncio en app (si hay sistema de notificaciones)
# - Redes sociales
# - Email a usuarios beta

# 6. Post-mortem
# - Documentar qué falló en v0.2.0
# - Por qué no se detectó en testing
# - Mejoras para prevenir en futuro
```

---

## 8. Apéndices

### 8.1. Contacts

| Rol | Nombre | Email | Slack |
|-----|--------|-------|-------|
| DevOps Lead | _________ | _________ | @_______ |
| Security Lead | _________ | _________ | @_______ |
| On-Call (Week 1) | _________ | _________ | @_______ |
| On-Call (Week 2) | _________ | _________ | @_______ |

### 8.2. Enlaces Útiles

- Firebase Crashlytics: https://console.firebase.google.com/.../crashlytics
- Play Console: https://play.google.com/console
- App Store Connect: https://appstoreconnect.apple.com
- Repositorio Git: https://github.com/.../note-keeper
- Documentación Interna: /docs/

### 8.3. Comandos Útiles Rápidos

```bash
# Build ofuscado rápido
flutter build apk --release --obfuscate --split-debug-info=symbols

# Instalar en dispositivo
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Ver logs en tiempo real
adb logcat | grep -i "note_keeper\|exception\|error"

# Tamaño de APK
du -h build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Des-ofuscar crash
./scripts/deobfuscate.sh v0.2.0 crash.txt
```

---

**Documento creado**: 2025-10-11
**Mantenido por**: DevOps Team
**Última actualización**: 2025-10-11
