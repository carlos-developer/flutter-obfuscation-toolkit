# 🔒 Flutter Obfuscation Toolkit

> Toolkit completo para implementar ofuscación y optimización de tamaño en proyectos Flutter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.9.2-blue)](https://flutter.dev)

**Repositorio**: https://github.com/carlos-developer/flutter-obfuscation-toolkit

---

## ⚡ Inicio Rápido

### Con Agente IA (Claude Code, Gemini, Cursor)

Copia un prompt de **[AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md)** según tu plataforma:
- Android + iOS (completo)
- Solo Android
- Solo iOS
- Verificación

El agente leerá este repositorio y configurará tu proyecto automáticamente.

### Manual

Sigue **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** paso a paso.

**Resultado**: APK reducido ~65%, símbolos 100% ofuscados, validación técnica incluida.

---

## 📦 Contenido del Toolkit

### 📜 Guías Principales
| Documento | Propósito |
|-----------|-----------|
| **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** | Guía paso a paso de implementación (EMPIEZA AQUÍ) |
| **[RULES.md](RULES.md)** | 8 reglas obligatorias de trazabilidad para agentes IA |
| **[VALIDATION_GUIDE.md](VALIDATION_GUIDE.md)** | Validación técnica profunda de ofuscación |
| **[AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md)** | Prompts detallados para agentes IA |
| **[TROUBLESHOOTING_ADVANCED.md](TROUBLESHOOTING_ADVANCED.md)** | Solución de 30+ problemas comunes |
| **[IOS_MANUAL_STEPS.md](IOS_MANUAL_STEPS.md)** | Pasos manuales iOS (Xcode 16.2) |

### 🛠️ Scripts
| Script | Función |
|--------|---------|
| `validate-implementation.sh` | **Validación automática** (4 fases: config, build, artifacts, ofuscación técnica) |
| `build_release_obfuscated.sh` | Build automatizado con validaciones |
| `deobfuscate.sh` | Des-ofuscar crashes de producción |
| `fix_xcode_modulecache.sh` | Fix para Xcode 16.2 ModuleCache |
| `setup_obfuscation.sh` | Setup automático completo |

### 📋 Templates
| Template | Uso |
|----------|-----|
| `proguard-rules.template.pro` | Reglas ProGuard/R8 para Android |
| `Release.xcconfig.template` | Configuración iOS (symbol stripping) |
| `README_OBFUSCATION.md` | Referencia rápida de comandos |

### 📄 Especificaciones Técnicas
| Archivo | Descripción |
|---------|-------------|
| `docs/` | Documentación SDD completa (SRS, SAD, TIG, TVP, OPM, RTM) |

---

## 🎯 Flujo de Trabajo

```
1. Lee AI_AGENT_PROMPT.md o MIGRATION_GUIDE.md
2. Implementa configuración (Android/iOS/Ambos)
3. Ejecuta validate-implementation.sh
4. Verifica FASE 4 (validación técnica de ofuscación)
5. Si exit code 0 → ✅ Listo para producción
```

**Filosofía**: Este toolkit es una **referencia**. No copies archivos del toolkit a tu proyecto. Lee desde aquí y crea archivos personalizados en tu proyecto.

---

## 📊 Resultados Esperados

| Plataforma | Antes | Después | Reducción |
|------------|-------|---------|-----------|
| Android arm64 | ~40 MB | ~15 MB | **-63%** |
| Android armv7 | ~35 MB | ~11 MB | **-69%** |
| iOS arm64 | ~25 MB | ~13 MB | **-48%** |

**Validación Técnica Incluida**:
- ✅ R8/ProGuard activo (Android)
- ✅ mapping.txt >10,000 líneas
- ✅ Nombres Dart NO visibles en binarios
- ✅ Symbol stripping aplicado (iOS)

---

## 🔧 Validación Automática

```bash
# Ejecutar script de validación (4 fases)
curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
```

**FASE 4** valida técnicamente que la ofuscación funciona:
- Android: R8 activo, ofuscación Dart, dead code elimination
- iOS: Binario stripped, tamaño optimizado, símbolos separados

Ver documentación completa: **[VALIDATION_GUIDE.md](VALIDATION_GUIDE.md)**

---

## 📚 Documentación por Caso de Uso

| Necesitas | Documento |
|-----------|-----------|
| Implementar desde cero | [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) |
| Usar con agente IA | [AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md) |
| Validar implementación | [VALIDATION_GUIDE.md](VALIDATION_GUIDE.md) |
| Resolver errores | [TROUBLESHOOTING_ADVANCED.md](TROUBLESHOOTING_ADVANCED.md) |
| Pasos manuales iOS | [IOS_MANUAL_STEPS.md](IOS_MANUAL_STEPS.md) |

---

## 🤖 Compatibilidad con Agentes IA

| Agente | Estado | Características |
|--------|--------|-----------------|
| Claude Code | ✅ Compatible | WebFetch, Write, Bash |
| Gemini | ✅ Compatible | Fetch, Write, Shell |
| Cursor AI | ✅ Compatible | Fetch, Write, Terminal |
| Windsurf | ✅ Compatible | Fetch, Write, Shell |
| GitHub Copilot | ⚠️ Parcial | Limitado (solo Edit) |

---

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE)

---

## 🤝 Contribución

Pull requests bienvenidos. Para cambios grandes, abre un issue primero.

**Issues**: https://github.com/carlos-developer/flutter-obfuscation-toolkit/issues

---

**Última actualización**: 2025-10-15 | **Versión**: 3.0.0

**⭐ Si te ayudó, dale una estrella en GitHub!**
