# 🤖 Prompts para Agentes IA - Flutter Obfuscation Toolkit

> Prompts ultra-cortos que referencian este repositorio para que los agentes lean toda la información necesaria

**Repositorio oficial**: `https://github.com/carlos-developer/flutter-obfuscation-toolkit`

---

## ⚡ Prompts Cortos (Recomendado)

**Copia solo UNA línea según tu necesidad:**

### Android + iOS
```
Implementa ofuscación y optimización de tamaño Flutter para Android e iOS siguiendo: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md. Usa la especificación estructurada en https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/agent-instructions.json para validaciones paso a paso. Al finalizar ejecuta el script de validación automática.
```

### Solo Android
```
Implementa ofuscación y optimización de tamaño para Android siguiendo: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md (solo sección Android). Usa https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/agent-instructions.json para validaciones estructuradas. Al finalizar ejecuta el script de validación.
```

### Solo iOS
```
Implementa ofuscación y optimización de tamaño para iOS siguiendo: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md (solo sección iOS). Usa https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/agent-instructions.json para validaciones estructuradas. Al finalizar ejecuta el script de validación.
```

### Verificar Implementación
```
Verifica mi implementación de ofuscación y optimización usando el checklist: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/CHECKLIST_OBFUSCATION.md
```
m
### Solucionar Errores
```
Tengo este error: [pega el error]. Busca la solución en: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md
```

---

## 📋 Índice de Prompts Detallados

Si necesitas más control, usa estos prompts más específicos:

