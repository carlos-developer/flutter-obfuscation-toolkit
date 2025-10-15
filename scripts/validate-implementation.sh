#!/bin/bash

################################################################################
# validate-implementation.sh
#
# Script de validación automática para implementaciones del Flutter Obfuscation Toolkit
#
# Propósito:
#   - Detectar qué plataformas (Android/iOS) fueron configuradas
#   - Validar CADA plataforma configurada con su build correspondiente
#   - Prevenir que los agentes marquen como completo sin validar todas las plataformas
#
# Uso:
#   ./scripts/validate-implementation.sh
#   O desde URL:
#   curl -s https://raw.githubusercontent.com/carlos-developer/flutter-obfuscation-toolkit/main/scripts/validate-implementation.sh | bash
################################################################################

set -e

echo ""
echo "🔍 VALIDACIÓN AUTOMÁTICA DE IMPLEMENTACIÓN"
echo "============================================"
echo ""

ERRORS=0
WARNINGS=0

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones helper
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    ERRORS=$((ERRORS+1))
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARNINGS=$((WARNINGS+1))
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

################################################################################
# FASE 1: Detectar plataformas configuradas
################################################################################

echo "📋 FASE 1: Detectando plataformas configuradas..."
echo ""

ANDROID_CONFIGURED=false
IOS_CONFIGURED=false

# Detectar Android
if grep -q "isMinifyEnabled" android/app/build.gradle* 2>/dev/null; then
    ANDROID_CONFIGURED=true
    print_success "Android: Configuración detectada"
else
    print_info "Android: No configurado (omitiendo validación)"
fi

# Detectar iOS
if grep -q "STRIP_INSTALLED_PRODUCT" ios/Flutter/Release.xcconfig 2>/dev/null; then
    IOS_CONFIGURED=true
    print_success "iOS: Configuración detectada"
else
    print_info "iOS: No configurado (omitiendo validación)"
fi

# Verificar que al menos una plataforma esté configurada
if [ "$ANDROID_CONFIGURED" = false ] && [ "$IOS_CONFIGURED" = false ]; then
    print_error "NINGUNA plataforma está configurada"
    echo ""
    echo "❌ VALIDACIÓN ABORTADA"
    exit 1
fi

echo ""

################################################################################
# FASE 2: Validar configuración de archivos
################################################################################

echo "📋 FASE 2: Validando archivos de configuración..."
echo ""

if [ "$ANDROID_CONFIGURED" = true ]; then
    echo "Validando Android:"

    # build.gradle.kts
    if grep -q "multiDexEnabled = true" android/app/build.gradle.kts 2>/dev/null; then
        print_success "  multiDexEnabled habilitado"
    else
        print_error "  multiDexEnabled NO encontrado"
    fi

    if grep -q "isMinifyEnabled = true" android/app/build.gradle* 2>/dev/null; then
        print_success "  isMinifyEnabled habilitado"
    else
        print_error "  isMinifyEnabled NO encontrado"
    fi

    if grep -q "isShrinkResources = true" android/app/build.gradle* 2>/dev/null; then
        print_success "  isShrinkResources habilitado"
    else
        print_error "  isShrinkResources NO encontrado"
    fi

    # proguard-rules.pro
    if test -f android/app/proguard-rules.pro; then
        print_success "  proguard-rules.pro existe"

        # Verificar que no tenga valores genéricos
        if grep -q "com.example.app" android/app/proguard-rules.pro 2>/dev/null; then
            print_error "  proguard-rules.pro contiene valores genéricos (com.example.app)"
        else
            print_success "  proguard-rules.pro está personalizado"
        fi
    else
        print_error "  proguard-rules.pro NO existe"
    fi

    echo ""
fi

