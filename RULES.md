# 🔒 Reglas de Trazabilidad para Agentes IA

> **8 Reglas Obligatorias para garantizar conformidad completa con el toolkit**

---

## ⚠️ INSTRUCCIONES OBLIGATORIAS SI ERES UN AGENTE IA

Si eres un agente IA (Claude Code, Gemini, Cursor, etc.) implementando este toolkit, **DEBES cumplir estas 8 reglas obligatorias** para garantizar trazabilidad completa y validación de cada paso.

---

## 📋 REGLA 1: Declarar Fuente ANTES de Cada Cambio

**ANTES** de realizar cualquier modificación, declara explícitamente:

```
🎯 PASO INICIADO - [ARCHIVO_FUENTE]

📖 Sección: [nombre de la sección]
📄 Líneas: [número de líneas]
⚙️  Acción: [descripción breve]
🔄 Estado: INICIANDO

════════════════════════════════════════
```

**Ejemplo**:
```
🎯 PASO INICIADO - MIGRATION_GUIDE.md

📖 Sección: "Paso 1.1 - Modificar build.gradle.kts"
📄 Líneas: 373-402
⚙️  Acción: Agregar configuraciones R8 (multiDexEnabled, isMinifyEnabled, isShrinkResources)
🔄 Estado: INICIANDO

════════════════════════════════════════
```

---

## ✅ REGLA 2: Checkpoint DESPUÉS de Cada Cambio

**DESPUÉS** de cada modificación, ejecuta validación con comandos bash (grep, test, etc.):

```
✅ CHECKPOINT - [nombre del paso]

Archivo modificado: [ruta del archivo]
Validaciones ejecutadas:
  grep "isMinifyEnabled" android/app/build.gradle.kts → ✅ ENCONTRADO
  grep "isShrinkResources" android/app/build.gradle.kts → ✅ ENCONTRADO
  test -f android/app/proguard-rules.pro → ✅ EXISTE

Estado: ✅ VALIDADO
```

**Si falla**: Reporta el error, revierte cambios y solicita intervención.

---

## 🔍 REGLA 3: Verificar Personalización (NO Templates Genéricos)

**DESPUÉS** de crear archivos desde templates, verifica que NO quedan valores genéricos:

```
🔍 VERIFICACIÓN DE PERSONALIZACIÓN

Archivo: android/app/proguard-rules.pro
Validación anti-genéricos:
  grep "com.example.app" android/app/proguard-rules.pro → ❌ NO ENCONTRADO ✅

applicationId real detectado: com.miapp.real
Personalización: ✅ COMPLETA
```

**CRÍTICO**: Si encuentras "com.example.app" u otros valores genéricos, DETENTE y personaliza correctamente.

---

## 📊 REGLA 4: Reporte de Conformidad por Fase

**AL FINALIZAR** cada fase completa (Android, iOS, Scripts, Validación), genera reporte:

```
📊 REPORTE - FASE [número] COMPLETADA ([nombre])

Pasos ejecutados: X/X ✅
├─ Paso 1 → ✅ (checkpoint pasó)
├─ Paso 2 → ✅ (personalizado)
└─ Paso 3 → ✅

Conformidad: 100%
Próxima fase: [nombre de la siguiente fase]
```

---

## 🚨 REGLA 5: Alertar Desviaciones Inmediatamente

**SI** detectas que estás por hacer algo NO documentado en el toolkit:

```
🚨 ALERTA: ACCIÓN NO DOCUMENTADA

Acción intentada: [descripción]
Búsqueda en MIGRATION_GUIDE.md: NO ENCONTRADO

🛑 DETENIENDO - Solicitando confirmación del usuario
```

**NO** realices acciones no documentadas sin confirmación explícita del usuario.

---

## 📝 REGLA 6: Registro de Auditoría Final

**AL COMPLETAR** toda la implementación, genera registro completo:

```
📝 AUDITORÍA FINAL - IMPLEMENTACIÓN COMPLETADA

═══════════════════════════════════════════

RESUMEN DE FASES:
✅ Fase 1 - Android: X/X pasos (100%)
✅ Fase 2 - iOS: X/X pasos (100%)
✅ Fase 3 - Scripts: X/X pasos (100%)
✅ Fase 4 - Validación: X/X pasos (100%)

CONFORMIDAD TOTAL: 100% ✅

ARCHIVOS MODIFICADOS (con trazabilidad):
1. [archivo] → Líneas [X-Y] [fuente]
2. [archivo] → Líneas [X-Y] [fuente] (personalizado ✅)
[... resto de archivos ...]

VALIDACIÓN REQUERIDA:
[comandos de validación ejecutados]

CERTIFICACIÓN: ✅ Implementación conforme al toolkit
═══════════════════════════════════════════
```

