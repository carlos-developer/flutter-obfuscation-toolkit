# 🤖 Prompt para Agentes CLI - Implementar Ofuscación Flutter

> Copia y pega este prompt completo en tu agente CLI (Claude Code, Gemini, etc.) para implementar ofuscación y minificación automáticamente

---

## 🚀 Método Recomendado: Descarga Automática

### Prompt Simplificado (Recomendado)

```
Implementa ofuscación y minificación en mi proyecto Flutter.

PASO 1 - DESCARGA AUTOMÁTICA:
Ejecuta este comando para descargar todo el paquete necesario:

curl -sSL https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/download_obfuscation_package.sh | bash

PASO 2 - PERSONALIZACIÓN AUTOMÁTICA:
1. Detecta mi applicationId desde android/app/build.gradle.kts
2. Reemplázalo en android/app/proguard-rules.pro donde dice com.example.app
3. Detecta los plugins en mi pubspec.yaml y agrega reglas ProGuard correspondientes

PASO 3 - VALIDACIÓN:
Ejecuta ./scripts/build_release_obfuscated.sh y verifica que:
- Los APKs sean ≤17 MB cada uno
- mapping.txt se genere correctamente
- Los símbolos Flutter se generen

Procede paso a paso mostrándome el progreso.
```

---

## 📋 Prompt Completo (Copiar y Pegar)

Para mayor control sobre cada paso:

```
Necesito que implementes ofuscación de código y minificación en mi proyecto Flutter actual.

CONTEXTO:
- Este es un proyecto Flutter existente en el directorio actual
- Quiero implementar ofuscación de símbolos Dart, minificación R8 para Android, y symbol stripping para iOS
- Necesito reducir el tamaño del APK/IPA y proteger mi código contra ingeniería reversa

REQUISITOS:
1. Descarga e implementa el paquete de ofuscación desde este repositorio:
   https://github.com/carlos-developer/flutter-obfuscation-toolkit

2. Sigue esta guía de implementación paso a paso:

FASE 1 - DESCARGA DE RECURSOS:
- Descarga los siguientes archivos del repositorio de referencia:
  * scripts/setup_obfuscation.sh
  * scripts/build_release_obfuscated.sh
  * scripts/deobfuscate.sh
  * templates/proguard-rules.template.pro
  * templates/README_OBFUSCATION.md
  * MIGRATION_GUIDE.md
  * CHECKLIST_OBFUSCATION.md

FASE 2 - CONFIGURACIÓN ANDROID:
- Modifica android/app/build.gradle.kts (o .gradle) para habilitar R8:
  * Agrega multiDexEnabled = true en defaultConfig
  * Agrega isMinifyEnabled = true en release buildType
  * Agrega isShrinkResources = true en release buildType
  * Configura proguardFiles con "proguard-android-optimize.txt" y "proguard-rules.pro"

- Crea android/app/proguard-rules.pro con reglas para:
  * Flutter core (io.flutter.**)
  * MainActivity (reemplazar com.example.app con el applicationId real del proyecto)
  * AndroidX components
  * JNI y reflection
  * Google Play Core
  * Plugins específicos que detectes en pubspec.yaml (sqflite, firebase, shared_preferences, etc.)

FASE 3 - CONFIGURACIÓN iOS:
- Modifica ios/Runner.xcodeproj/project.pbxproj para agregar en Release y Profile:
  * DEAD_CODE_STRIPPING = YES
  * DEPLOYMENT_POSTPROCESSING = YES
  * STRIP_INSTALLED_PRODUCT = YES
  * STRIP_STYLE = "non-global"
  * STRIP_SWIFT_SYMBOLS = YES
  * SYMBOLS_HIDDEN_BY_DEFAULT = YES
  * DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym"

FASE 4 - SCRIPTS Y AUTOMATIZACIÓN:
- Copia los scripts descargados a scripts/
- Hazlos ejecutables (chmod +x)
- Actualiza .gitignore con exclusiones de ofuscación

FASE 5 - VALIDACIÓN:
- Ejecuta flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi
- Verifica que se generen:
  * APKs en build/app/outputs/apk/release/ (~13-17 MB cada uno)
  * mapping.txt en build/app/outputs/mapping/release/ (~2-5 MB)
  * Símbolos Flutter en build/symbols/android/ (3 archivos .symbols)
- Instala en dispositivo físico y prueba funcionalidades críticas

PERSONALIZACIÓN REQUERIDA:
- En android/app/proguard-rules.pro:
  * Reemplaza com.example.app con el applicationId real del proyecto
  * Agrega reglas específicas para modelos de datos (si usa JSON serialization)
  * Agrega reglas para plugins detectados en pubspec.yaml

RESULTADO ESPERADO:
- Reducción de tamaño APK: ≥60%
- Símbolos Dart: 100% ofuscados
- Build time: +30-50% (aceptable)
- Security score: ≥8/10

INSTRUCCIONES ADICIONALES:
- Lee y sigue la documentación en MIGRATION_GUIDE.md descargado
- Usa CHECKLIST_OBFUSCATION.md para validar cada paso
- Si encuentras errores, consulta TROUBLESHOOTING_ADVANCED.md
- NO commitees archivos .backup ni mapping.txt al git
- Crea un commit final con mensaje descriptivo cuando todo funcione

IMPORTANTE:
- Detecta automáticamente el applicationId del proyecto desde android/app/build.gradle.kts
- Detecta plugins en pubspec.yaml y agrega reglas ProGuard correspondientes
- Valida que todos los archivos críticos se generen correctamente
- Prueba que la app funcione después de ofuscar

¿Puedes implementar esto paso a paso, mostrándome el progreso y validando cada fase?
```