if [ "$IOS_CONFIGURED" = true ]; then
    echo "Validando iOS:"

    if grep -q "STRIP_INSTALLED_PRODUCT = YES" ios/Flutter/Release.xcconfig 2>/dev/null; then
        print_success "  STRIP_INSTALLED_PRODUCT habilitado"
    else
        print_error "  STRIP_INSTALLED_PRODUCT NO encontrado"
    fi

    if grep -q "DEAD_CODE_STRIPPING = YES" ios/Flutter/Release.xcconfig 2>/dev/null; then
        print_success "  DEAD_CODE_STRIPPING habilitado"
    else
        print_error "  DEAD_CODE_STRIPPING NO encontrado"
    fi

    if grep -q "SWIFT_OPTIMIZATION_LEVEL" ios/Flutter/Release.xcconfig 2>/dev/null; then
        print_success "  SWIFT_OPTIMIZATION_LEVEL configurado"
    else
        print_warning "  SWIFT_OPTIMIZATION_LEVEL no encontrado"
    fi

    echo ""
fi

# Verificar .gitignore
echo "Validando .gitignore:"
if grep -q "build/symbols/" .gitignore 2>/dev/null; then
    print_success "  build/symbols/ en .gitignore"
else
    print_warning "  build/symbols/ NO está en .gitignore"
fi

if grep -q "build/app/outputs/mapping/" .gitignore 2>/dev/null; then
    print_success "  build/app/outputs/mapping/ en .gitignore"
else
    print_warning "  build/app/outputs/mapping/ NO está en .gitignore"
fi

echo ""

################################################################################
# FASE 3: Ejecutar builds y validar artifacts
################################################################################

echo "📋 FASE 3: Ejecutando builds de validación..."
echo ""

# Limpiar builds previos
print_info "Limpiando builds previos..."
flutter clean > /dev/null 2>&1

echo ""

################################################################################
# BUILD ANDROID
################################################################################

