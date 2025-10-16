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

## 1. Prompt Detallado: Android + iOS

**Cuándo usar**: Cuando necesitas instrucciones paso a paso para implementar ofuscación completa

```
Implementa ofuscación y optimización de tamaño completa en mi proyecto Flutter para Android e iOS.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

INSTRUCCIONES OBLIGATORIAS:
1. LEE Y SIGUE: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md completo paso a paso
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md

2. CUMPLE: Las 9 reglas de RULES.md (incluyendo REGLA 7: validación manual y REGLA 9: NO descargar scripts)
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md

3. VALIDA: Usando VALIDATION_GUIDE.md al finalizar
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

CONTEXTO:
Estoy en la raíz de mi proyecto Flutter. Necesito:
- Ofuscación de código Dart (--obfuscate)
- Optimización de tamaño y ofuscación para Android (R8 + ProGuard)
- Optimización de tamaño y ofuscación para iOS (Symbol Stripping)

EJECUCIÓN:
- Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md sección por sección
- Declara fuente antes de cada paso (REGLA 1 de https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md)
- Ejecuta checkpoint después de cada paso (REGLA 2)
- Genera reportes por fase (REGLA 4)
- Valida TODAS las plataformas al final (REGLA 7)

═══════════════════════════════════════════════════════════

IMPLEMENTACIÓN:

Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md completo.

Fases a ejecutar:
1. Paso 1: Configuración Android (R8 + ProGuard)
2. Paso 2: Configuración iOS (Symbol Stripping)
3. Paso 3: Scripts de Automatización
4. Paso 4: Actualizar .gitignore
5. Validación (según https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md)

IMPORTANTE:
- Sigue cada sección en orden
- Personaliza todos los templates (NO usar valores genéricos)
- Cumple las 9 reglas en cada paso (especialmente REGLA 7: validación manual y REGLA 9: NO descargar scripts)
- Valida MANUALMENTE con comandos directos (file, nm, strings, grep, etc.) ANTES de cualquier script

═══════════════════════════════════════════════════════════

VALIDACIÓN FINAL (REGLA 7 - MANUAL OBLIGATORIA):

1. PRIMERO - Validación MANUAL (OBLIGATORIO):
   - Ejecuta builds manualmente: flutter build apk/ios --release --obfuscate
   - Inspecciona binarios: file, nm, strings, otool, grep
   - Verifica mapping.txt: wc -l, head, grep "compiler: R8"
   - Confirma símbolos generados: find build/symbols -name "*.symbols"
   - Genera reporte con resultados OBSERVADOS

2. DESPUÉS - Validación Automatizada (OPCIONAL):
   curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
   Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

⚠️  CRÍTICO: NO declares éxito sin completar PRIMERO la validación manual del paso 1.

TROUBLESHOOTING:
Si encuentras errores: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Procede paso a paso según IMPLEMENTATION.md, mostrando el progreso de cada fase.
```

---

## 2. Prompt Detallado: Solo Android

**Cuándo usar**: Proyecto sin iOS o build separado de Android

```
Implementa ofuscación y optimización de tamaño solo para Android en mi proyecto Flutter.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

INSTRUCCIONES OBLIGATORIAS:
1. LEE Y SIGUE: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md - Solo sección Android
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md

2. CUMPLE: Las 9 reglas de RULES.md (incluyendo REGLA 7: validación manual y REGLA 9: NO descargar scripts)
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md

3. VALIDA: Usando VALIDATION_GUIDE.md al finalizar
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

CONTEXTO:
Solo necesito configurar Android con optimización y ofuscación (R8 + ProGuard).
NO modifiques nada relacionado con iOS.

EJECUCIÓN:
- Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md - Paso 1 (Android) únicamente
- Cumple las 8 reglas de https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md en cada paso
- Omite pasos iOS completamente

═══════════════════════════════════════════════════════════

IMPLEMENTACIÓN:

Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md - Solo Paso 1 (Android).

IMPORTANTE:
- Detecta applicationId automáticamente
- Personaliza proguard-rules.pro (NO usar valores genéricos)
- Cumple las 9 reglas en cada paso (especialmente REGLA 7: validación manual y REGLA 9: NO descargar scripts)
- Valida MANUALMENTE con comandos directos (file, nm, strings, grep, etc.) ANTES de cualquier script

═══════════════════════════════════════════════════════════

VALIDACIÓN FINAL (REGLA 7 - MANUAL OBLIGATORIA):

1. PRIMERO - Validación MANUAL (OBLIGATORIO):
   - Ejecuta builds manualmente: flutter build apk/ios --release --obfuscate
   - Inspecciona binarios: file, nm, strings, otool, grep
   - Verifica mapping.txt: wc -l, head, grep "compiler: R8"
   - Confirma símbolos generados: find build/symbols -name "*.symbols"
   - Genera reporte con resultados OBSERVADOS

2. DESPUÉS - Validación Automatizada (OPCIONAL):
   curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
   Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

⚠️  CRÍTICO: NO declares éxito sin completar PRIMERO la validación manual del paso 1.

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
1. LEE Y SIGUE: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md - Solo sección iOS
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md

2. CUMPLE: Las 9 reglas de RULES.md (incluyendo REGLA 7: validación manual y REGLA 9: NO descargar scripts)
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md

3. VALIDA: Usando VALIDATION_GUIDE.md al finalizar
   URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/VALIDATION_GUIDE.md

CONTEXTO:
Solo necesito configurar iOS con optimización y ofuscación (Symbol Stripping).
NO modifiques nada relacionado con Android.

EJECUCIÓN:
- Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md - Paso 2 (iOS) únicamente
- Cumple las 8 reglas de https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/RULES.md en cada paso
- Omite pasos Android completamente

═══════════════════════════════════════════════════════════

IMPLEMENTACIÓN:

Sigue https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md - Solo Paso 2 (iOS).

IMPORTANTE:
- Aplica Release.xcconfig SIN comentarios
- Si detectas Xcode 16.2, usa fix_xcode_modulecache.sh
- Cumple las 9 reglas en cada paso (especialmente REGLA 7: validación manual y REGLA 9: NO descargar scripts)
- Valida MANUALMENTE con comandos directos (file, nm, strings, grep, etc.) ANTES de cualquier script

═══════════════════════════════════════════════════════════

VALIDACIÓN FINAL (REGLA 7 - MANUAL OBLIGATORIA):

1. PRIMERO - Validación MANUAL (OBLIGATORIO):
   - Ejecuta builds manualmente: flutter build apk/ios --release --obfuscate
   - Inspecciona binarios: file, nm, strings, otool, grep
   - Verifica mapping.txt: wc -l, head, grep "compiler: R8"
   - Confirma símbolos generados: find build/symbols -name "*.symbols"
   - Genera reporte con resultados OBSERVADOS

2. DESPUÉS - Validación Automatizada (OPCIONAL):
   curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
   Expected: Exit code 0 con "IMPLEMENTACIÓN CERTIFICADA"

⚠️  CRÍTICO: NO declares éxito sin completar PRIMERO la validación manual del paso 1.

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
Guía de Implementación:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md

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

## 🆘 Soporte

Si tienes problemas con los prompts:

1. **Revisa la documentación completa**: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/IMPLEMENTATION.md
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
- Referencias a las 8 reglas de trazabilidad de IMPLEMENTATION.md
- Validación técnica profunda: R8, mapping.txt, ofuscación Dart, symbol stripping
**Compatible con**: Claude Code, Gemini, Cursor AI, Windsurf
