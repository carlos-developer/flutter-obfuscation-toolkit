# 🔒 Flutter Obfuscation Toolkit

> Toolkit completo para implementar ofuscación y minificación en proyectos Flutter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.9.2-blue)](https://flutter.dev)

---

## 📦 ¿Qué es esto?

Un toolkit **standalone** que contiene todo lo necesario para implementar:
- ✅ **Ofuscación de código Dart** (100% símbolos)
- ✅ **Minificación R8** para Android (~65% reducción)
- ✅ **Symbol Stripping** para iOS
- ✅ **Scripts de automatización**
- ✅ **Documentación completa**

## ⚡ Instalación Rápida

```bash
# En tu proyecto Flutter, ejecuta:
curl -sSL https://raw.githubusercontent.com/TU_USUARIO/flutter-obfuscation-toolkit/main/scripts/download_obfuscation_package.sh | bash
```

**Eso es todo.** En 2 minutos tienes ofuscación funcionando.

---

## 📊 Resultados Esperados

| Métrica | Antes | Después |
|---------|-------|---------|
| Tamaño APK | ~40 MB | ~15 MB (-63%) |
| Símbolos Dart | 100% visible | 0% visible |
| Seguridad | 3/10 | 8/10 |

---

## 📂 Contenido del Toolkit

### Scripts de Automatización
- `setup_obfuscation.sh` - Setup interactivo automático
- `build_release_obfuscated.sh` - Build con validaciones
- `deobfuscate.sh` - Des-ofuscar crashes
- `download_obfuscation_package.sh` - Descarga automática

### Templates
- `proguard-rules.template.pro` - Reglas ProGuard listas
- `README_OBFUSCATION.md` - Referencia rápida

### Documentación Base (Desarrollo Guiado por Especificaciones)
- `01_SRS_MINIFICACION_OFUSCACION.md` - Especificación de requisitos
- `02_DDD_DOCUMENTO_DISENO_DETALLADO.md` - Diseño detallado
- `03_TIG_GUIA_IMPLEMENTACION_TECNICA.md` - Guía técnica
- `04_ASG_GUIA_AUDITORIA_SEGURIDAD.md` - Auditoría de seguridad
- `05_OPM_PROCEDIMIENTOS_OPERACIONALES.md` - Procedimientos
- `06_OTP_GUIA_OPTIMIZACION_PERFORMANCE.md` - Optimización

### Guías de Uso
- `MIGRATION_GUIDE.md` - Guía paso a paso
- `CHECKLIST_OBFUSCATION.md` - Checklist de validación
- `TROUBLESHOOTING_ADVANCED.md` - Solución de problemas
- `AI_AGENT_PROMPT.md` - Prompts para agentes CLI

---

## 🚀 Uso

### Opción 1: Descarga Automática
```bash
curl -sSL https://raw.githubusercontent.com/TU_USUARIO/flutter-obfuscation-toolkit/main/scripts/download_obfuscation_package.sh | bash
```

### Opción 2: Agente CLI (Claude Code, Gemini)
Ver `docs/AI_AGENT_PROMPT.md` para prompts listos.

### Opción 3: Manual
```bash
git clone https://github.com/TU_USUARIO/flutter-obfuscation-toolkit.git
cd tu-proyecto-flutter
cp -r ../flutter-obfuscation-toolkit/scripts ./
cp -r ../flutter-obfuscation-toolkit/templates ./
./scripts/setup_obfuscation.sh
```

---

## 📚 Documentación

- **[docs/MIGRATION_GUIDE.md](docs/MIGRATION_GUIDE.md)** - Empieza aquí
- **[docs/CHECKLIST_OBFUSCATION.md](docs/CHECKLIST_OBFUSCATION.md)** - Validación
- **[docs/TROUBLESHOOTING_ADVANCED.md](docs/TROUBLESHOOTING_ADVANCED.md)** - Problemas comunes

### Documentación Técnica Base
- **[docs/01_SRS_MINIFICACION_OFUSCACION.md](docs/01_SRS_MINIFICACION_OFUSCACION.md)** - SRS
- **[docs/02_DDD_DOCUMENTO_DISENO_DETALLADO.md](docs/02_DDD_DOCUMENTO_DISENO_DETALLADO.md)** - DDD
- **[docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md](docs/03_TIG_GUIA_IMPLEMENTACION_TECNICA.md)** - TIG

---

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE)

---

## 🤝 Contribución

Ver [CONTRIBUTING.md](CONTRIBUTING.md)

---

**⭐ Si te ayudó, dale una estrella!**