---

## 🔒 REGLA 7: Validación Manual ANTES de Script Automático

**⚠️ CAMBIO CRÍTICO**: Los agentes IA NO deben delegar validaciones al script validate-implementation.sh

### ✅ Lo que DEBES hacer (Validación Manual):

**ANTES de ejecutar validate-implementation.sh**, ejecuta TÚ MISMO estas validaciones:

1. **Ejecutar builds manualmente**:
   ```bash
   # Limpiar primero
   flutter clean

   # Android (si configuraste)
   flutter build apk --release --obfuscate --split-debug-info=build/symbols

   # iOS (si configuraste y estás en macOS)
   flutter build ios --release --obfuscate --split-debug-info=build/symbols
   ```

2. **Verificar archivos generados MANUALMENTE**:
   ```bash
   # Android
   ls -lh build/app/outputs/mapping/release/mapping.txt
   wc -l build/app/outputs/mapping/release/mapping.txt
   ls -lh build/symbols/app.android-*.symbols

   # iOS
   file build/ios/iphoneos/Runner.app/Runner
   nm build/ios/iphoneos/Runner.app/Runner | head -20
   ls -lh build/symbols/app.ios-*.symbols
   ```

3. **Inspeccionar binarios MANUALMENTE**:
   ```bash
   # Android: Verificar clases ofuscadas
   unzip -q build/app/outputs/flutter-apk/app-release.apk classes.dex -d /tmp/
   strings /tmp/classes.dex | grep -E "^La/[a-z];"

   # Android: Verificar libapp.so stripped
   unzip -q build/app/outputs/flutter-apk/app-release.apk lib/arm64-v8a/libapp.so -d /tmp/
   file /tmp/lib/arm64-v8a/libapp.so | grep "stripped"

   # iOS: Verificar símbolos
   nm -U build/ios/iphoneos/Runner.app/Frameworks/App.framework/App
   ```

4. **Genera reporte final** con TODOS los resultados:
   ```
   📊 REPORTE VALIDACIÓN MANUAL - REGLA 7

   Plataformas configuradas: [Android, iOS]

   ANDROID:
   ✅ Build ejecutado manualmente
   ✅ mapping.txt: 39,020 líneas, 3.8MB
   ✅ Compiler R8 confirmado
   ✅ Clases ofuscadas: La/a; detectadas
   ✅ libapp.so: STRIPPED confirmado (file command)
   ✅ Símbolos: 3 archivos generados

   iOS:
   ✅ Build ejecutado manualmente
   ✅ Runner binario: <redacted function> confirmado
   ✅ App.framework: 4 símbolos expuestos (nm -U)
   ✅ Tamaños: Runner 107KB, App.framework 2.9MB
   ✅ Símbolos: app.ios-arm64.symbols 1.3MB

   CERTIFICACIÓN:
   ✅ TODAS las validaciones ejecutadas MANUALMENTE por agente IA
   ✅ CERO delegación a scripts
   ✅ Inspección directa de binarios completada
   ```

### ❌ Lo que NO debes hacer:

- ❌ **NO descargues** scripts de validación
- ❌ **NO ejecutes** validate-implementation.sh
- ❌ **NO delegues** ninguna validación a scripts externos
- ❌ **NO asumas** que funciona sin inspeccionar binarios tú mismo
- ❌ **NO uses** herramientas automáticas del toolkit

### ✅ Lo que SÍ debes hacer:

- ✅ **EJECUTA todos los builds** manualmente con flutter build
- ✅ **INSPECCIONA todos los binarios** con file, nm, strings, otool
- ✅ **VERIFICA todos los archivos** con ls, wc, grep, head
- ✅ **ANALIZA el contenido** de mapping.txt, símbolos, APKs
- ✅ **GENERA reportes detallados** con resultados reales observados

**CRÍTICO**:
- Si configuraste Android + iOS → VALIDA AMBAS plataformas TÚ MISMO
- Cada validación debe ser ejecutada DIRECTAMENTE por ti
- NO existen atajos mediante scripts
- Maximiza el control y la inspección directa

---

