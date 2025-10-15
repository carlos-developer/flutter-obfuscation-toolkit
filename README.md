# 🔒 Flutter Obfuscation Toolkit

> Toolkit completo para implementar ofuscación y minificación en proyectos Flutter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.9.2-blue)](https://flutter.dev)

📖 **[Ver Visión General del Toolkit](TOOLKIT_OVERVIEW.md)** - Guía completa de estructura y uso de documentos

---

## ⚡ Instalación Rápida (2 minutos)

### Con Agente IA (Recomendado)
```
Abre Claude Code / Gemini / Cursor y pega:

Implementa ofuscación y optimización de tamaño Flutter para Android e iOS siguiendo: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md

Usa la especificación estructurada en agent-instructions.json para validaciones paso a paso.
Al finalizar ejecuta validate-implementation.sh.
```

### Manual
```bash
# Ver guía completa en MIGRATION_GUIDE.md
# El agente lee templates del repositorio y crea archivos en TU proyecto
# NO se copian archivos del toolkit
```

**Resultado**: APK reducido ~65%, símbolos 100% ofuscados, seguridad 8/10

---

## 📦 ¿Qué Incluye?

### Scripts de Automatización
- `setup_obfuscation.sh` - Configura todo automáticamente
- `build_release_obfuscated.sh` - Build con validaciones
- `deobfuscate.sh` - Des-ofuscar crashes de producción

### Templates
- `proguard-rules.template.pro` - Reglas ProGuard listas para usar
- `README_OBFUSCATION.md` - Referencia rápida de comandos

### Especificación para Agentes IA
- `agent-instructions.json` - Especificación procesable (JSON) para validaciones automáticas y protocolo de trazabilidad
- `validate-implementation.sh` - Script de validación automática de plataformas configuradas

### Guías de Uso
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Guía paso a paso (EMPIEZA AQUÍ)
- **[CHECKLIST_OBFUSCATION.md](CHECKLIST_OBFUSCATION.md)** - Checklist de validación
- **[TROUBLESHOOTING_ADVANCED.md](TROUBLESHOOTING_ADVANCED.md)** - Solución de problemas comunes
- **[AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md)** - Prompts para agentes CLI (Claude/Gemini)

### Especificación Técnica (SDD)
Documentación detallada del proceso de desarrollo guiado por especificaciones en `docs/`:
- `01_SRS` - Requisitos del sistema
- `02_SAD` - Diseño de arquitectura
- `03_TIG` - Guía de implementación
- `04_TVP` - Plan de pruebas
- `05_OPM` - Procedimientos operacionales
- `06_RTM` - Matriz de trazabilidad

---

## 🚀 Uso

### Opción 1: Con Agente IA (⚡ Más Rápido)
```
Copia el prompt de AI_AGENT_PROMPT.md y pégalo en:
- Claude Code
- Gemini
- Cursor AI
- Windsurf

El agente lee este repositorio y configura TU proyecto automáticamente.
```
Ver [AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md)

### Opción 2: Manual
```bash
# Sigue la guía paso a paso
# Lee templates desde el repositorio
# Crea archivos personalizados en tu proyecto
```
Ver [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)

**Filosofía**: Este toolkit es una **guía de referencia**. No copies archivos del toolkit a tu proyecto. Los agentes IA o tú deben **leer** desde aquí y **crear** archivos personalizados en tu proyecto.

---

## 📚 Documentación

**Para implementar**: [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) - Proceso paso a paso

**Si hay problemas**: [TROUBLESHOOTING_ADVANCED.md](TROUBLESHOOTING_ADVANCED.md) - 30+ casos resueltos

**Con agente CLI**: [AI_AGENT_PROMPT.md](AI_AGENT_PROMPT.md) - Prompts listos para copiar

**Especificación técnica**: Carpeta `docs/` con documentación SDD completa

---

## 📊 Resultados Esperados

| Métrica | Antes | Después |
|---------|-------|---------|
| Tamaño APK | ~40 MB | ~15 MB (-63%) |
| Símbolos Dart | 100% visible | 0% visible |
| Seguridad | 3/10 | 8/10 |
| Tiempo setup | 2-3 horas | 5 minutos |

---

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE)

---

## 🤝 Contribución

Pull requests bienvenidos. Para cambios grandes, abre un issue primero.

---

**⭐ Si te ayudó, dale una estrella en GitHub!**
