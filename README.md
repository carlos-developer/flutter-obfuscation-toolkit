# 🔒 Flutter Obfuscation Toolkit

> Toolkit completo para implementar ofuscación y minificación en proyectos Flutter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.9.2-blue)](https://flutter.dev)

---

## ⚡ Instalación Rápida (2 minutos)

```bash
# En tu proyecto Flutter, ejecuta:
curl -sSL https://raw.githubusercontent.com/YOUR_USER/flutter-obfuscation-toolkit/main/scripts/download_obfuscation_package.sh | bash
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

### Documentación
- **[MIGRATION_GUIDE.md](docs/MIGRATION_GUIDE.md)** - Guía paso a paso (EMPIEZA AQUÍ)
- **[CHECKLIST_OBFUSCATION.md](docs/CHECKLIST_OBFUSCATION.md)** - Checklist de validación
- **[TROUBLESHOOTING_ADVANCED.md](docs/TROUBLESHOOTING_ADVANCED.md)** - Solución de problemas
- **[AI_AGENT_PROMPT.md](docs/AI_AGENT_PROMPT.md)** - Para Claude Code / Gemini

### Documentación Técnica (SDD)
- `01_SRS` - Especificación de requisitos
- `02_SAD` - Arquitectura y seguridad
- `03_TIG` - Implementación técnica
- `04_TVP` - Plan de pruebas
- `05_OPM` - Procedimientos operacionales
- `06_RTM` - Matriz de trazabilidad

---

## 🚀 Uso

### Opción 1: Script Automático
```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USER/flutter-obfuscation-toolkit/main/scripts/download_obfuscation_package.sh | bash
```

### Opción 2: Con Agente CLI (Claude Code, Gemini)
Ver [docs/AI_AGENT_PROMPT.md](docs/AI_AGENT_PROMPT.md)

### Opción 3: Manual
```bash
git clone https://github.com/YOUR_USER/flutter-obfuscation-toolkit.git
cd tu-proyecto-flutter
cp -r ../flutter-obfuscation-toolkit/scripts ./
cp -r ../flutter-obfuscation-toolkit/templates ./
./scripts/setup_obfuscation.sh
```

---

## 📚 Documentación

**Para implementar**: Lee [docs/MIGRATION_GUIDE.md](docs/MIGRATION_GUIDE.md) - Tiene todo el proceso paso a paso.

**Si hay problemas**: [docs/TROUBLESHOOTING_ADVANCED.md](docs/TROUBLESHOOTING_ADVANCED.md) - 30+ problemas comunes resueltos.

**Documentación técnica completa**: Carpeta `docs/` con 6 documentos SDD.

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
