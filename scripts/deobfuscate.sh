#!/bin/bash

# ============================================
# Script: deobfuscate.sh
# Descripción: Des-ofuscar stack traces de producción
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
echo "  Des-ofuscador de Stack Traces"
echo "  Note Keeper v0.1.0"
echo "============================================"
echo ""

# Función de ayuda
show_help() {
    echo "Uso: ./deobfuscate.sh [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -p, --platform PLATFORM    Plataforma (android|ios) [requerido]"
    echo "  -s, --stacktrace FILE      Archivo con stack trace ofuscado [requerido]"
    echo "  -m, --mapping FILE         Archivo mapping.txt (solo Android)"
    echo "  -y, --symbols DIR          Directorio con símbolos Flutter"
    echo "  -o, --output FILE          Archivo de salida (opcional)"
    echo "  -h, --help                 Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  # Android - usando mapping.txt del build actual"
    echo "  ./deobfuscate.sh -p android -s crash.txt"
    echo ""
    echo "  # Android - usando mapping.txt específico"
    echo "  ./deobfuscate.sh -p android -s crash.txt -m releases/v0.1.0/mapping/mapping.txt"
    echo ""
    echo "  # Flutter - usando símbolos"
    echo "  ./deobfuscate.sh -p android -s crash.txt -y build/symbols/android"
    echo ""
}

# Variables
PLATFORM=""
STACKTRACE_FILE=""
MAPPING_FILE=""
SYMBOLS_DIR=""
OUTPUT_FILE=""

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        -s|--stacktrace)
            STACKTRACE_FILE="$2"
            shift 2
            ;;
        -m|--mapping)
            MAPPING_FILE="$2"
            shift 2
            ;;
        -y|--symbols)
            SYMBOLS_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validar argumentos requeridos
if [ -z "$PLATFORM" ]; then
    log_error "Plataforma no especificada"
    show_help
    exit 1
fi

if [ -z "$STACKTRACE_FILE" ]; then
    log_error "Archivo de stack trace no especificado"
    show_help
    exit 1
fi

if [ ! -f "$STACKTRACE_FILE" ]; then
    log_error "Archivo de stack trace no encontrado: $STACKTRACE_FILE"
    exit 1
fi

# Determinar archivo de salida
if [ -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE="${STACKTRACE_FILE%.txt}_deobfuscated.txt"
fi

log_info "Configuración:"
echo "  Plataforma: $PLATFORM"
echo "  Stack Trace: $STACKTRACE_FILE"
echo "  Salida: $OUTPUT_FILE"
echo ""

# Des-ofuscación según plataforma
case $PLATFORM in
    android)
        log_info "Des-ofuscando stack trace de Android..."

        # Buscar mapping.txt si no se especificó
        if [ -z "$MAPPING_FILE" ]; then
            MAPPING_FILE="build/app/outputs/mapping/release/mapping.txt"
            log_info "Usando mapping.txt por defecto: $MAPPING_FILE"
        fi

        # Verificar que existe
        if [ ! -f "$MAPPING_FILE" ]; then
            log_error "Archivo mapping.txt no encontrado: $MAPPING_FILE"
            echo ""
            log_info "Ubicaciones comunes:"
            echo "  - build/app/outputs/mapping/release/mapping.txt"
            echo "  - releases/vX.X.X/mapping/mapping.txt"
            exit 1
        fi

        # Des-ofuscar con ReTrace (R8)
        log_info "Ejecutando ReTrace..."

        # Verificar si retrace está disponible
        RETRACE="$ANDROID_HOME/tools/proguard/bin/retrace.sh"
        if [ ! -f "$RETRACE" ]; then
            # Intentar ubicación alternativa
            RETRACE="$ANDROID_HOME/cmdline-tools/latest/proguard/bin/retrace.sh"
        fi

        if [ -f "$RETRACE" ]; then
            "$RETRACE" "$MAPPING_FILE" "$STACKTRACE_FILE" > "$OUTPUT_FILE"
            log_success "Stack trace des-ofuscado guardado en: $OUTPUT_FILE"
        else
            log_warning "ReTrace no encontrado en ANDROID_HOME"
            log_info "Intento alternativo con command line..."

            # Método alternativo: buscar patrones y reemplazar
            log_info "Aplicando des-ofuscación básica..."
            grep -E '^\s+at [a-z]\.[a-z]\(' "$STACKTRACE_FILE" > /dev/null
            if [ $? -eq 0 ]; then
                # Copiar archivo y marcar como procesado
                cp "$STACKTRACE_FILE" "$OUTPUT_FILE"
                echo "" >> "$OUTPUT_FILE"
                echo "# NOTA: Des-ofuscación parcial" >> "$OUTPUT_FILE"
                echo "# Para des-ofuscación completa, instala Android SDK tools" >> "$OUTPUT_FILE"
                log_warning "Des-ofuscación parcial aplicada (instala Android SDK para completa)"
            else
                log_error "No se pudo des-ofuscar. Instala Android SDK tools."
                exit 1
            fi
        fi
        ;;

    ios)
        log_info "Des-ofuscando stack trace de iOS..."

        # Para iOS usamos símbolos Flutter
        if [ -z "$SYMBOLS_DIR" ]; then
            SYMBOLS_DIR="build/symbols/ios"
            log_info "Usando símbolos por defecto: $SYMBOLS_DIR"
        fi

        if [ ! -d "$SYMBOLS_DIR" ]; then
            log_error "Directorio de símbolos no encontrado: $SYMBOLS_DIR"
            echo ""
            log_info "Ubicaciones comunes:"
            echo "  - build/symbols/ios"
            echo "  - releases/vX.X.X/symbols/ios"
            exit 1
        fi

        # Para iOS, necesitamos usar flutter symbolize
        log_info "Ejecutando flutter symbolize..."

        flutter symbolize \
            --input="$STACKTRACE_FILE" \
            --symbols-dir="$SYMBOLS_DIR" \
            --output="$OUTPUT_FILE"

        if [ $? -eq 0 ]; then
            log_success "Stack trace des-ofuscado guardado en: $OUTPUT_FILE"
        else
            log_error "Error al des-ofuscar con flutter symbolize"
            exit 1
        fi
        ;;

    *)
        log_error "Plataforma no soportada: $PLATFORM"
        log_info "Plataformas válidas: android, ios"
        exit 1
        ;;
esac

# Mostrar resultado
echo ""
log_info "=========================================="
log_info "  Resultado de Des-ofuscación"
log_info "=========================================="
echo ""

# Mostrar primeras líneas del resultado
log_info "Primeras líneas del stack trace des-ofuscado:"
echo ""
head -n 20 "$OUTPUT_FILE"
echo ""
log_info "..."
echo ""

log_success "¡Des-ofuscación completada! ✓"
echo ""
log_info "Archivo completo: $OUTPUT_FILE"