---

## 🚀 Prompt Alternativo (Con Descarga Automática)

Si prefieres que el agente descargue automáticamente los archivos:

```
Implementa ofuscación y minificación en mi proyecto Flutter usando este paquete de referencia.

PASO 1 - DESCARGA AUTOMÁTICA:
Descarga los archivos necesarios desde el repositorio:
https://github.com/carlos-developer/flutter-obfuscation-toolkit

Archivos requeridos:
- scripts/setup_obfuscation.sh
- scripts/build_release_obfuscated.sh
- scripts/deobfuscate.sh
- templates/proguard-rules.template.pro
- MIGRATION_GUIDE.md

Usa comandos curl o wget para descargar desde la rama principal.

PASO 2 - EJECUTAR SETUP AUTOMÁTICO:
Ejecuta: ./scripts/setup_obfuscation.sh

PASO 3 - PERSONALIZACIÓN:
1. Detecta el applicationId real desde android/app/build.gradle.kts
2. Reemplaza com.example.app en android/app/proguard-rules.pro con el applicationId detectado
3. Detecta plugins en pubspec.yaml y agrega reglas ProGuard correspondientes:
   - Si usa sqflite: -keep class com.tekartik.sqflite.** { *; }
   - Si usa firebase: -keep class io.flutter.plugins.firebase.** { *; }
   - Si usa shared_preferences: -keep class io.flutter.plugins.sharedpreferences.** { *; }
   - Etc.

PASO 4 - VALIDACIÓN:
Ejecuta: ./scripts/build_release_obfuscated.sh
Verifica que los APKs generados sean ≤17 MB

PASO 5 - DOCUMENTACIÓN:
Muestra un resumen de:
- Archivos modificados
- Reducción de tamaño lograda
- Próximos pasos recomendados

Procede paso a paso, validando cada fase antes de continuar.
```

---

## 📦 Prompt Simplificado (Mínimo)

Para usuarios que quieren el mínimo de configuración:

```
Implementa ofuscación Flutter en este proyecto.

Requisitos:
1. Descarga el setup desde: https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/setup_obfuscation.sh
2. Ejecuta el script de setup
3. Personaliza android/app/proguard-rules.pro con mi applicationId
4. Valida con un build de prueba

Muestra el progreso y valida que funcione.
```

---