if [ "$ANDROID_CONFIGURED" = true ]; then
    echo "🤖 Ejecutando build Android..."
    echo ""

    # Ejecutar build
    if flutter build apk --release --obfuscate --split-debug-info=build/symbols/android --split-per-abi; then
        print_success "Build Android exitoso"
        echo ""

        # Validar APKs generados
        echo "Validando artifacts Android:"

        APK_COUNT=$(ls build/app/outputs/flutter-apk/*.apk 2>/dev/null | wc -l | tr -d ' ')
        if [ "$APK_COUNT" -gt 0 ]; then
            print_success "  APKs generados: $APK_COUNT"
            ls -lh build/app/outputs/flutter-apk/*.apk | awk '{print "    - " $9 " (" $5 ")"}'
        else
            print_error "  No se generaron APKs"
        fi

        # Validar mapping.txt
        if test -f build/app/outputs/mapping/release/mapping.txt; then
            SIZE=$(ls -lh build/app/outputs/mapping/release/mapping.txt | awk '{print $5}')
            print_success "  mapping.txt generado ($SIZE)"
        else
            print_error "  mapping.txt NO fue generado"
        fi

        # Validar símbolos Flutter
        if test -d build/symbols/android; then
            SYMBOL_COUNT=$(ls build/symbols/android/*.symbols 2>/dev/null | wc -l | tr -d ' ')
            if [ "$SYMBOL_COUNT" -gt 0 ]; then
                print_success "  Símbolos Flutter Android: $SYMBOL_COUNT archivos"
            else
                print_error "  Símbolos Flutter Android: directorio existe pero vacío"
            fi
        else
            print_error "  Símbolos Flutter Android NO generados"
        fi

        echo ""
    else
        print_error "Build Android FALLÓ"
        echo ""
    fi
fi

################################################################################
# BUILD IOS
################################################################################

if [ "$IOS_CONFIGURED" = true ]; then
    echo "🍎 Ejecutando build iOS..."
    echo ""

    # Verificar que estamos en macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_warning "iOS configurado pero no estamos en macOS - omitiendo build"
        echo ""
    else
        # Ejecutar build
        if flutter build ios --release --obfuscate --split-debug-info=build/symbols/ios; then
            print_success "Build iOS exitoso"
            echo ""

            # Validar artifacts iOS
            echo "Validando artifacts iOS:"

            # Validar Runner.app
            if test -d build/ios/Release-iphoneos/Runner.app; then
                print_success "  Runner.app generado"

                # Verificar que el binario está stripped
                if file build/ios/Release-iphoneos/Runner.app/Runner 2>/dev/null | grep -q "stripped"; then
                    print_success "  Binario iOS está stripped"
                else
                    print_warning "  Binario iOS podría no estar stripped correctamente"
                fi
            else
                print_error "  Runner.app NO fue generado"
            fi

            # Validar símbolos Flutter iOS
            if test -d build/symbols/ios; then
                SYMBOL_COUNT=$(ls build/symbols/ios/*.symbols 2>/dev/null | wc -l | tr -d ' ')
                if [ "$SYMBOL_COUNT" -gt 0 ]; then
                    print_success "  Símbolos Flutter iOS: $SYMBOL_COUNT archivos"
                else
                    print_error "  Símbolos Flutter iOS: directorio existe pero vacío"
                fi
            else
                print_error "  Símbolos Flutter iOS NO generados"
            fi

            echo ""
        else
            print_error "Build iOS FALLÓ"
            echo ""
        fi
    fi
fi

################################################################################
# FASE 4: Validación Técnica de Ofuscación
################################################################################

echo "📋 FASE 4: Validando ofuscación real en binarios..."
echo ""

if [ "$ANDROID_CONFIGURED" = true ] && [ $ERRORS -eq 0 ]; then
    echo "🔍 Validando ofuscación Android:"
    echo ""

    # Validar R8 activo en mapping.txt
    if test -f build/app/outputs/mapping/release/mapping.txt; then
        if grep -q "# compiler: R8" build/app/outputs/mapping/release/mapping.txt; then
            print_success "  R8 Compiler activo"

            # Contar líneas en mapping.txt (indicador de ofuscación)
            MAPPING_LINES=$(wc -l < build/app/outputs/mapping/release/mapping.txt | tr -d ' ')
            if [ "$MAPPING_LINES" -gt 10000 ]; then
                print_success "  mapping.txt contiene $MAPPING_LINES líneas (ofuscación activa)"
            else
                print_warning "  mapping.txt tiene solo $MAPPING_LINES líneas (posible ofuscación mínima)"
            fi

            # Verificar clases removidas por R8
            R8_REMOVED=$(grep -c "R8\$\$REMOVED" build/app/outputs/mapping/release/mapping.txt 2>/dev/null || echo "0")
            if [ "$R8_REMOVED" -gt 0 ]; then
                print_success "  R8 removió $R8_REMOVED clases no utilizadas"
            else
                print_info "  No se encontraron clases removidas explícitamente"
            fi
        else
            print_error "  mapping.txt no contiene header de R8"
        fi
    else
        print_warning "  No se puede validar R8 (mapping.txt no existe)"
    fi

    # Validar ofuscación Dart en APK
    echo ""
    print_info "Validando ofuscación de código Dart..."

    # Extraer APK para inspección
    APK_FILE=$(ls build/app/outputs/flutter-apk/app-arm64-v8a-release.apk 2>/dev/null | head -1)
    if [ -n "$APK_FILE" ]; then
        TEMP_DIR=$(mktemp -d)
        unzip -q "$APK_FILE" -d "$TEMP_DIR" 2>/dev/null

        if test -f "$TEMP_DIR/lib/arm64-v8a/libapp.so"; then
            # Buscar nombres de clases comunes que NO deberían estar visibles
            FOUND_CLASSES=0

            # Lista de nombres comunes a buscar (personaliza según tu app)
            for CLASS_NAME in "MyApp" "MyHomePage" "_State" "HomePage" "MainPage"; do
                if strings "$TEMP_DIR/lib/arm64-v8a/libapp.so" 2>/dev/null | grep -qi "$CLASS_NAME"; then
                    ((FOUND_CLASSES++))
                fi
            done

            if [ "$FOUND_CLASSES" -eq 0 ]; then
                print_success "  Nombres de clases NO encontrados en binario (ofuscación Dart activa)"
            else
                print_warning "  Se encontraron $FOUND_CLASSES nombres de clases comunes (revisar si son de tu app)"
            fi
        else
            print_warning "  No se pudo extraer libapp.so para validar"
        fi

        # Limpiar
        rm -rf "$TEMP_DIR"
    else
        print_warning "  APK no encontrado para validación de ofuscación Dart"
    fi

    echo ""
fi

if [ "$IOS_CONFIGURED" = true ] && [ $ERRORS -eq 0 ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🔍 Validando ofuscación iOS:"
        echo ""

        # Validar que el binario está stripped
        if test -f build/ios/Release-iphoneos/Runner.app/Runner; then
            if file build/ios/Release-iphoneos/Runner.app/Runner 2>/dev/null | grep -q "stripped"; then
                print_success "  Binario iOS correctamente stripped"
            else
                print_warning "  Binario iOS no muestra 'stripped' en metadata"
            fi

            # Verificar tamaño del binario (indicador de stripping)
            BINARY_SIZE=$(stat -f%z build/ios/Release-iphoneos/Runner.app/Runner 2>/dev/null || echo "0")
            BINARY_SIZE_MB=$((BINARY_SIZE / 1024 / 1024))
            if [ "$BINARY_SIZE_MB" -lt 20 ]; then
                print_success "  Tamaño del binario: ${BINARY_SIZE_MB}MB (optimizado)"
            else
                print_info "  Tamaño del binario: ${BINARY_SIZE_MB}MB"
            fi
        else
            print_warning "  No se puede validar binario iOS (no encontrado)"
        fi

        # Validar símbolos separados
        if test -d build/symbols/ios; then
            SYMBOL_SIZE=$(du -sh build/symbols/ios 2>/dev/null | awk '{print $1}')
            print_success "  Símbolos separados generados: $SYMBOL_SIZE"
        fi

        echo ""
    fi
fi

echo ""

################################################################################
# REPORTE FINAL
################################################################################

echo ""
echo "============================================"
echo "📊 REPORTE FINAL DE VALIDACIÓN"
echo "============================================"
echo ""

# Resumen de plataformas
echo "Plataformas:"
if [ "$ANDROID_CONFIGURED" = true ]; then
    echo "  ✅ Android: Configurado y validado"
fi
if [ "$IOS_CONFIGURED" = true ]; then
    echo "  ✅ iOS: Configurado y validado"
fi
echo ""

# Conteo de errores y warnings
echo "Resultados:"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_success "Validación COMPLETA - 0 errores, 0 warnings"
    echo ""
    echo "✅ IMPLEMENTACIÓN CERTIFICADA"
    echo ""
    echo "Puedes proceder a:"
    echo "  1. Probar la app en dispositivos reales"
    echo "  2. Archivar mapping files en releases/"
    echo "  3. Integrar en tu pipeline CI/CD"
    echo ""
    exit 0
elif [ $ERRORS -eq 0 ]; then
    print_success "Validación COMPLETA - 0 errores"
    print_warning "$WARNINGS warnings (no críticos)"
    echo ""
    echo "⚠️  IMPLEMENTACIÓN CON WARNINGS"
    echo ""
    echo "La implementación es funcional pero tiene warnings."
    echo "Revisa los warnings arriba para optimizar."
    echo ""
    exit 0
else
    print_error "Validación FALLÓ - $ERRORS errores, $WARNINGS warnings"
    echo ""
    echo "❌ IMPLEMENTACIÓN INCOMPLETA"
    echo ""
    echo "Debes corregir los errores antes de continuar:"
    echo "  1. Revisa los errores marcados arriba"
    echo "  2. Corrige la configuración"
    echo "  3. Re-ejecuta este script"
    echo ""
    echo "NO marques la implementación como completa hasta que"
    echo "este script retorne exit code 0."
    echo ""
    exit 1
fi
