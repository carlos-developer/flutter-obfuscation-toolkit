# 🤖 Prompts para Agentes IA - Flutter Obfuscation Toolkit

> Prompts detallados para implementar ofuscación y optimización de tamaño en proyectos Flutter con validación técnica completa

**Repositorio oficial**: `https://github.com/carlos-developer/flutter-obfuscation-toolkit`

---

## 📋 Índice de Prompts

1. [Prompt Detallado: Android + iOS](#1-prompt-detallado-android--ios) - Implementación completa con validación técnica
2. [Prompt Detallado: Solo Android](#2-prompt-detallado-solo-android) - R8 + ProGuard con validación
3. [Prompt Detallado: Solo iOS](#3-prompt-detallado-solo-ios) - Symbol Stripping con validación
4. [Prompt Detallado: Verificación](#4-prompt-detallado-verificación) - Validación técnica completa

---

## 🎯 Instrucciones de Uso

1. Selecciona el prompt según tu necesidad (Android, iOS, o ambas plataformas)
2. Copia el prompt completo
3. Pégalo en tu agente IA (Claude Code, Gemini, Cursor, etc.)
4. El agente sigue las instrucciones paso a paso con validación técnica
5. Validación automática al finalizar

---

## 🤖 Archivos para Agentes IA

Este toolkit incluye archivos específicos para que los agentes IA procesen las instrucciones de forma estructurada:

### 📜 MIGRATION_GUIDE.md
**URL**: `https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md`

**Propósito**: Guía paso a paso en lenguaje natural (para humanos y agentes).

**Contiene**:
- Instrucciones detalladas por plataforma
- Ejemplos de código completos
- Explicaciones del "por qué" de cada paso
- Troubleshooting integrado
- Las 8 reglas de trazabilidad para agentes IA

**Cuándo usarlo**:
- ✅ Primera vez implementando el toolkit
- ✅ Necesitas entender el contexto de cada paso
- ✅ Lectura humana + ejecución por agente IA
- ✅ Referencia rápida

### 🔍 VALIDATION_GUIDE.md
**URL**: `https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md`

**Propósito**: Guía completa de validación técnica de ofuscación.

**Contiene**:
- Validación automática (validate-implementation.sh)
- Validación manual por plataforma
- **Validación técnica profunda** (inspección de binarios)
- Interpretación de resultados
- Checklist final antes de producción

### 🔍 validate-implementation.sh
**URL**: `https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh`

**Propósito**: Script de validación automática que detecta plataformas configuradas y valida cada una.

**Ejecución**:
```bash
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
```

**Qué valida**:
- **FASE 1**: Detecta qué plataformas (Android/iOS) fueron configuradas
- **FASE 2**: Valida archivos de configuración
- **FASE 3**: Ejecuta builds de todas las plataformas detectadas
- **FASE 4**: **Valida técnicamente que la ofuscación funciona** (CRÍTICO):
  - Android: R8 activo, mapping.txt >10k líneas, clases removidas, nombres Dart NO visibles en libapp.so
  - iOS: Binario stripped, tamaño optimizado, símbolos separados, nm falla
- Retorna exit code 0 solo si TODO pasó

**CRÍTICO para agentes IA**:
Este script DEBE ejecutarse antes de generar el registro de auditoría final (REGLA 7).
Ver documentación completa en: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

---

## 🔗 Relación entre los archivos

```
┌─────────────────────────────────────┐
│  Usuario copia prompt               │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Agente IA lee:                     │
│  1. RULES.md (8 reglas)             │
│  2. MIGRATION_GUIDE.md (pasos)      │
│  3. VALIDATION_GUIDE.md (validación)│
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Agente ejecuta implementación      │
│  siguiendo 8 reglas de trazabilidad │
└────────────┬────────────────────────┘
             ↓
┌──────────────────────────────────────────────┐
│  Agente ejecuta validate-implementation.sh   │
│  (FASE 4: Validación técnica de ofuscación)  │
└────────────┬─────────────────────────────────┘
             ↓
        ┌────┴────┐
        │ ¿Pasa?  │
        │ (exit 0)│
        └────┬────┘
   ✅ Sí │    │ ❌ No
         ↓    ↓
   Auditoría  Corregir y re-ejecutar
   final      (no marcar como completo)
```

---

## 🔒 SISTEMA DE TRAZABILIDAD Y VALIDACIÓN

### ⚠️ 8 REGLAS OBLIGATORIAS PARA AGENTES IA

Si eres un agente IA ejecutando estos prompts, **DEBES cumplir las 8 reglas de trazabilidad**:

📖 **LEE PRIMERO**: [RULES.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md)

**Resumen de las reglas**:

1. **REGLA 1**: Declarar fuente ANTES de cada cambio
2. **REGLA 2**: Ejecutar checkpoint DESPUÉS de cada cambio
3. **REGLA 3**: Verificar personalización (no templates genéricos)
4. **REGLA 4**: Generar reporte de conformidad por fase
5. **REGLA 5**: Alertar desviaciones inmediatamente
6. **REGLA 6**: Generar registro de auditoría final
7. **REGLA 7**: Validar TODAS las plataformas configuradas
8. **REGLA 8**: Verificar recursos externos antes de usarlos

**Documentación completa con ejemplos**: Ver [RULES.md](https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md)

**CRÍTICO**: Estas 8 reglas son OBLIGATORIAS. NO omitas ninguna.

---

## 1. Prompt Detallado: Android + iOS

**Cuándo usar**: Cuando necesitas instrucciones paso a paso para implementar ofuscación completa

```
Implementa ofuscación y optimización de tamaño completa en mi proyecto Flutter para Android e iOS.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

INSTRUCCIONES OBLIGATORIAS:
1. LEE Y SIGUE: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md completo paso a paso
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md

2. CUMPLE: Las 8 reglas de RULES.md
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md

3. VALIDA: Usando VALIDATION_GUIDE.md al finalizar
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

CONTEXTO:
Estoy en la raíz de mi proyecto Flutter. Necesito:
- Ofuscación de código Dart (--obfuscate)
- Optimización de tamaño y ofuscación para Android (R8 + ProGuard)
- Optimización de tamaño y ofuscación para iOS (Symbol Stripping)

EJECUCIÓN:
- Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md sección por sección
- Declara fuente antes de cada paso (REGLA 1 de https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md)
- Ejecuta checkpoint después de cada paso (REGLA 2)
- Genera reportes por fase (REGLA 4)
- Valida TODAS las plataformas al final (REGLA 7)

═══════════════════════════════════════════════════════════

IMPLEMENTACIÓN:

Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md completo.

Fases a ejecutar:
1. Paso 1: Configuración Android (R8 + ProGuard)
2. Paso 2: Configuración iOS (Symbol Stripping)
3. Paso 3: Scripts de Automatización
4. Paso 4: Actualizar .gitignore
5. Validación (según https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md)

IMPORTANTE:
- Sigue cada sección en orden
- Personaliza todos los templates (NO usar valores genéricos)
- Cumple las 8 reglas en cada paso
- Ejecuta validate-implementation.sh al finalizar

═══════════════════════════════════════════════════════════

VALIDACIÓN FINAL:

Al completar, ejecuta:
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash

Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

TROUBLESHOOTING:
Si encuentras errores: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Procede paso a paso según MIGRATION_GUIDE.md, mostrando el progreso de cada fase.
```

---

## 2. Prompt Detallado: Solo Android

**Cuándo usar**: Proyecto sin iOS o build separado de Android

```
Implementa ofuscación y optimización de tamaño solo para Android en mi proyecto Flutter.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

INSTRUCCIONES OBLIGATORIAS:
1. LEE Y SIGUE: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md - Solo sección Android
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md

2. CUMPLE: Las 8 reglas de RULES.md
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md

3. VALIDA: Usando VALIDATION_GUIDE.md al finalizar
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

CONTEXTO:
Solo necesito configurar Android con optimización y ofuscación (R8 + ProGuard).
NO modifiques nada relacionado con iOS.

EJECUCIÓN:
- Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md - Paso 1 (Android) únicamente
- Cumple las 8 reglas de https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md en cada paso
- Omite pasos iOS completamente

═══════════════════════════════════════════════════════════

IMPLEMENTACIÓN:

Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md - Solo Paso 1 (Android).

IMPORTANTE:
- Detecta applicationId automáticamente
- Personaliza proguard-rules.pro (NO usar valores genéricos)
- Cumple las 8 reglas en cada paso
- Ejecuta validate-implementation.sh al finalizar

═══════════════════════════════════════════════════════════

VALIDACIÓN FINAL:

Al completar, ejecuta:
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash

Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

TROUBLESHOOTING:
Si encuentras errores: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Procede paso a paso según la guía.
```

---

## 3. Prompt Detallado: Solo iOS

**Cuándo usar**: Proyecto sin Android o build separado de iOS

```
Implementa ofuscación y optimización de tamaño solo para iOS en mi proyecto Flutter.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

INSTRUCCIONES OBLIGATORIAS:
1. LEE Y SIGUE: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md - Solo sección iOS
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md

2. CUMPLE: Las 8 reglas de RULES.md
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md

3. VALIDA: Usando VALIDATION_GUIDE.md al finalizar
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

CONTEXTO:
Solo necesito configurar iOS con optimización y ofuscación (Symbol Stripping).
NO modifiques nada relacionado con Android.

EJECUCIÓN:
- Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md - Paso 2 (iOS) únicamente
- Cumple las 8 reglas de https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md en cada paso
- Omite pasos Android completamente

═══════════════════════════════════════════════════════════

IMPLEMENTACIÓN:

Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md - Solo Paso 2 (iOS).

IMPORTANTE:
- Aplica Release.xcconfig SIN comentarios
- Si detectas Xcode 16.2, usa fix_xcode_modulecache.sh
- Cumple las 8 reglas en cada paso
- Ejecuta validate-implementation.sh al finalizar

═══════════════════════════════════════════════════════════

VALIDACIÓN FINAL:

Al completar, ejecuta:
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash

Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

TROUBLESHOOTING:
Si encuentras errores: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Procede paso a paso según la guía.
```

---

## 4. Prompt Detallado: Verificación

**Cuándo usar**: Después de implementar, para validar que todo esté correcto

```
Verifica que la implementación de ofuscación y optimización de tamaño esté completa y correcta.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

INSTRUCCIONES OBLIGATORIAS:
1. LEE Y EJECUTA: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md completo
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

2. EJECUTA: validate-implementation.sh (validación automática)
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh


═══════════════════════════════════════════════════════════

VALIDACIÓN AUTOMÁTICA:

Ejecuta el script de validación (4 FASES):
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash

Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

═══════════════════════════════════════════════════════════

REPORTE FINAL:

Genera un reporte basado en los resultados de:
- validate-implementation.sh (FASE 1-4)
- VALIDATION_GUIDE.md (validaciones técnicas profundas)

Incluye:
✅ Configuraciones aplicadas
📊 Métricas de build (tamaños, reducciones)
✅ Validaciones exitosas
⚠️ Advertencias
❌ Errores encontrados (si los hay)

DOCUMENTACIÓN PARA SOLUCIONES:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Presenta el reporte en markdown con formato claro.
```

---

## 📚 URLs de Documentación Completa

### Guías Principales
```
Guía de Migración:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md

Troubleshooting Avanzado:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Guía Técnica Detallada:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md
```

### Templates
```
Release.xcconfig (iOS - SIN comentarios):
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/Release.xcconfig.template
```

### Scripts
```
Build Automatizado:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh

Deobfuscación:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh

Fix Xcode 16.2:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/fix_xcode_modulecache.sh

Setup Automático:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/setup_obfuscation.sh
```

---

## 💡 Ventajas de este Enfoque

### ✅ Sin Descarga de Archivos

1. **El agente LEE directamente** desde GitHub usando URLs raw
2. **Siempre usa la versión actualizada** del repositorio
3. **No contamina** el proyecto con archivos temporales
4. **El agente personaliza** automáticamente según el proyecto

### 🔄 Flujo de Trabajo

```
Usuario copia prompt → Agente IA recibe instrucciones
                              ↓
                Agente lee URL raw de GitHub
                              ↓
                Obtiene contenido del archivo
                              ↓
                Personaliza según proyecto actual
                              ↓
                Crea archivo local personalizado
                              ↓
                Valida y ejecuta build
```

---

## 🎯 Compatibilidad con Agentes IA

| Agente | Lee URLs | Crea Archivos | Ejecuta Comandos | Estado |
|--------|----------|---------------|------------------|--------|
| **Claude Code** | ✅ WebFetch | ✅ Write | ✅ Bash | ✅ Compatible |
| **Gemini** | ✅ Fetch | ✅ Write | ✅ Shell | ✅ Compatible |
| **GitHub Copilot** | ⚠️ Limitado | ✅ Edit | ❌ No | ⚠️ Parcial |
| **Cursor AI** | ✅ Fetch | ✅ Write | ✅ Terminal | ✅ Compatible |
| **Windsurf** | ✅ Fetch | ✅ Write | ✅ Shell | ✅ Compatible |

---

## 🔧 Troubleshooting de Prompts

### El agente no puede leer URLs

**Síntoma**: Error de red o permisos al intentar leer desde GitHub

**Solución 1**: Algunos agentes tienen restricciones. Pide al agente:
```
Si no puedes leer directamente las URLs, indica qué archivos necesitas
y los leeré manualmente para proporcionártelos.
```

**Solución 2**: Clona el repositorio localmente y usa rutas locales:
```bash
git clone https://github.com/carlos-developer/flutter-obfuscation-toolkit.git
# Luego indica al agente: "Lee desde ../flutter-obfuscation-toolkit/[archivo]"
```

### El agente no detecta applicationId correctamente

**Solución**: Especifica manualmente en el prompt:
```
Mi applicationId es: com.miempresa.miapp
Úsalo para reemplazar "com.example.app" en todas las configuraciones.
```

### El agente no detecta todos los plugins

**Solución**: Lista manualmente:
```
Uso estos plugins (agrega reglas ProGuard para cada uno):
- sqflite: ^2.3.0
- firebase_core: ^2.24.0
- shared_preferences: ^2.2.2
- path_provider: ^2.1.0
```

### Build falla después de implementar

**Solución**: Pide al agente:
```
El build falló con este error:
[pegar error completo]

Lee el troubleshooting desde:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Y dame la solución específica para este error.
```

---

## 📊 Resultados Esperados

| Plataforma | Antes | Después | Reducción |
|------------|-------|---------|-----------|
| **Android arm64** | ~40 MB | ~14 MB | **65%** |
| **Android armv7** | ~35 MB | ~11 MB | **69%** |
| **Android x86_64** | ~42 MB | ~15 MB | **64%** |
| **iOS arm64** | ~25 MB | ~13 MB | **48%** |

### Archivos Generados

**Android**:
- 3 APKs optimizados (uno por ABI)
- mapping.txt (~3-5 MB) para deobfuscación
- 3 archivos .symbols para Flutter

**iOS**:
- Runner.app optimizado
- 1 archivo .symbols para Flutter
- dSYM para análisis de crashes

---

## ✅ Personalización Automática

Los agentes DEBEN personalizar automáticamente:

### 1. applicationId en ProGuard
```proguard
# ANTES (template genérico):
-keep class com.example.app.MainActivity { *; }

# DESPUÉS (personalizado):
-keep class com.miempresa.miapp.MainActivity { *; }
```

### 2. Reglas de Plugins
```proguard
# Detecta en pubspec.yaml:
dependencies:
  sqflite: ^2.3.0
  firebase_core: ^2.24.0

# Agrega automáticamente:
-keep class com.tekartik.sqflite.** { *; }
-keep class io.flutter.plugins.firebase.** { *; }
```

### 3. Modelos JSON (si aplica)
```proguard
# Si detecta @JsonSerializable en el código:
-keepclassmembers class com.miempresa.miapp.models.** {
    @com.google.gson.annotations.SerializedName <fields>;
    <init>(...);
}
```

---

## 🆘 Soporte

Si tienes problemas con los prompts:

1. **Revisa la documentación completa**: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
2. **Consulta troubleshooting**: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md
3. **Valida con**: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md
4. **Issues en GitHub**: https://github.com/carlos-developer/flutter-obfuscation-toolkit/issues

---

**Última actualización**: 2025-10-15
**Versión**: 3.0.0
**Cambios**:
- Eliminados prompts cortos - Solo prompts detallados
- Incorporada validación técnica de VALIDATION_GUIDE.md
- Énfasis en FASE 4 del script validate-implementation.sh
- Referencias a las 8 reglas de trazabilidad de MIGRATION_GUIDE.md
- Validación técnica profunda: R8, mapping.txt, ofuscación Dart, symbol stripping
**Compatible con**: Claude Code, Gemini, Cursor AI, Windsurf
