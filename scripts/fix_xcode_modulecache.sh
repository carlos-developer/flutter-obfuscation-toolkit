#!/bin/bash

# ============================================
# Script: fix_xcode_modulecache.sh
# Descripción: Soluciona el bug de ModuleCache de Xcode 16.2
# Versión: 1.0.0
# Uso: ./fix_xcode_modulecache.sh [project_path]
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
echo "║   🔧 Xcode 16.2 ModuleCache Fix 🔧                       ║"
echo "║                                                           ║"
echo "║   Soluciona el bug de compilación de Xcode 16.2         ║"
echo "║   relacionado con ModuleCache corrupto                   ║"
echo "║                                                           ║"
echo "║   Referencias:                                            ║"
echo "║   • Flutter Issue #157461                                ║"
echo "║   • Stack Overflow - Xcode 16 compilation errors         ║"
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

if [ ! -d "ios" ]; then
    log_error "Directorio ios/ no encontrado"
    exit 1
fi

log_success "Proyecto Flutter detectado"

# Detectar versión de Xcode
log_step "Detectando versión de Xcode..."

if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -n 1)
    log_info "$XCODE_VERSION"

    # Verificar si es Xcode 16.2
    if echo "$XCODE_VERSION" | grep -q "16.2"; then
        log_warning "Xcode 16.2 detectado - Este fix es necesario para esta versión"
    else
        log_info "Este fix está diseñado para Xcode 16.2, pero se puede ejecutar en cualquier versión"
    fi
else
    log_warning "xcodebuild no encontrado en PATH"
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Iniciando Fix de ModuleCache"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Paso 1: Flutter clean
log_step "1/6 Ejecutando flutter clean..."

if ! flutter clean; then
    log_error "flutter clean falló"
    exit 1
fi

log_success "Flutter clean completado"

# Paso 2: Eliminar DerivedData
log_step "2/6 Eliminando DerivedData..."

DERIVED_DATA_PATH=~/Library/Developer/Xcode/DerivedData

if [ -d "$DERIVED_DATA_PATH" ]; then
    rm -rf "$DERIVED_DATA_PATH"
    log_success "DerivedData eliminado: $DERIVED_DATA_PATH"
else
    log_info "DerivedData no existe (OK)"
fi

# Paso 3: Eliminar ModuleCache
log_step "3/6 Eliminando ModuleCache..."

MODULE_CACHE_PATH=~/Library/Developer/Xcode/ModuleCache.noindex

if [ -d "$MODULE_CACHE_PATH" ]; then
    rm -rf "$MODULE_CACHE_PATH"
    log_success "ModuleCache eliminado: $MODULE_CACHE_PATH"
else
    log_info "ModuleCache no existe (OK)"
fi

# Paso 4: Reinstalar dependencias Flutter
log_step "4/6 Reinstalando dependencias Flutter..."

if ! flutter pub get; then
    log_error "flutter pub get falló"
    exit 1
fi

log_success "Dependencias Flutter reinstaladas"

# Paso 5: Limpiar y reinstalar Pods
log_step "5/6 Limpiando y reinstalando CocoaPods..."

cd ios

if [ -d "Pods" ]; then
    rm -rf Pods
    log_success "Directorio Pods eliminado"
fi

if [ -f "Podfile.lock" ]; then
    rm -f Podfile.lock
    log_success "Podfile.lock eliminado"
fi

if [ -f "Podfile" ]; then
    if ! pod install; then
        log_error "pod install falló"
        cd ..
        exit 1
    fi
    log_success "CocoaPods reinstalado"
else
    log_warning "Podfile no encontrado - Saltando pod install"
fi

cd ..

# Paso 6: Configuración de Xcode Workspace
log_step "6/6 Configuración de Xcode Workspace (MANUAL)..."

echo ""
log_warning "ACCIÓN MANUAL REQUERIDA:"
echo ""
echo "Para completar el fix, debes cambiar la configuración de Xcode:"
echo ""
echo "  1. Abre tu proyecto iOS en Xcode:"
echo "     • Archivo: ios/Runner.xcworkspace"
echo ""
echo "  2. En Xcode, ve al menú:"
echo "     File → Workspace Settings (o Product → Scheme → Edit Scheme)"
echo ""
echo "  3. Cambia 'Derived Data' a:"
echo "     • Opción: 'Workspace-relative Location'"
echo "     • Ruta sugerida: DerivedData"
echo ""
echo "  4. Haz clic en 'Done' y cierra Xcode"
echo ""

read -p "¿Has completado la configuración manual en Xcode? (y/n) " -n 1 -r
echo
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_warning "Configuración manual pendiente"
    log_info "Recuerda completar el paso 6 antes de hacer un build"
else
    log_success "Configuración manual completada"
fi

# ============================================
# RESUMEN
# ============================================

echo ""
echo "═══════════════════════════════════════════════════════════"
log_success "FIX DE MODULECACHE COMPLETADO"
echo "═══════════════════════════════════════════════════════════"
echo ""

log_info "Pasos ejecutados:"
echo "  ✓ flutter clean"
echo "  ✓ Eliminación de DerivedData"
echo "  ✓ Eliminación de ModuleCache"
echo "  ✓ flutter pub get"
echo "  ✓ Limpieza e instalación de CocoaPods"
echo "  ⚠ Configuración de Xcode Workspace (manual)"
echo ""

log_info "Próximos pasos:"
echo ""
echo "🔨 Para verificar que el fix funcionó:"
echo "  flutter build ios --release --no-codesign"
echo ""
echo "📋 Si el build falla:"
echo "  1. Asegúrate de haber completado el paso 6 (configuración manual)"
echo "  2. Intenta cerrar y reabrir Xcode"
echo "  3. Ejecuta nuevamente este script"
echo ""
echo "📚 Referencias:"
echo "  • https://github.com/flutter/flutter/issues/157461"
echo "  • Stack Overflow: 'Xcode 16 compilation errors'"
echo ""

log_success "¡Fix aplicado! 🎉"
echo ""