## ⚠️ REGLA 8: Verificación Previa ANTES de Usar Recursos Externos

**ANTES** de intentar descargar/usar CUALQUIER archivo/script/recurso externo del repositorio, **DEBES**:

1. **LISTAR primero** el contenido del directorio/repositorio usando API de GitHub o WebFetch
2. **VERIFICAR** que los nombres exactos de archivos existen
3. **CONFIRMAR** que las URLs son válidas
4. **SOLO ENTONCES** descargar/usar con nombres EXACTOS verificados

**Formato de verificación**:
```
🔍 VERIFICACIÓN PREVIA - REGLA 8

Recurso a usar: [nombre del archivo/script]
Directorio remoto: https://github.com/.../scripts/

Paso 1: Listar contenido
  curl https://api.github.com/repos/user/repo/contents/scripts
  → Resultado: ["build_release_obfuscated.sh", "validate-implementation.sh", ...]

Paso 2: Verificar nombre exacto
  Buscado: "build_obfuscated.sh" ❌
  Encontrado: "build_release_obfuscated.sh" ✅

Paso 3: Confirmar URL
  URL verificada: https://.../ build_release_obfuscated.sh ✅

Estado: ✅ VERIFICADO - Procedo a descargar con nombre exacto
```

**Por qué es crítico**:
- Evita errores 404 por nombres asumidos incorrectamente
- Garantiza que usas los nombres reales del repositorio
- Reduce tiempo de debugging por recursos inexistentes
- Mantiene trazabilidad de qué archivos realmente existen

### ❌ CASO REAL DE ERROR (Violación REGLA 8)

**Contexto**: Un agente IA leyó en MIGRATION_GUIDE.md la sección "Paso 3: Crear Scripts de Automatización" que decía:

> "Crea los scripts en tu proyecto leyendo el contenido desde el repositorio"

**Error cometido**:
```
❌ El agente asumió que debía CREAR un script build-release.sh
❌ Inventó contenido basándose en lo que "debería hacer" un script
❌ NO verificó primero qué scripts existen en el repositorio
❌ NO listó el contenido del directorio scripts/ del toolkit
```

**Lo que DEBIÓ hacer (REGLA 8)**:
```bash
# 1. PRIMERO: Listar scripts disponibles
curl -s https://api.github.com/repos/carlos-developer/flutter-obfuscation-toolkit/contents/scripts | grep '"name"'

# Resultado:
# "name": "build_release_obfuscated.sh"  ← Nombre real
# "name": "deobfuscate.sh"
# "name": "fix_xcode_modulecache.sh"
# "name": "setup_obfuscation.sh"
# "name": "validate-implementation.sh"

# 2. DESPUÉS: Descargar con nombres exactos verificados
curl -o scripts/build_release_obfuscated.sh \
  https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
```

**Lección aprendida**:
- ✅ **SIEMPRE verifica** primero qué archivos existen
- ✅ **NUNCA asumas** nombres de archivos o contenido
- ✅ **USA GitHub API** para listar contenido antes de descargar
- ✅ **Descarga literalmente** lo que existe, no lo que crees que debería existir

---

## 📌 RESUMEN DE EJECUCIÓN

**Secuencia obligatoria**:

1. **Antes de cada cambio** → Declara fuente (REGLA 1)
2. **Después de cada cambio** → Ejecuta checkpoint (REGLA 2)
3. **Después de crear templates** → Verifica personalización (REGLA 3)
4. **Al finalizar cada fase** → Genera reporte (REGLA 4)
5. **Si algo no está documentado** → Alerta y detente (REGLA 5)
6. **Antes de usar recursos externos** → Verifica que existen primero (REGLA 8)
7. **Antes de auditoría final** → Ejecuta TODAS las validaciones MANUALMENTE (REGLA 7)
8. **Al completar TODO y validar** → Genera auditoría final (REGLA 6)

**Estas 8 reglas son OBLIGATORIAS para garantizar conformidad completa con el toolkit.**

**⚠️ IMPORTANTE PARA AGENTES IA**:
- **NO descargues scripts** del repositorio toolkit
- **NO ejecutes scripts** de validación o automatización
- **TODO debe ser hecho MANUALMENTE** por ti como agente IA
- Los scripts en el repositorio son **solo para usuarios humanos como referencia opcional**

---

**Última actualización**: 2025-10-15
**Versión**: 3.0.0
**Aplicable a**: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md, AI_AGENT_PROMPT.md, todos los prompts del toolkit
