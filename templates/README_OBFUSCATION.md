# Referencia Rápida - Ofuscación y Minificación

> Guía de consulta rápida para mantener la ofuscación en tu proyecto Flutter

---

## Comandos Esenciales

### Build con Ofuscación

```bash
# Build completo (Android + iOS)
./scripts/build_release_obfuscated.sh

# Solo Android
flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi

# Solo iOS
flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios
```

### Desobfuscar Crashes

```bash
# Android
./scripts/deobfuscate.sh -p android -s crash.txt

# iOS
./scripts/deobfuscate.sh -p ios -s crash.txt
```

---

## Archivos Críticos (NO BORRAR)

| Archivo | Propósito | Cuándo se Genera |
|---------|-----------|------------------|
| `build/app/outputs/mapping/release/mapping.txt` | Mapeo R8 (Android) | Cada build release Android |
| `build/symbols/android/*.symbols` | Símbolos Dart (Android) | Cada build con `--obfuscate` |
| `build/symbols/ios/*.symbols` | Símbolos Dart (iOS) | Cada build con `--obfuscate` |
| `android/app/proguard-rules.pro` | Reglas ProGuard | Una vez (editar según cambios) |

---

## Flujo de Trabajo Recomendado

### 1. Desarrollo Diario
```bash
# Usa debug (sin ofuscación, más rápido)
flutter run
```

### 2. Testing Pre-Release
```bash
# Build con ofuscación para probar
./scripts/build_release_obfuscated.sh

# Prueba en dispositivo físico
flutter install --release
```

### 3. Release a Producción
```bash
# Build final
./scripts/build_release_obfuscated.sh

# Archivar archivos de mapeo
mkdir -p releases/v1.2.3
cp build/app/outputs/mapping/release/mapping.txt releases/v1.2.3/
cp -r build/symbols/ releases/v1.2.3/
```

---

## Troubleshooting Rápido

### App crashea después de ofuscación

**Causa**: R8 eliminó código necesario (reflection, JSON serialization)

**Solución**:
1. Obtén el stack trace del crash
2. Desobfusca: `./scripts/deobfuscate.sh -p android -s crash.txt`
3. Identifica la clase faltante
4. Agrega en `android/app/proguard-rules.pro`:
   ```proguard
   -keep class com.miapp.MiClase { *; }
   ```
5. Rebuild

### Build falla con "Missing class X"

**Solución**: Agrega en `proguard-rules.pro`:
```proguard
-dontwarn nombre.del.paquete.**
-keep class nombre.del.paquete.** { *; }
```

### APK sigue siendo grande

**Verificar**:
```bash
# ¿Usaste --split-per-abi?
ls -lh build/app/outputs/apk/release/

# ¿R8 está habilitado?
grep "minifyEnabled" android/app/build.gradle*
```

---

## Reglas ProGuard para Casos Comunes

### Modelos de Datos (JSON)
```proguard
# Preservar tus modelos
-keep class com.miapp.models.** { *; }
-keepclassmembers class com.miapp.models.** {
    public <init>(...);
    public <fields>;
}
```

### Plugins con Código Nativo
```proguard
# Ejemplo: sqflite
-keep class com.tekartik.sqflite.** { *; }

# Ejemplo: firebase
-keep class io.flutter.plugins.firebase.** { *; }
```

### Reflection/Introspection
```proguard
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
```

---

## Checklist Pre-Release

- [ ] Build exitoso con `./scripts/build_release_obfuscated.sh`
- [ ] APKs generados (13-17 MB cada uno)
- [ ] `mapping.txt` generado (~3-5 MB)
- [ ] Símbolos Flutter generados (3 archivos .symbols)
- [ ] App probada en dispositivo físico
- [ ] Funcionalidades críticas verificadas:
  - [ ] Login/autenticación
  - [ ] Persistencia de datos
  - [ ] Llamadas a API
  - [ ] Navegación
- [ ] Archivos de mapeo archivados en `releases/vX.Y.Z/`
- [ ] Build number incrementado

---

## Integración con CI/CD

### GitHub Actions Ejemplo

```yaml
- name: Build Release con Ofuscación
  run: |
    flutter build apk \
      --release \
      --obfuscate \
      --split-debug-info=build/symbols/android \
      --split-per-abi \
      --build-number=${{ github.run_number }}

- name: Archivar mapping files
  uses: actions/upload-artifact@v3
  with:
    name: mapping-files-${{ github.run_number }}
    path: |
      build/app/outputs/mapping/release/mapping.txt
      build/symbols/
```

---

## Métricas Esperadas

| Métrica | Baseline | Con Ofuscación | Objetivo |
|---------|----------|----------------|----------|
| APK arm64 | ~40 MB | ~15 MB | 60-65% reducción |
| APK armv7 | ~35 MB | ~12 MB | 65-70% reducción |
| Build time | ~20s | ~30s | +50% overhead |
| Security | 3/10 | 8/10 | ≥8/10 |

---

## Recursos

- **Documentación completa**: `MIGRATION_GUIDE.md`
- **Guía técnica detallada**: `docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md`
- **Procedimientos operacionales**: `docs/05_OPM_PROCEDIMIENTOS_OPERACIONALES.md`
- **Métricas del proyecto**: `METRICAS_IMPLEMENTACION.md`

- **Flutter Docs**: https://docs.flutter.dev/deployment/obfuscate
- **Android R8**: https://developer.android.com/studio/build/shrink-code
- **ProGuard Manual**: https://www.guardsquare.com/manual/home

---

## Mantenimiento

### Cuando agregues nuevo código

1. **Nuevos modelos de datos**: Agrega reglas en `proguard-rules.pro`
2. **Nuevos plugins**: Revisa si necesitan reglas ProGuard
3. **Código con reflection**: Preserva con `-keep`

### Cada Release

1. **Incrementa build number**
2. **Archiva mapping files** en `releases/vX.Y.Z/`
3. **Prueba en dispositivos físicos**
4. **Verifica métricas de tamaño**

---

Última actualización: 2025-10-11
Versión: 1.0.0