1. [Prompt Detallado: Android + iOS](#1-prompt-detallado-android--ios) - Con instrucciones paso a paso
2. [Prompt Detallado: Solo Android](#2-prompt-detallado-solo-android) - R8 + ProGuard
3. [Prompt Detallado: Solo iOS](#3-prompt-detallado-solo-ios) - Symbol Stripping
4. [Prompt Detallado: Verificación](#4-prompt-detallado-verificación) - Validación

---

## 🎯 Instrucciones de Uso

### Opción 1: Prompts Ultra-Cortos (⚡ Más Rápido)
1. Copia **UNA línea** de los prompts cortos arriba
2. Pégala en tu agente IA
3. El agente lee toda la información del archivo referenciado
4. **El agente DEBE reportar cada checkpoint y validación** (ver reglas abajo)
5. Listo! ✅

### Opción 2: Prompts Detallados (📋 Más Control)
1. Selecciona el prompt detallado según tu necesidad
2. Copia el prompt completo
3. Pégalo en tu agente IA
4. El agente sigue las instrucciones paso a paso
5. **Validación estricta en cada fase** (ver reglas abajo)

---

## 🤖 Archivos para Agentes IA

Este toolkit incluye archivos específicos para que los agentes IA procesen las instrucciones de forma estructurada:

### 📄 agent-instructions.json
**URL**: `https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/agent-instructions.json`

**Propósito**: Especificación procesable por máquina (JSON) del toolkit completo.

**Contiene**:
- Pasos atómicos con validaciones programáticas
- Protocolo de trazabilidad formal (7 reglas obligatorias)
- Comandos de validación con exit codes esperados
- Detección de personalizaciones obligatorias
- Prevención de errores comunes
- Checklist de validación final

**Cuándo usarlo**:
- ✅ Agentes IA avanzados que pueden parsear JSON (Claude, GPT-4, Gemini)
- ✅ Validaciones automáticas paso a paso
- ✅ Implementaciones que requieren máxima precisión
- ✅ Auditorías y certificación de conformidad

**Ejemplo de uso por el agente**:
```json
{
  "step_id": "android_01",
  "file": "android/app/build.gradle.kts",
  "search_pattern": "defaultConfig {",
  "action": "add_after_pattern",
  "content": "        multiDexEnabled = true",
  "validation": {
    "command": "grep -q 'multiDexEnabled = true' android/app/build.gradle.kts",
    "expected_exit_code": 0
  }
}
```

El agente:
1. Lee el JSON completo
2. Ejecuta cada paso en orden
3. Valida automáticamente con los comandos especificados
4. Reporta conformidad con el protocolo de trazabilidad

### 📜 MIGRATION_GUIDE.md
**URL**: `https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md`

**Propósito**: Guía paso a paso en lenguaje natural (para humanos y agentes).

**Contiene**:
- Instrucciones detalladas por plataforma
- Ejemplos de código completos
- Explicaciones del "por qué" de cada paso
- Troubleshooting integrado
- Las 7 reglas de trazabilidad para agentes IA

**Cuándo usarlo**:
- ✅ Primera vez implementando el toolkit
- ✅ Necesitas entender el contexto de cada paso
- ✅ Lectura humana + ejecución por agente IA
- ✅ Referencia rápida

### 🔍 validate-implementation.sh
**URL**: `https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh`

**Propósito**: Script de validación automática que detecta plataformas configuradas y valida cada una.

**Ejecución**:
```bash
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
```

**Qué valida**:
- Detecta qué plataformas (Android/iOS) fueron configuradas
- Valida archivos de configuración
- Ejecuta builds de todas las plataformas detectadas
- Verifica artifacts generados
- Retorna exit code 0 solo si TODO pasó

**CRÍTICO para agentes IA**:
Este script DEBE ejecutarse antes de generar el registro de auditoría final (REGLA 7).

---

## 🔗 Relación entre los archivos

```
┌─────────────────────────────────────┐
│  Usuario copia prompt               │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Agente IA lee:                     │
│  1. MIGRATION_GUIDE.md (contexto)   │
│  2. agent-instructions.json (pasos) │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Agente ejecuta implementación      │
│  siguiendo protocolo de validación  │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Agente ejecuta:                    │
│  validate-implementation.sh         │
└────────────┬────────────────────────┘
             ↓
        ┌────┴────┐
        │ ¿Pasa?  │
        └────┬────┘
   ✅ Sí │    │ ❌ No
         ↓    ↓
   Auditoría  Corregir y re-ejecutar
   final      (no marcar como completo)
```

---

## 🔒 SISTEMA DE TRAZABILIDAD Y VALIDACIÓN

### ⚠️ 7 REGLAS OBLIGATORIAS PARA AGENTES IA

Si eres un agente IA ejecutando estos prompts, DEBES cumplir estas 7 reglas:

---

### 📋 REGLA 1: Declarar Fuente de Cada Paso

**ANTES de realizar CUALQUIER cambio**, declara explícitamente:

```
📖 EJECUTANDO PASO DESDE TOOLKIT:

Fuente: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
Sección: "Paso 1.1 - Modificar build.gradle.kts"
Líneas: 110-133

Acción a realizar:
- Agregar multiDexEnabled = true en defaultConfig
- Agregar isMinifyEnabled = true en buildTypes.release
- Agregar isShrinkResources = true en buildTypes.release

Estado: INICIANDO
```

**❌ Si NO puedes leer la fuente**:
```
❌ ADVERTENCIA: NO PUEDO LEER FUENTE

URL intentada: https://raw.githubusercontent.com/.../MIGRATION_GUIDE.md
Error: [describir error]

🛑 DETENIENDO IMPLEMENTACIÓN
Razón: Sin acceso al toolkit, no puedo garantizar que sigo las instrucciones correctas.

Solución sugerida:
1. Verifica tu conexión a GitHub
2. O proporciona el contenido manualmente
3. O clona el repositorio localmente
```

---

### ✅ REGLA 2: Checkpoint Obligatorio Después de Cada Cambio

**DESPUÉS de cada modificación**, ejecuta validación:

```
✅ CHECKPOINT EJECUTADO - [Nombre del paso]

Cambio realizado:
- Archivo: android/app/build.gradle.kts
- Líneas modificadas: 45-52

Validación automática:
[✅] Archivo existe: android/app/build.gradle.kts
[✅] Contiene "multiDexEnabled = true": grep encontró coincidencia
[✅] Contiene "isMinifyEnabled = true": grep encontró coincidencia
[✅] Contiene "isShrinkResources = true": grep encontró coincidencia
[✅] Sintaxis Kotlin válida: Sin errores de compilación

Comando de validación ejecutado:
grep "isMinifyEnabled\|isShrinkResources\|multiDexEnabled" android/app/build.gradle.kts

Resultado:
  45: multiDexEnabled = true
  52: isMinifyEnabled = true
  53: isShrinkResources = true

Estado: ✅ PASO COMPLETADO CORRECTAMENTE
```

**❌ Si la validación falla**:
```
❌ CHECKPOINT FALLIDO - [Nombre del paso]

Cambio intentado:
- Archivo: android/app/build.gradle.kts

Validación:
[✅] Archivo existe
[❌] NO contiene "isMinifyEnabled = true"
[❌] NO contiene "isShrinkResources = true"

🛑 PROBLEMA DETECTADO
El archivo fue modificado pero las validaciones no pasan.

Posibles causas:
1. El archivo tiene sintaxis diferente (Groovy vs Kotlin DSL)
2. Las configuraciones ya existían con otros valores
3. El archivo tiene un formato inesperado

Acción tomada: REVERTIR cambios y solicitar intervención manual

¿Deseas que:
1. Muestre el contenido actual del archivo para revisión?
2. Intente nuevamente con sintaxis alternativa?
3. Continúe sin esta configuración (NO RECOMENDADO)?
```

---

### 🔍 REGLA 3: Verificación de Personalización

**Después de crear archivos con templates**, verifica personalización:

```
🔍 VERIFICACIÓN DE PERSONALIZACIÓN

Archivo: android/app/proguard-rules.pro
Template origen: https://raw.githubusercontent.com/.../MIGRATION_GUIDE.md

Personalizaciones requeridas:
[✅] applicationId detectado: com.tuapp.real
[✅] applicationId reemplazado en MainActivity:
     ANTES: -keep class com.example.app.MainActivity
     DESPUÉS: -keep class com.tuapp.real.MainActivity
[✅] Plugins detectados: 3 (sqflite, firebase_core, shared_preferences)
[✅] Reglas ProGuard agregadas para cada plugin

Validación anti-template-genérico:
grep "com.example.app" android/app/proguard-rules.pro
Resultado: ❌ NO encontrado (CORRECTO - significa que personalizaste)

Estado: ✅ ARCHIVO PERSONALIZADO CORRECTAMENTE
```

**❌ Si detecta template genérico**:
```
❌ ADVERTENCIA: TEMPLATE NO PERSONALIZADO

Archivo: android/app/proguard-rules.pro

Problema detectado:
grep "com.example.app" android/app/proguard-rules.pro
Resultado: ✅ ENCONTRADO en línea 23 (INCORRECTO)

🛑 ARCHIVO CONTIENE VALORES GENÉRICOS
Esto indica que el template NO fue personalizado con el applicationId real.

Acción requerida:
1. Detectar applicationId real del proyecto
2. Reemplazar TODOS los "com.example.app" con el applicationId correcto
3. Validar nuevamente

Estado: 🔄 RE-PERSONALIZANDO ARCHIVO...
```

---

### 📊 REGLA 4: Reporte de Conformidad por Fase

**Al finalizar cada FASE completa**, genera reporte:

```
📊 REPORTE DE CONFORMIDAD - FASE 2 (Configuración Android)

═══════════════════════════════════════════

✅ PASOS COMPLETADOS (según toolkit):

[✅] Paso 2.1: Leer guía desde repositorio
     Fuente: MIGRATION_GUIDE.md líneas 107-109
     Verificado: Contenido leído correctamente

[✅] Paso 2.2: Modificar build.gradle.kts
     Fuente: MIGRATION_GUIDE.md líneas 110-133
     Verificado: 3 configuraciones agregadas
     Checkpoint: PASÓ

[✅] Paso 2.3: Crear proguard-rules.pro
     Fuente: MIGRATION_GUIDE.md líneas 161-188
     Verificado: Archivo creado (150 líneas)
     Personalizado: SÍ (applicationId: com.tuapp.real)
     Checkpoint: PASÓ

═══════════════════════════════════════════

📋 CONFORMIDAD CON TOOLKIT:

Total de pasos en FASE 2 según toolkit: 3
Pasos completados exitosamente: 3
Pasos con advertencias: 0
Pasos fallidos: 0

Porcentaje de conformidad: 100% ✅

═══════════════════════════════════════════

🔗 TRAZABILIDAD:

Todos los cambios están documentados en:
- Repositorio: https://github.com/carlos-developer/flutter-obfuscation-toolkit
- Archivo principal: MIGRATION_GUIDE.md
- Secciones consultadas: Paso 1, Paso 2

Comandos de validación ejecutados:
1. grep "isMinifyEnabled" android/app/build.gradle.kts ✅
2. test -f android/app/proguard-rules.pro ✅
3. grep -v "com.example.app" android/app/proguard-rules.pro ✅

═══════════════════════════════════════════

➡️ PRÓXIMA FASE: FASE 3 (Configuración iOS)
```

---

### 🚨 REGLA 5: Alertas de Desviación Inmediatas

**Si el agente detecta que está haciendo algo NO documentado en el toolkit**:

```
🚨 ALERTA DE DESVIACIÓN DEL TOOLKIT

Acción que estaba por realizar:
- [Descripción de la acción]

Problema:
❌ Esta acción NO está documentada en:
   - MIGRATION_GUIDE.md
   - TROUBLESHOOTING_ADVANCED.md
   - Ningún documento del toolkit

Busqué en:
- https://raw.githubusercontent.com/.../MIGRATION_GUIDE.md
- https://raw.githubusercontent.com/.../docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md
- Resultado: NO encontrado

🛑 DETENIENDO ACCIÓN NO AUTORIZADA

Opciones:
1. Omitir esta acción y continuar con pasos documentados
2. Consultar al usuario si esta acción es necesaria
3. Buscar en troubleshooting si hay una excepción documentada

Por seguridad, NO realizaré esta acción hasta recibir confirmación.
```

---

### 📝 REGLA 6: Registro de Auditoría Final

**Al completar la implementación completa**:

```
📝 REGISTRO DE AUDITORÍA - IMPLEMENTACIÓN COMPLETADA

═══════════════════════════════════════════

🔒 TRAZABILIDAD COMPLETA:

Fecha: [fecha y hora]
Toolkit versión: 1.0.0
Repositorio: https://github.com/carlos-developer/flutter-obfuscation-toolkit

═══════════════════════════════════════════

📊 RESUMEN DE FASES:

FASE 1 - Análisis del Proyecto
├─ Pasos completados: 3/3 ✅
├─ Conformidad: 100%
└─ Checkpoints pasados: 3/3

FASE 2 - Configuración Android
├─ Pasos completados: 3/3 ✅
├─ Conformidad: 100%
└─ Checkpoints pasados: 3/3

FASE 3 - Configuración iOS
├─ Pasos completados: 3/3 ✅
├─ Conformidad: 100%
└─ Checkpoints pasados: 3/3

FASE 4 - Scripts de Automatización
├─ Pasos completados: 3/3 ✅
├─ Conformidad: 100%
└─ Checkpoints pasados: 3/3

FASE 5 - Validación
├─ Pasos completados: 5/5 ✅
├─ Conformidad: 100%
└─ Checkpoints pasados: 5/5

═══════════════════════════════════════════

✅ CONFORMIDAD TOTAL: 100%

Total pasos según toolkit: 17
Pasos ejecutados correctamente: 17
Desviaciones del toolkit: 0
Advertencias generadas: 0
Errores encontrados: 0

═══════════════════════════════════════════

🔗 ARCHIVOS MODIFICADOS (con trazabilidad):

1. android/app/build.gradle.kts
   Fuente: MIGRATION_GUIDE.md líneas 110-133
   Checksum antes: [hash]
   Checksum después: [hash]
   Validado: ✅

2. android/app/proguard-rules.pro
   Fuente: MIGRATION_GUIDE.md líneas 161-188
   Personalizado: SÍ (com.tuapp.real)
   Validado: ✅

3. ios/Flutter/Release.xcconfig
   Fuente: templates/Release.xcconfig.template
   Validado: ✅

4. scripts/build_release_obfuscated.sh
   Fuente: scripts/build_release_obfuscated.sh del repositorio
   Ejecutable: ✅
   Validado: ✅

[... resto de archivos ...]

═══════════════════════════════════════════

🧪 VALIDACIÓN FINAL REQUERIDA:

Para confirmar que TODO funciona correctamente, ejecuta:

flutter build apk --release --obfuscate \
  --split-debug-info=build/symbols/android \
  --split-per-abi

Archivos esperados:
✓ build/app/outputs/apk/release/*.apk (3 archivos, ~11-15 MB cada uno)
✓ build/app/outputs/mapping/release/mapping.txt (~3-5 MB)
✓ build/symbols/android/*.symbols (3 archivos)

═══════════════════════════════════════════

📋 CERTIFICACIÓN:

Certifico que:
✅ Todos los pasos siguieron el toolkit oficial
✅ Todas las personalizaciones fueron aplicadas
✅ Todos los checkpoints pasaron
✅ No hubo desviaciones del proceso documentado
✅ Todos los archivos fueron validados

Implementación conforme al toolkit: ✅ CERTIFICADA

═══════════════════════════════════════════
```

---

### 🔒 REGLA 7: Validación Automática de TODAS las Plataformas Configuradas

**AL FINALIZAR la implementación completa**, ANTES de generar el registro de auditoría:

```
🔒 VALIDACIÓN AUTOMÁTICA - REGLA 7

Paso 1: Detectar plataformas configuradas
  grep -q "isMinifyEnabled" android/app/build.gradle* → Android: [SÍ/NO]
  grep -q "STRIP_INSTALLED_PRODUCT" ios/Flutter/Release.xcconfig → iOS: [SÍ/NO]

Paso 2: Ejecutar script de validación automática
  curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
  Exit code: [0 = éxito / 1+ = error]

Paso 3: Validar CADA plataforma configurada con su build

Si configuraste Android:
  [✅/❌] flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi
  [✅/❌] test -f build/app/outputs/mapping/release/mapping.txt
  [✅/❌] test -d build/symbols/android

Si configuraste iOS:
  [✅/❌] flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios
  [✅/❌] test -d build/symbols/ios
  [✅/❌] file build/ios/Release-iphoneos/Runner.app/Runner | grep -q stripped

Resultado: [✅ TODAS LAS PLATAFORMAS VALIDADAS / ❌ VALIDACIÓN FALLÓ]
```

**CRÍTICO**:
- Si configuraste 2 plataformas → DEBES validar AMBAS con sus builds
- NO asumas que funciona sin ejecutar los builds de validación
- NO marques como completo si el script falla
- SOLO genera la auditoría final si TODAS las validaciones pasaron

**❌ Si falla**:
```
❌ VALIDACIÓN AUTOMÁTICA FALLÓ

Plataformas configuradas: [Android, iOS]
Plataformas validadas: [Android]
Plataformas NO validadas: [iOS] ❌

🛑 IMPLEMENTACIÓN INCOMPLETA

Problema: Configuraste iOS pero NO ejecutaste su build de validación.

Acción requerida:
1. Ejecutar: flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios
2. Verificar artifacts generados
3. Re-ejecutar script de validación
4. Solo entonces generar auditoría final

NO puedo marcar como completo hasta que TODAS las plataformas configuradas pasen validación.
```

---

## 1. Prompt Detallado: Android + iOS

**Cuándo usar**: Cuando necesitas instrucciones paso a paso para implementar ofuscación completa

```
Implementa ofuscación y minificación completa en mi proyecto Flutter para Android e iOS.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

CONTEXTO:
Estoy en la raíz de mi proyecto Flutter. Necesito:
- Ofuscación de código Dart (--obfuscate)
- Optimización de tamaño y ofuscación para Android (R8 + ProGuard)
- Optimización de tamaño y ofuscación para iOS (Symbol Stripping)

INSTRUCCIONES:
Lee directamente los archivos del repositorio usando las URLs raw de GitHub.
NO descargues archivos con curl/wget, lee el contenido y aplícalo.

═══════════════════════════════════════════════════════════

FASE 1 - ANÁLISIS DEL PROYECTO

1.1. Detecta mi applicationId:
Archivo: android/app/build.gradle.kts
Busca: applicationId = "..."
Ejemplo: com.miempresa.miapp

1.2. Detecta plugins en uso:
Archivo: pubspec.yaml
Busca en dependencies: sqflite, firebase_core, shared_preferences, path_provider, etc.

1.3. Identifica modelos con JSON:
Busca en el código: @JsonSerializable, fromJson, toJson

═══════════════════════════════════════════════════════════

FASE 2 - CONFIGURACIÓN ANDROID (R8 + ProGuard)

2.1. Lee la guía de Android:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
Busca: Sección "Paso 1: Configuración Android"

2.2. Modifica android/app/build.gradle.kts:

En defaultConfig:
    multiDexEnabled = true  // AGREGAR

En buildTypes → release:
    isMinifyEnabled = true           // AGREGAR
    isShrinkResources = true         // AGREGAR
    proguardFiles(
        getDefaultProguardFile("proguard-android-optimize.txt"),
        "proguard-rules.pro"
    )

2.3. Crea android/app/proguard-rules.pro:

Lee el contenido completo desde:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
Líneas 161-188 (código proguard mínimo)

Personaliza:
- Reemplaza "com.example.app" con mi applicationId detectado
- Agrega reglas para cada plugin detectado:
  * sqflite → -keep class com.tekartik.sqflite.** { *; }
  * firebase → -keep class io.flutter.plugins.firebase.** { *; }
  * shared_preferences → -keep class io.flutter.plugins.sharedpreferences.** { *; }

═══════════════════════════════════════════════════════════

FASE 3 - CONFIGURACIÓN iOS (Symbol Stripping)

3.1. Lee el template iOS:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/Release.xcconfig.template

3.2. Aplica en ios/Flutter/Release.xcconfig:

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

⚠️ CRÍTICO: NO agregues comentarios con # (excepto #include)
Los archivos .xcconfig NO soportan comentarios decorativos.

═══════════════════════════════════════════════════════════

FASE 4 - SCRIPTS DE AUTOMATIZACIÓN

4.1. Crea scripts/build_release_obfuscated.sh:
Lee contenido desde:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
Crea el archivo en mi proyecto y hazlo ejecutable: chmod +x

4.2. Crea scripts/deobfuscate.sh:
Lee contenido desde:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh
Crea el archivo y hazlo ejecutable: chmod +x

4.3. Crea scripts/fix_xcode_modulecache.sh:
Lee contenido desde:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/fix_xcode_modulecache.sh
Crea el archivo y hazlo ejecutable: chmod +x

═══════════════════════════════════════════════════════════

FASE 5 - VALIDACIÓN

⚠️ IMPORTANTE: Solo valida las plataformas que configuraste.
Si configuraste solo Android, omite pasos iOS.
Si configuraste solo iOS, omite pasos Android.
Si configuraste ambas, ejecuta todos los pasos.

5.1. Actualiza .gitignore:
Agrega estas líneas si no existen:
build/app/outputs/mapping/
build/symbols/
*.backup
temp/

5.2. Build de prueba Android (SOLO si configuraste Android):
flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi

5.3. Verifica archivos generados Android (SOLO si construiste Android):
✓ build/app/outputs/apk/release/app-armeabi-v7a-release.apk (~11 MB)
✓ build/app/outputs/apk/release/app-arm64-v8a-release.apk (~14 MB)
✓ build/app/outputs/apk/release/app-x86_64-release.apk (~15 MB)
✓ build/app/outputs/mapping/release/mapping.txt (~3-5 MB)
✓ build/symbols/android/*.symbols (3 archivos)

5.4. Build de prueba iOS (SOLO si configuraste iOS):
- Verifica versión Xcode: xcodebuild -version
- Si es Xcode 16.2, sugiere ejecutar: ./scripts/fix_xcode_modulecache.sh
- Ejecuta: flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios --no-codesign

5.5. Verifica archivos generados iOS (SOLO si construiste iOS):
✓ build/ios/iphoneos/Runner.app (~12-14 MB)
✓ build/symbols/ios/app.ios-arm64.symbols (~1.3 MB)

═══════════════════════════════════════════════════════════

RESULTADOS ESPERADOS:
- Android: Reducción ≥60% en tamaño de APK
- iOS: Reducción ≥20-30% en tamaño de IPA
- Símbolos Dart: 100% ofuscados
- mapping.txt generado para deobfuscación

DOCUMENTACIÓN ADICIONAL:
Si encuentras errores, consulta:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Procede paso a paso, mostrando el progreso de cada fase.
```

---

## 2. Prompt Detallado: Solo Android

**Cuándo usar**: Proyecto sin iOS o build separado de Android

```
Implementa ofuscación y optimización de tamaño solo para Android en mi proyecto Flutter.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

CONTEXTO:
Solo necesito configurar Android con optimización y ofuscación (R8 + ProGuard).
NO modifiques nada relacionado con iOS.

INSTRUCCIONES:
Lee directamente los archivos del repositorio.
NO descargues con curl/wget.

═══════════════════════════════════════════════════════════

FASE 1 - ANÁLISIS

1.1. Detecta applicationId:
Archivo: android/app/build.gradle.kts
Busca: applicationId = "com.ejemplo.app"

1.2. Detecta plugins:
Archivo: pubspec.yaml
Busca en dependencies: sqflite, firebase, shared_preferences, path_provider, etc.

1.3. Verifica JSON serialization:
Busca en el código: @JsonSerializable, fromJson(), toJson()

═══════════════════════════════════════════════════════════

FASE 2 - CONFIGURACIÓN GRADLE

2.1. Lee la guía:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
Sección: "1.1 Modificar build.gradle.kts"

2.2. Modifica android/app/build.gradle.kts:

En defaultConfig:
    multiDexEnabled = true  // AGREGAR si no existe

En buildTypes → release:
    isMinifyEnabled = true           // AGREGAR
    isShrinkResources = true         // AGREGAR
    proguardFiles(
        getDefaultProguardFile("proguard-android-optimize.txt"),
        "proguard-rules.pro"
    )
    // Mantener signingConfig existente sin cambios

═══════════════════════════════════════════════════════════

FASE 3 - PROGUARD RULES

3.1. Lee el ejemplo completo:
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
Líneas 161-188

3.2. Crea android/app/proguard-rules.pro:

Estructura base:
# Flutter Core
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# MainActivity (REEMPLAZAR con applicationId detectado)
-keep class MI_APPLICATION_ID_AQUI.MainActivity { *; }

# Plugins (AGREGAR según lo detectado en pubspec.yaml)
# Si usa sqflite:
-keep class com.tekartik.sqflite.** { *; }

# Si usa firebase:
-keep class io.flutter.plugins.firebase.** { *; }
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Si usa shared_preferences:
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Si usa path_provider:
-keep class io.flutter.plugins.pathprovider.** { *; }

# JNI (OBLIGATORIO)
-keepclasseswithmembernames class * {
    native <methods>;
}

# Reflection (OBLIGATORIO)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses,EnclosingMethod

# Enums (OBLIGATORIO)
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Parcelable (OBLIGATORIO)
-keep interface android.os.Parcelable
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Serializable (OBLIGATORIO)
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# AndroidX (OBLIGATORIO)
-keep class ** extends androidx.lifecycle.ViewModel { *; }
-keep class ** extends androidx.lifecycle.AndroidViewModel { *; }

# Optimization
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# Warnings
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

═══════════════════════════════════════════════════════════

FASE 4 - SCRIPTS

4.1. Crea scripts/build_release_obfuscated.sh:
Lee desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
Crea el archivo y hazlo ejecutable: chmod +x scripts/build_release_obfuscated.sh

4.2. Crea scripts/deobfuscate.sh:
Lee desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh
Crea el archivo y hazlo ejecutable: chmod +x scripts/deobfuscate.sh

═══════════════════════════════════════════════════════════

FASE 5 - VALIDACIÓN

5.1. Actualiza .gitignore:
build/app/outputs/mapping/
build/symbols/
*.backup

5.2. Build de prueba:
flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi

5.3. Verifica archivos generados:
✓ build/app/outputs/apk/release/app-armeabi-v7a-release.apk (~11 MB)
✓ build/app/outputs/apk/release/app-arm64-v8a-release.apk (~14 MB)
✓ build/app/outputs/apk/release/app-x86_64-release.apk (~15 MB)
✓ build/app/outputs/mapping/release/mapping.txt (~3-5 MB)
✓ build/symbols/android/app.android-arm.symbols
✓ build/symbols/android/app.android-arm64.symbols
✓ build/symbols/android/app.android-x64.symbols

5.4. Verifica ofuscación:
Ejecuta: strings build/app/outputs/apk/release/app-arm64-v8a-release.apk | grep "NombreDeClaseOriginal"
Esperado: No debe encontrar nombres de clases originales

═══════════════════════════════════════════════════════════

TROUBLESHOOTING:
Si encuentras ClassNotFoundException o NoSuchMethodException:
Lee: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md

Procede paso a paso y muestra el progreso.
```

---

## 3. Prompt Detallado: Solo iOS

**Cuándo usar**: Proyecto sin Android o build separado de iOS

```
Implementa ofuscación y optimización de tamaño solo para iOS en mi proyecto Flutter.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

CONTEXTO:
Solo necesito configurar iOS con optimización y ofuscación (Symbol Stripping).
NO modifiques nada relacionado con Android.

INSTRUCCIONES:
Lee directamente los archivos del repositorio.
NO descargues con curl/wget.

═══════════════════════════════════════════════════════════

FASE 1 - ANÁLISIS

1.1. Verifica versión de Xcode:
Ejecuta: xcodebuild -version
Si es Xcode 16.2, necesitarás aplicar un fix (lo haré después)

═══════════════════════════════════════════════════════════

FASE 2 - CONFIGURACIÓN XCCONFIG

2.1. Lee el template correcto (sin comentarios):
URL: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/Release.xcconfig.template

2.2. Edita ios/Flutter/Release.xcconfig:

Reemplaza TODO el contenido con:

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

⚠️ ADVERTENCIA CRÍTICA:
Los archivos .xcconfig NO soportan comentarios con # (excepto #include).
Si agregas comentarios como "# Symbol Stripping", el build FALLARÁ con:
Error (Xcode): unsupported preprocessor directive

Solo configura con formato: KEY = VALUE

═══════════════════════════════════════════════════════════

FASE 3 - FIX XCODE 16.2 (Si detectaste versión 16.2)

3.1. Crea scripts/fix_xcode_modulecache.sh:
Lee desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/fix_xcode_modulecache.sh
Crea el archivo y hazlo ejecutable: chmod +x scripts/fix_xcode_modulecache.sh

3.2. Informa al usuario:
"Detecté Xcode 16.2. Antes de hacer el build, ejecuta:
./scripts/fix_xcode_modulecache.sh

Este script soluciona el bug conocido de ModuleCache corrupto.
Referencia: Flutter Issue #157461"

═══════════════════════════════════════════════════════════

FASE 4 - SCRIPTS

4.1. Crea scripts/build_release_obfuscated.sh:
Lee desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
Crea y hazlo ejecutable: chmod +x

4.2. Crea scripts/deobfuscate.sh:
Lee desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh
Crea y hazlo ejecutable: chmod +x

═══════════════════════════════════════════════════════════

FASE 5 - VALIDACIÓN

5.1. Actualiza .gitignore:
build/ios/
build/symbols/
*.backup

5.2. Build de prueba:
flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios --no-codesign

5.3. Verifica archivos generados:
✓ build/ios/iphoneos/Runner.app (~12-14 MB)
✓ build/symbols/ios/app.ios-arm64.symbols (~1.3 MB)

5.4. Verifica symbol stripping:
Ejecuta: nm build/ios/iphoneos/Runner.app/Frameworks/App.framework/App | grep "NombreDeClaseOriginal"
Esperado: No debe encontrar símbolos originales

═══════════════════════════════════════════════════════════

TROUBLESHOOTING:

Error: "unsupported preprocessor directive"
Causa: Agregaste comentarios con # en Release.xcconfig
Solución: Elimina todos los comentarios excepto #include "Generated.xcconfig"
Documentación: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md (busca "unsupported preprocessor")

Error: ModuleCache en Xcode 16.2
Solución: Ejecuta ./scripts/fix_xcode_modulecache.sh
Documentación: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TROUBLESHOOTING_ADVANCED.md (busca "Xcode 16.2")

Procede paso a paso y muestra el progreso.
```

---

## 4. Prompt Detallado: Verificación

**Cuándo usar**: Después de implementar, para validar que todo esté correcto

```
Verifica que la implementación de ofuscación y optimización esté completa y correcta.

REPOSITORIO DE REFERENCIA:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

CHECKLIST COMPLETO:
Lee desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/CHECKLIST_OBFUSCATION.md

═══════════════════════════════════════════════════════════

VALIDACIONES AUTOMÁTICAS

1. ARCHIVOS DE CONFIGURACIÓN

Android (si aplica):
✓ Verificar: grep "isMinifyEnabled = true" android/app/build.gradle.kts
✓ Verificar: grep "isShrinkResources = true" android/app/build.gradle.kts
✓ Verificar: grep "multiDexEnabled = true" android/app/build.gradle.kts
✓ Verificar: test -f android/app/proguard-rules.pro
✓ Verificar applicationId correcto en proguard-rules.pro (no "com.example.app")

iOS (si aplica):
✓ Verificar: grep "STRIP_INSTALLED_PRODUCT = YES" ios/Flutter/Release.xcconfig
✓ Verificar: grep "DEAD_CODE_STRIPPING = YES" ios/Flutter/Release.xcconfig
✓ Verificar que NO hay comentarios # (excepto #include)

2. SCRIPTS

✓ test -x scripts/build_release_obfuscated.sh
✓ test -x scripts/deobfuscate.sh
✓ test -x scripts/fix_xcode_modulecache.sh (si iOS con Xcode 16.2)

3. GITIGNORE

✓ grep "build/app/outputs/mapping/" .gitignore
✓ grep "build/symbols/" .gitignore
✓ grep "*.backup" .gitignore

4. BUILD ARTIFACTS (después de ejecutar build)

Android:
✓ ls -lh build/app/outputs/apk/release/*.apk (verificar ≤17 MB cada uno)
✓ ls -lh build/app/outputs/mapping/release/mapping.txt (verificar ≥2 MB)
✓ ls build/symbols/android/*.symbols (contar 3 archivos)

iOS:
✓ ls -lh build/ios/iphoneos/Runner.app (verificar ≤15 MB)
✓ ls build/symbols/ios/app.ios-arm64.symbols

5. OFUSCACIÓN VERIFICADA

Android:
Ejecuta: strings build/app/outputs/apk/release/app-arm64-v8a-release.apk | grep -i "MainActivity"
Análisis: Solo debe aparecer ofuscado o en el package correcto

iOS:
Ejecuta: nm build/ios/iphoneos/Runner.app/Frameworks/App.framework/App | wc -l
Análisis: Número de símbolos debe ser muy reducido

═══════════════════════════════════════════════════════════

REPORTE FINAL

Genera un reporte con este formato:

✅ CONFIGURACIÓN COMPLETADA:
- android/app/build.gradle.kts: [modificado/sin cambios]
- android/app/proguard-rules.pro: [creado/existente]
- ios/Flutter/Release.xcconfig: [modificado/sin cambios]
- scripts/*.sh: [creados X archivos]
- .gitignore: [actualizado/sin cambios]

📊 MÉTRICAS DE BUILD:
Android:
- APK arm64: XX MB (reducción: XX%)
- APK armv7: XX MB (reducción: XX%)
- APK x86_64: XX MB (reducción: XX%)
- mapping.txt: XX MB
- Símbolos: X archivos

iOS:
- Runner.app: XX MB (reducción: XX%)
- Símbolos: X archivos

✅ VALIDACIONES EXITOSAS:
- [Lista de validaciones que pasaron]

⚠️ ADVERTENCIAS:
- [Lista de warnings si los hay]

❌ ERRORES ENCONTRADOS:
- [Lista de validaciones fallidas]
- [Sugerencias de corrección]

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

Checklist de Validación:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/CHECKLIST_OBFUSCATION.md

Guía Técnica Detallada:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md

Descripción del Toolkit:
https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/TOOLKIT_OVERVIEW.md
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

1. **Revisa la documentación completa**: MIGRATION_GUIDE.md
2. **Consulta troubleshooting**: TROUBLESHOOTING_ADVANCED.md
3. **Verifica con checklist**: CHECKLIST_OBFUSCATION.md
4. **Issues en GitHub**: https://github.com/carlos-developer/flutter-obfuscation-toolkit/issues

---

**Última actualización**: 2025-10-14
**Versión**: 2.0.0
**Cambios**: Reescritura completa - Lectura directa desde GitHub, sin descargas, prompts separados por plataforma
**Compatible con**: Claude Code, Gemini, Cursor AI, Windsurf
