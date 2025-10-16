#!/bin/bash

# ============================================
# Script: setup_obfuscation.sh
# Descripción: Configurar ofuscación y minificación en cualquier proyecto Flutter
# Versión: 1.0.0
# Uso: ./setup_obfuscation.sh [project_path]
# ============================================

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Banner
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║   🔒 Flutter Obfuscation & Minification Setup 🔒         ║"
echo "║                                                           ║"
echo "║   Configura tu proyecto Flutter con:                     ║"
echo "║   • Ofuscación de código Dart                            ║"
echo "║   • Minificación R8 (Android)                            ║"
echo "║   • Symbol stripping (iOS)                               ║"
echo "║   • Configuración automática remote-first                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Verificar argumentos
PROJECT_PATH="${1:-.}"

if [ "$PROJECT_PATH" != "." ]; then
    log_info "Proyecto target: $PROJECT_PATH"

    if [ ! -d "$PROJECT_PATH" ]; then
        log_error "Directorio no encontrado: $PROJECT_PATH"
        exit 1
    fi

    cd "$PROJECT_PATH"
fi

# Verificar que es un proyecto Flutter
log_step "Verificando que es un proyecto Flutter..."

if [ ! -f "pubspec.yaml" ]; then
    log_error "pubspec.yaml no encontrado. ¿Estás en un proyecto Flutter?"
    exit 1
fi

if [ ! -d "android" ] && [ ! -d "ios" ]; then
    log_error "Directorios android/ o ios/ no encontrados"
    exit 1
fi

log_success "Proyecto Flutter detectado"

# Obtener información del proyecto
PROJECT_NAME=$(grep "^name:" pubspec.yaml | awk '{print $2}')
log_info "Proyecto: $PROJECT_NAME"

# Preguntar qué plataformas configurar
echo ""
echo "¿Qué plataformas deseas configurar?"
echo "  1) Solo Android"
echo "  2) Solo iOS"
echo "  3) Ambas (Android + iOS)"
echo ""
read -p "Selecciona una opción (1-3): " platform_choice

SETUP_ANDROID=false
SETUP_IOS=false

case $platform_choice in
    1)
        SETUP_ANDROID=true
        log_info "Configurando: Android"
        ;;
    2)
        SETUP_IOS=true
        log_info "Configurando: iOS"
        ;;
    3)
        SETUP_ANDROID=true
        SETUP_IOS=true
        log_info "Configurando: Android + iOS"
        ;;
    *)
        log_error "Opción inválida"
        exit 1
        ;;
esac

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Iniciando Configuración"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ============================================
# CONFIGURACIÓN ANDROID
# ============================================

if [ "$SETUP_ANDROID" = true ]; then
    log_step "Configurando Android R8 + ProGuard..."

    # Verificar estructura Android
    if [ ! -d "android" ]; then
        log_error "Directorio android/ no encontrado"
        exit 1
    fi

    # Detectar tipo de build.gradle (Groovy o Kotlin)
    if [ -f "android/app/build.gradle.kts" ]; then
        GRADLE_FILE="android/app/build.gradle.kts"
        GRADLE_TYPE="kotlin"
        log_info "Detectado: build.gradle.kts (Kotlin DSL)"
    elif [ -f "android/app/build.gradle" ]; then
        GRADLE_FILE="android/app/build.gradle"
        GRADLE_TYPE="groovy"
        log_info "Detectado: build.gradle (Groovy)"
    else
        log_error "build.gradle no encontrado"
        exit 1
    fi

    # Backup del archivo original
    cp "$GRADLE_FILE" "${GRADLE_FILE}.backup"
    log_success "Backup creado: ${GRADLE_FILE}.backup"

    # Verificar si ya está configurado
    if grep -q "minifyEnabled" "$GRADLE_FILE"; then
        log_warning "R8 parece estar ya configurado en $GRADLE_FILE"
        read -p "¿Deseas sobrescribir la configuración? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Saltando configuración de R8"
            SETUP_ANDROID=false
        fi
    fi

    if [ "$SETUP_ANDROID" = true ]; then
        # Modificar build.gradle según tipo
        if [ "$GRADLE_TYPE" = "kotlin" ]; then
            # Buscar la sección defaultConfig y agregar multiDex
            if ! grep -q "multiDexEnabled" "$GRADLE_FILE"; then
                sed -i.tmp '/defaultConfig {/a\
        multiDexEnabled = true
