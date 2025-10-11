#!/bin/bash

# ============================================
# Script: build_release_obfuscated.sh
# Descripción: Build de release con ofuscación para Android e iOS
# Versión: 1.0.0
# Fecha: 2025-10-11
# ============================================

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Banner
echo "============================================"
echo "  Build Release con Ofuscación"
echo "  Note Keeper v0.1.0"
echo "============================================"
echo ""

# Variables
BUILD_NUMBER=$(date +%s)
VERSION_NAME="0.1.0"
SYMBOLS_DIR="build/symbols"
ANDROID_SYMBOLS_DIR="$SYMBOLS_DIR/android"
IOS_SYMBOLS_DIR="$SYMBOLS_DIR/ios"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Crear directorios para símbolos si no existen
log_info "Creando directorios para símbolos..."
mkdir -p "$ANDROID_SYMBOLS_DIR"
mkdir -p "$IOS_SYMBOLS_DIR"

# Limpiar builds anteriores
log_info "Limpiando builds anteriores..."
flutter clean
log_success "Limpieza completada"

# Obtener dependencias
log_info "Obteniendo dependencias..."
flutter pub get
log_success "Dependencias actualizadas"

# Build Android
echo ""
log_info "=========================================="
log_info "  Iniciando Build Android"
log_info "=========================================="

log_info "Generando APKs con ofuscación..."
flutter build apk \
    --release \
    --obfuscate \
    --split-debug-info="$ANDROID_SYMBOLS_DIR" \
    --split-per-abi \
    --build-number="$BUILD_NUMBER"

if [ $? -eq 0 ]; then
    log_success "Build Android completado exitosamente"

    # Mostrar tamaños de APKs
    echo ""
    log_info "Tamaños de APKs generados:"
    for apk in build/app/outputs/apk/release/*.apk; do
        if [ -f "$apk" ]; then
            size=$(du -h "$apk" | cut -f1)
            name=$(basename "$apk")
            echo "  - $name: $size"
        fi
    done

    # Verificar mapping files
    echo ""
    log_info "Verificando archivos de mapping..."
    if [ -f "build/app/outputs/mapping/release/mapping.txt" ]; then
        mapping_size=$(du -h "build/app/outputs/mapping/release/mapping.txt" | cut -f1)
        log_success "mapping.txt encontrado ($mapping_size)"
    else
        log_warning "mapping.txt NO encontrado"
    fi

    # Verificar símbolos Flutter
    echo ""
    log_info "Verificando símbolos Flutter..."
    symbol_count=$(find "$ANDROID_SYMBOLS_DIR" -name "*.symbols" | wc -l)
    if [ $symbol_count -gt 0 ]; then
        log_success "Símbolos Flutter encontrados: $symbol_count archivos"
        find "$ANDROID_SYMBOLS_DIR" -name "*.symbols" -exec du -h {} \;
    else
        log_warning "Símbolos Flutter NO encontrados"
    fi
else
    log_error "Build Android FALLÓ"
    exit 1
fi

# Build iOS
echo ""
log_info "=========================================="
log_info "  Iniciando Build iOS"
log_info "=========================================="

log_warning "Build iOS omitido (Xcode 16.2 issue - ver METRICAS_IMPLEMENTACION.md)"
log_info "Configuraciones de symbol stripping ya aplicadas en project.pbxproj"

# Comentado hasta resolver issue de Xcode 16.2
# flutter build ios \
#     --release \
#     --obfuscate \
#     --split-debug-info="$IOS_SYMBOLS_DIR" \
#     --no-codesign \
#     --build-number="$BUILD_NUMBER"

# Resumen final
echo ""
echo "============================================"
log_success "BUILD COMPLETADO"
echo "============================================"
echo ""
log_info "Versión: $VERSION_NAME"
log_info "Build Number: $BUILD_NUMBER"
log_info "Timestamp: $TIMESTAMP"
echo ""
log_info "Artefactos generados:"
echo "  📱 APKs: build/app/outputs/apk/release/"
echo "  🗺️  R8 Mapping: build/app/outputs/mapping/release/mapping.txt"
echo "  🔣 Flutter Symbols: $ANDROID_SYMBOLS_DIR"
echo ""
log_warning "IMPORTANTE: Respalda los archivos de mapping y símbolos"
log_warning "Son necesarios para des-ofuscar stack traces de producción"
echo ""

# Opcional: Copiar archivos a releases/
read -p "¿Deseas archivar este build en releases/? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    RELEASE_DIR="releases/v${VERSION_NAME}_${TIMESTAMP}"
    mkdir -p "$RELEASE_DIR/apks"
    mkdir -p "$RELEASE_DIR/symbols/android"
    mkdir -p "$RELEASE_DIR/mapping"

    log_info "Copiando artefactos a $RELEASE_DIR..."

    # Copiar APKs
    cp build/app/outputs/apk/release/*.apk "$RELEASE_DIR/apks/" 2>/dev/null || true

    # Copiar mapping
    cp build/app/outputs/mapping/release/mapping.txt "$RELEASE_DIR/mapping/" 2>/dev/null || true
    cp build/app/outputs/mapping/release/*.txt "$RELEASE_DIR/mapping/" 2>/dev/null || true

    # Copiar símbolos
    cp -r "$ANDROID_SYMBOLS_DIR"/* "$RELEASE_DIR/symbols/android/" 2>/dev/null || true

    log_success "Artefactos archivados en $RELEASE_DIR"
fi

echo ""
log_success "¡Todo listo! 🚀"