## 🛠️ Comandos de Descarga Manual

Si el agente no puede descargar automáticamente, proporciona estos comandos:

### Opción A: Usando curl

```bash
# Crear directorios
mkdir -p scripts templates

# Descargar scripts
curl -o scripts/setup_obfuscation.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/setup_obfuscation.sh
curl -o scripts/build_release_obfuscated.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
curl -o scripts/deobfuscate.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh

# Descargar templates
curl -o templates/proguard-rules.template.pro https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/proguard-rules.template.pro
curl -o templates/README_OBFUSCATION.md https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/README_OBFUSCATION.md

# Descargar documentación
curl -o MIGRATION_GUIDE.md https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
curl -o CHECKLIST_OBFUSCATION.md https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/CHECKLIST_OBFUSCATION.md

# Hacer ejecutables
chmod +x scripts/*.sh

echo "✅ Paquete descargado. Ejecuta: ./scripts/setup_obfuscation.sh"
```

### Opción B: Usando wget

```bash
# Crear directorios
mkdir -p scripts templates

# Descargar scripts
wget -O scripts/setup_obfuscation.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/setup_obfuscation.sh
wget -O scripts/build_release_obfuscated.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/build_release_obfuscated.sh
wget -O scripts/deobfuscate.sh https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/deobfuscate.sh

# Descargar templates
wget -O templates/proguard-rules.template.pro https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/proguard-rules.template.pro
wget -O templates/README_OBFUSCATION.md https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/templates/README_OBFUSCATION.md

# Descargar documentación
wget -O MIGRATION_GUIDE.md https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/MIGRATION_GUIDE.md
wget -O CHECKLIST_OBFUSCATION.md https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/CHECKLIST_OBFUSCATION.md

# Hacer ejecutables
chmod +x scripts/*.sh

echo "✅ Paquete descargado. Ejecuta: ./scripts/setup_obfuscation.sh"
```

### Opción C: Clonar solo el paquete (sparse checkout)

```bash
# Clonar solo los archivos necesarios
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/carlos-developer/flutter-obfuscation-toolkit.git temp_obfuscation

cd temp_obfuscation
git sparse-checkout set scripts templates *.md

# Copiar al proyecto actual
cp -r scripts ../
cp -r templates ../
cp MIGRATION_GUIDE.md CHECKLIST_OBFUSCATION.md TROUBLESHOOTING_ADVANCED.md ../

cd ..
rm -rf temp_obfuscation

chmod +x scripts/*.sh

echo "✅ Paquete copiado. Ejecuta: ./scripts/setup_obfuscation.sh"
```

---

## 🎯 Uso Recomendado por Agente

### Para Claude Code

```
Copiar y pegar el "Prompt Completo" al inicio de la conversación.
Claude Code puede:
- Descargar archivos con WebFetch (si está habilitado)
- Modificar archivos automáticamente
- Ejecutar scripts con Bash
- Validar resultados
```

### Para Gemini CLI

```
Copiar y pegar el "Prompt Alternativo" con descarga automática.
Gemini puede:
- Ejecutar comandos curl/wget
- Modificar archivos
- Ejecutar scripts
- Proporcionar feedback del progreso
```

### Para GitHub Copilot / Cursor

```
Usar el "Prompt Simplificado" y luego seguir manualmente los pasos
con la ayuda del agente para cada modificación de archivo.
```

---

## 📝 Ejemplo de Conversación Esperada

**Usuario**:
```
[Pega el prompt completo]
```