' "$GRADLE_FILE"
                rm "${GRADLE_FILE}.tmp"
                log_success "multiDexEnabled agregado"
            fi

            # Buscar la sección release y agregar minificación
            if ! grep -q "isMinifyEnabled = true" "$GRADLE_FILE"; then
                # Crear sección release si no existe
                if ! grep -q "buildTypes {" "$GRADLE_FILE"; then
                    log_error "No se encontró sección buildTypes en $GRADLE_FILE"
                    log_info "Por favor, agrega manualmente la configuración de R8"
                else
                    log_warning "Debes agregar manualmente esta configuración en la sección release:"
                    echo ""
                    echo "    release {"
                    echo "        isMinifyEnabled = true"
                    echo "        isShrinkResources = true"
                    echo "        proguardFiles("
                    echo "            getDefaultProguardFile(\"proguard-android-optimize.txt\"),"
                    echo "            \"proguard-rules.pro\""
                    echo "        )"
                    echo "    }"
                    echo ""
                fi
            fi
        else
            # Groovy DSL
            if ! grep -q "multiDexEnabled" "$GRADLE_FILE"; then
                sed -i.tmp '/defaultConfig {/a\
        multiDexEnabled true
' "$GRADLE_FILE"
                rm "${GRADLE_FILE}.tmp"
                log_success "multiDexEnabled agregado"
            fi

            log_warning "Para Groovy DSL, agrega manualmente:"
            echo ""
            echo "    release {"
            echo "        minifyEnabled true"
            echo "        shrinkResources true"
            echo "        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'"
            echo "    }"
            echo ""
        fi

        # Crear proguard-rules.pro
        PROGUARD_FILE="android/app/proguard-rules.pro"

        if [ -f "$PROGUARD_FILE" ]; then
            log_warning "proguard-rules.pro ya existe"
            read -p "¿Deseas sobrescribirlo? (y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Manteniendo proguard-rules.pro existente"
                PROGUARD_FILE=""
            fi
        fi

        if [ -n "$PROGUARD_FILE" ]; then
            cat > "$PROGUARD_FILE" << 'PROGUARD_EOF'
# ============================================
# ProGuard Rules - Flutter Project
# Auto-generated by setup_obfuscation.sh
# ============================================

# ----------------------------------------
# FLUTTER CORE
# ----------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ----------------------------------------
# ANDROID COMPONENTS
# ----------------------------------------
# TODO: Reemplaza 'com.example.app' con tu applicationId
-keep class com.example.app.MainActivity { *; }

# ----------------------------------------
# DATA MODELS (para serialización JSON)
# ----------------------------------------
# TODO: Ajusta según tus modelos de datos
# -keep class com.example.app.models.** { *; }

# ----------------------------------------
# PLUGINS COMUNES
# ----------------------------------------

# sqflite (base de datos)
-keep class com.tekartik.sqflite.** { *; }

# shared_preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# path_provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# ----------------------------------------
# JNI (métodos nativos)
# ----------------------------------------
-keepclasseswithmembernames class * {
    native <methods>;
}

# ----------------------------------------
# REFLECTION (para serialización)
# ----------------------------------------
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keepattributes InnerClasses,EnclosingMethod

# ----------------------------------------
# ENUMS
# ----------------------------------------
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ----------------------------------------
# PARCELABLE
# ----------------------------------------
-keep interface android.os.Parcelable
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# ----------------------------------------
# SERIALIZABLE
# ----------------------------------------
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ----------------------------------------
# ANDROIDX COMPONENTS
# ----------------------------------------
-keep class ** extends androidx.lifecycle.ViewModel { *; }
-keep class ** extends androidx.lifecycle.AndroidViewModel { *; }

# ----------------------------------------
# OPTIMIZATION
# ----------------------------------------
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''

# ----------------------------------------
# GOOGLE PLAY CORE
# ----------------------------------------
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# ----------------------------------------
# WARNINGS (suprimir conocidos)
# ----------------------------------------
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# ----------------------------------------
# CUSTOM RULES
# ----------------------------------------
# TODO: Agrega aquí reglas específicas para tu proyecto
PROGUARD_EOF

            log_success "proguard-rules.pro creado"
            log_warning "IMPORTANTE: Edita android/app/proguard-rules.pro y reemplaza:"
            log_warning "  - 'com.example.app' con tu applicationId real"
            log_warning "  - Agrega reglas para tus modelos de datos"
        fi
    fi
