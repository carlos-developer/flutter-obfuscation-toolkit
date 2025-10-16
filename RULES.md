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

## 🔒 REGLA 7: Validación Automática de TODAS las Plataformas Configuradas

**AL FINALIZAR** la implementación completa, ANTES de generar auditoría final:

1. **Detecta qué plataformas configuraste**:
   ```bash
   # Android configurado si existe:
   grep -q "isMinifyEnabled" android/app/build.gradle*

   # iOS configurado si existe:
   grep -q "STRIP_INSTALLED_PRODUCT" ios/Flutter/Release.xcconfig
   ```

2. **Ejecuta el script de validación automática**:
   ```bash
   curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
   ```

3. **SOLO si el script retorna exit code 0**, genera la auditoría final

**CRÍTICO**:
- Si configuraste Android + iOS → DEBES validar AMBAS plataformas con sus builds
- NO asumas que funciona sin validar cada plataforma configurada
- NO marques como completo si el script falla

**Formato de validación**:
```
🔒 VALIDACIÓN AUTOMÁTICA - REGLA 7

Plataformas configuradas: [Android, iOS]
Script ejecutado: validate-implementation.sh
Resultado: ✅ Exit code 0

Validaciones por plataforma:
  Android:
    ✅ Build ejecutado
    ✅ FASE 4: Ofuscación técnica validada
    ✅ mapping.txt generado (>10,000 líneas)
    ✅ Símbolos generados

  iOS:
    ✅ Build ejecutado
    ✅ FASE 4: Stripping técnico validado
    ✅ Binario stripped
    ✅ Símbolos generados

Estado: ✅ TODAS LAS PLATAFORMAS VALIDADAS
```

**Si falla**: Identifica el error, corrige, re-ejecuta. NO continúes hasta que pase.

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

---

## 📌 RESUMEN DE EJECUCIÓN

**Secuencia obligatoria**:

1. **Antes de cada cambio** → Declara fuente (REGLA 1)
2. **Después de cada cambio** → Ejecuta checkpoint (REGLA 2)
3. **Después de crear templates** → Verifica personalización (REGLA 3)
4. **Al finalizar cada fase** → Genera reporte (REGLA 4)
5. **Si algo no está documentado** → Alerta y detente (REGLA 5)
6. **Antes de usar recursos externos** → Verifica que existen primero (REGLA 8)
7. **Antes de auditoría final** → Ejecuta validación automática (REGLA 7)
8. **Al completar TODO y validar** → Genera auditoría final (REGLA 6)

**Estas 8 reglas son OBLIGATORIAS para garantizar conformidad completa con el toolkit.**

---

**Última actualización**: 2025-10-15
**Versión**: 3.0.0
**Aplicable a**: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md, AI_AGENT_PROMPT.md, todos los prompts del toolkit