**Agente**:
```
Entendido. Voy a implementar ofuscación y minificación en tu proyecto Flutter.

FASE 1 - DESCARGA DE RECURSOS
Descargando archivos necesarios...
✅ scripts/setup_obfuscation.sh descargado
✅ scripts/build_release_obfuscated.sh descargado
✅ scripts/deobfuscate.sh descargado
✅ templates/proguard-rules.template.pro descargado
✅ MIGRATION_GUIDE.md descargado

FASE 2 - DETECCIÓN DE PROYECTO
Analizando tu proyecto...
- Project name: mi_app
- Application ID detectado: com.miempresa.miapp
- Plugins detectados: sqflite, shared_preferences, firebase_core

FASE 2 - CONFIGURACIÓN ANDROID
Modificando android/app/build.gradle.kts...
✅ multiDexEnabled agregado
✅ R8 minification habilitado
✅ ProGuard configurado

Creando android/app/proguard-rules.pro...
✅ Reglas Flutter core agregadas
✅ MainActivity: com.miempresa.miapp.MainActivity
✅ Reglas para sqflite agregadas
✅ Reglas para shared_preferences agregadas
✅ Reglas para firebase_core agregadas

FASE 3 - CONFIGURACIÓN iOS
Modificando ios/Runner.xcodeproj/project.pbxproj...
✅ Symbol stripping configurado (Release)
✅ Symbol stripping configurado (Profile)

FASE 4 - SCRIPTS
✅ Scripts copiados a scripts/
✅ Permisos de ejecución configurados
✅ .gitignore actualizado

FASE 5 - VALIDACIÓN
Ejecutando build de prueba...
flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi

✅ Build exitoso!
✅ APK arm64: 14.2 MB (reducción: 67%)
✅ APK armv7: 12.8 MB (reducción: 69%)
✅ mapping.txt generado: 3.4 MB
✅ Símbolos Flutter generados (3 archivos)

RESUMEN:
- Reducción de tamaño: 67% promedio
- Símbolos Dart: 100% ofuscados
- Build time: +35% (aceptable)

PRÓXIMOS PASOS:
1. Prueba la app en un dispositivo físico
2. Verifica todas las funcionalidades críticas
3. Si hay crashes, usa: ./scripts/deobfuscate.sh -p android -s crash.txt
4. Archiva mapping.txt en releases/ para esta versión

¿Deseas que proceda con algún paso adicional?
```

---

## ✅ Checklist de Validación Post-Implementación

Después de que el agente implemente la ofuscación, verifica:

- [ ] Archivos descargados en scripts/ y templates/
- [ ] android/app/build.gradle.kts modificado correctamente
- [ ] android/app/proguard-rules.pro creado con applicationId correcto
- [ ] ios/Runner.xcodeproj/project.pbxproj modificado (si aplica)
- [ ] Build exitoso con APKs generados
- [ ] mapping.txt y símbolos generados
- [ ] .gitignore actualizado
- [ ] App probada en dispositivo físico

---

## 🆘 Troubleshooting del Prompt

### Si el agente no puede descargar archivos

**Solución**: Ejecuta manualmente los comandos curl/wget de la sección "Comandos de Descarga Manual" y luego pide al agente que continúe desde FASE 2.

### Si el agente no detecta el applicationId

**Solución**: Proporciona manualmente:
```
Mi applicationId es: com.miempresa.miapp
Úsalo para reemplazar com.example.app en proguard-rules.pro
```

### Si el build falla

**Solución**: Pide al agente:
```
El build falló con este error: [pegar error]
Consulta TROUBLESHOOTING_ADVANCED.md y dame la solución
```

---

## 📚 Recursos Adicionales

- **Repositorio**: https://github.com/carlos-developer/flutter-obfuscation-toolkit
- **Documentación completa**: Ver MIGRATION_GUIDE.md en el repositorio
- **Troubleshooting**: Ver TROUBLESHOOTING_ADVANCED.md en el repositorio

---

## 💡 Consejos para Mejores Resultados

1. **Inicia la conversación con el prompt completo** en un mensaje único
2. **Proporciona contexto adicional** si tu proyecto usa frameworks específicos (Riverpod, Bloc, GetX)
3. **Revisa cada fase** antes de que el agente continúe
4. **Valida el build final** en un dispositivo físico
5. **Guarda el mapping.txt** de cada release

---

**Última actualización**: 2025-10-11
**Versión**: 1.0.0
**Compatible con**: Claude Code, Gemini CLI, GitHub Copilot, Cursor AI