fi

# ============================================
# CONFIGURACIÓN iOS
# ============================================

if [ "$SETUP_IOS" = true ]; then
    log_step "Configurando iOS Symbol Stripping..."

    if [ ! -d "ios" ]; then
        log_error "Directorio ios/ no encontrado"
        exit 1
    fi

    # Verificar si existe Release.xcconfig
    RELEASE_XCCONFIG="ios/Flutter/Release.xcconfig"

    if [ ! -f "$RELEASE_XCCONFIG" ]; then
        log_error "Release.xcconfig no encontrado en: $RELEASE_XCCONFIG"
        exit 1
    fi

    log_info "Encontrado: $RELEASE_XCCONFIG"

    # Backup
    cp "$RELEASE_XCCONFIG" "${RELEASE_XCCONFIG}.backup"
    log_success "Backup creado: ${RELEASE_XCCONFIG}.backup"

    # Verificar si ya está configurado
    if grep -q "STRIP_INSTALLED_PRODUCT = YES" "$RELEASE_XCCONFIG"; then
        log_warning "Symbol stripping parece estar ya configurado en Release.xcconfig"
        read -p "¿Deseas sobrescribir la configuración? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Manteniendo Release.xcconfig existente"
            SETUP_IOS=false
        fi
    fi

    if [ "$SETUP_IOS" = true ]; then
        # Generar Release.xcconfig directamente (remote-first: no usa templates locales)
        log_info "Generando Release.xcconfig..."

        cat > "$RELEASE_XCCONFIG" << 'XCCONFIG_EOF'
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
XCCONFIG_EOF

        log_success "Release.xcconfig actualizado con configuraciones de symbol stripping"
        log_warning "IMPORTANTE: La línea #include es una directiva válida, NO un comentario"
        log_warning "NO agregues comentarios adicionales con # - solo directivas #include son permitidas"
    fi
fi

# ============================================
# ACTUALIZAR .gitignore
# ============================================

log_step "Actualizando .gitignore..."

if [ ! -f ".gitignore" ]; then
    touch .gitignore
    log_warning ".gitignore no existía, creado"
fi

# Agregar exclusiones si no existen
if ! grep -q "# Obfuscation artifacts" .gitignore; then
    cat >> .gitignore << 'GITIGNORE_EOF'

# Obfuscation artifacts
build/app/outputs/mapping/
build/app/outputs/symbols/
build/symbols/
*.backup
temp/
GITIGNORE_EOF
    log_success ".gitignore actualizado"
else
    log_info ".gitignore ya tiene exclusiones de ofuscación"
fi

# ============================================
# RESUMEN Y PRÓXIMOS PASOS
# ============================================

echo ""
echo "═══════════════════════════════════════════════════════════"
log_success "CONFIGURACIÓN COMPLETADA"
echo "═══════════════════════════════════════════════════════════"
echo ""

log_info "Próximos pasos:"
echo ""

if [ "$SETUP_ANDROID" = true ]; then
    echo "📱 ANDROID:"
    echo "  1. Revisa y personaliza: android/app/proguard-rules.pro"
    echo "  2. Reemplaza 'com.example.app' con tu applicationId"
    echo "  3. Agrega reglas para tus modelos específicos"
    echo "  4. Verifica la configuración de R8 en: $GRADLE_FILE"
    echo ""
fi

if [ "$SETUP_IOS" = true ]; then
    echo "🍎 iOS:"
    echo "  1. Release.xcconfig ya está configurado"
    echo "  2. NO agregues comentarios con # en Release.xcconfig (solo directivas #include)"
    echo "  3. Si usas Xcode 16.2 y encuentras errores, descarga fix_xcode_modulecache.sh"
    echo ""
fi

echo "🔧 TESTING:"
echo "  1. Construye tu app con flags de ofuscación:"
echo "     flutter build apk --release --obfuscate --split-debug-info=build/symbols/android"
echo "     flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios"
echo ""
echo "  2. Verifica los tamaños de los binarios"
echo "  3. Prueba la app en dispositivos físicos"
echo ""

echo "💾 IMPORTANTE:"
echo "  • Respalda los archivos .backup creados"
echo "  • Archiva mapping.txt y símbolos para cada release"
echo "  • Para scripts de build/validación, descárgalos con:"
echo "    curl -O https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh"
echo ""

log_success "¡Setup completado! 🎉"
echo ""
