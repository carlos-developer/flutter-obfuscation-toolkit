#!/bin/bash

# ============================================
# Script: download_obfuscation_package.sh
# Descripción: Descarga el paquete completo de ofuscación Flutter desde GitHub
# Versión: 1.0.0
# Uso: curl -sSL https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/download_obfuscation_package.sh | bash
# ============================================

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# URL base del repositorio
REPO_URL="https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main"

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
echo "║   📦 Flutter Obfuscation Package Downloader 📦           ║"
echo "║                                                           ║"
echo "║   Descarga automática del paquete completo de            ║"
echo "║   ofuscación y minificación para Flutter                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Verificar que estamos en un proyecto Flutter
log_step "Verificando proyecto Flutter..."

if [ ! -f "pubspec.yaml" ]; then
    log_warning "pubspec.yaml no encontrado. ¿Estás en un proyecto Flutter?"
    read -p "¿Deseas continuar de todos modos? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_error "Cancelado por el usuario"
        exit 1
    fi
else
    log_success "Proyecto Flutter detectado"
fi

# Verificar herramienta de descarga disponible
log_step "Verificando herramientas de descarga..."

DOWNLOAD_CMD=""
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -sSL -o"
    log_success "curl encontrado"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -q -O"
    log_success "wget encontrado"
else
    log_error "Necesitas curl o wget instalado"
    exit 1
fi

# Crear directorios necesarios
log_step "Creando directorios..."

mkdir -p scripts
mkdir -p templates

log_success "Directorios creados"

# Lista de archivos a descargar
declare -A FILES=(
    ["scripts/setup_obfuscation.sh"]="scripts/setup_obfuscation.sh"
    ["scripts/build_release_obfuscated.sh"]="scripts/build_release_obfuscated.sh"
    ["scripts/deobfuscate.sh"]="scripts/deobfuscate.sh"
    ["templates/proguard-rules.template.pro"]="templates/proguard-rules.template.pro"
    ["templates/README_OBFUSCATION.md"]="templates/README_OBFUSCATION.md"
    ["MIGRATION_GUIDE.md"]="MIGRATION_GUIDE.md"
    ["CHECKLIST_OBFUSCATION.md"]="CHECKLIST_OBFUSCATION.md"
    ["TROUBLESHOOTING_ADVANCED.md"]="TROUBLESHOOTING_ADVANCED.md"
    ["OBFUSCATION_PACKAGE_README.md"]="OBFUSCATION_PACKAGE_README.md"
    ["OBFUSCATION_INDEX.md"]="OBFUSCATION_INDEX.md"
)

# Descargar archivos
log_step "Descargando archivos del paquete..."
echo ""

FAILED_FILES=()
SUCCESS_COUNT=0

for remote_path in "${!FILES[@]}"; do
    local_path="${FILES[$remote_path]}"
    url="${REPO_URL}/${remote_path}"

    log_info "Descargando: $local_path"

    if [ "$DOWNLOAD_CMD" = "curl -sSL -o" ]; then
        if curl -sSL -o "$local_path" "$url" 2>/dev/null; then
            log_success "  → $local_path"
            ((SUCCESS_COUNT++))
        else
            log_error "  → Falló: $local_path"
            FAILED_FILES+=("$local_path")
        fi
    else
        if wget -q -O "$local_path" "$url" 2>/dev/null; then
            log_success "  → $local_path"
            ((SUCCESS_COUNT++))
        else
            log_error "  → Falló: $local_path"
            FAILED_FILES+=("$local_path")
        fi
    fi
done

echo ""

# Hacer ejecutables los scripts
log_step "Configurando permisos de ejecución..."

chmod +x scripts/*.sh 2>/dev/null || true

log_success "Scripts configurados como ejecutables"

# Resumen
echo ""
echo "═══════════════════════════════════════════════════════════"
log_success "DESCARGA COMPLETADA"
echo "═══════════════════════════════════════════════════════════"
echo ""

log_info "Archivos descargados exitosamente: $SUCCESS_COUNT / ${#FILES[@]}"

if [ ${#FAILED_FILES[@]} -gt 0 ]; then
    log_warning "Archivos que fallaron:"
    for file in "${FAILED_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
fi

# Instrucciones siguientes
echo "📋 PRÓXIMOS PASOS:"
echo ""
echo "1. Revisa la documentación:"
echo "   cat OBFUSCATION_PACKAGE_README.md"
echo ""
echo "2. Ejecuta el setup automático:"
echo "   ./scripts/setup_obfuscation.sh"
echo ""
echo "3. O sigue la guía manual:"
echo "   cat MIGRATION_GUIDE.md"
echo ""
echo "4. Para validar la instalación:"
echo "   cat CHECKLIST_OBFUSCATION.md"
echo ""

# Ofrecer ejecutar setup automático
echo "═══════════════════════════════════════════════════════════"
echo ""
read -p "¿Deseas ejecutar el setup automático ahora? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_step "Ejecutando setup automático..."
    echo ""

    if [ -f "scripts/setup_obfuscation.sh" ]; then
        ./scripts/setup_obfuscation.sh
    else
        log_error "scripts/setup_obfuscation.sh no encontrado"
        exit 1
    fi
else
    log_info "Setup automático omitido"
    log_info "Ejecuta manualmente: ./scripts/setup_obfuscation.sh cuando estés listo"
fi

echo ""
log_success "¡Proceso completado! 🎉"
echo ""
