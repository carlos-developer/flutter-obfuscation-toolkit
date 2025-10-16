# TVP - Test & Validation Plan
## Plan de Pruebas y Validación - Minificación y Ofuscación

> **Plan de Pruebas y Validación**
>
> Proyecto: Flutter Obfuscation Toolkit
> Fecha: 2025-10-11
> Versión: 1.0.0
> Basado en: SRS v1.0.0, TIG v1.0.0
>
> **Nota**: Los ejemplos de código usan un proyecto de notas como referencia.
> Adapta los test cases a tu proyecto específico.

---

## 📋 Tabla de Contenidos

1. [Introducción](#1-introducción)
2. [Estrategia de Testing](#2-estrategia-de-testing)
3. [Test Cases - Unit Tests](#3-test-cases---unit-tests)
4. [Test Cases - Integration Tests](#4-test-cases---integration-tests)
5. [Test Cases - Manual Testing](#5-test-cases---manual-testing)
6. [Test Cases - Seguridad](#6-test-cases---seguridad)
7. [Criterios de Aceptación](#7-criterios-de-aceptación)
8. [Matriz de Cobertura](#8-matriz-de-cobertura)

---

## 1. Introducción

### 1.1. Objetivo

Este documento define la estrategia y casos de prueba para validar que la implementación de minificación y ofuscación:
- Preserva 100% de funcionalidad
- Cumple targets de reducción de tamaño
- Alcanza nivel de seguridad 8/10
- No introduce bugs o crashes

### 1.2. Alcance de Testing

**Incluido**:
- Unit tests (código Dart)
- Integration tests (end-to-end flows)
- Manual testing (dispositivos reales)
- Security testing (análisis de binarios)
- Performance testing (build time, app startup)

**Excluido**:
- Load testing (no aplica para app local)
- Security penetration testing completo (fuera de presupuesto)

### 1.3. Niveles de Testing

```
┌─────────────────────────────────────────┐
│         PIRÁMIDE DE TESTING              │
├─────────────────────────────────────────┤
│                                         │
│            ┌──────┐                     │
│            │Manual│  10%                │
│            │E2E   │  (dispositivos)     │
│            └──────┘                     │
│                                         │
│        ┌────────────┐                   │
│        │Integration │  20%              │
│        │Tests       │  (automated)      │
│        └────────────┘                   │
│                                         │
│    ┌──────────────────┐                │
│    │  Unit Tests      │  70%            │
│    │  (fast, isolated)│                 │
│    └──────────────────┘                │
│                                         │
└─────────────────────────────────────────┘
```

---

## 2. Estrategia de Testing

### 2.1. Fases de Testing

| Fase | Tipo | Cuándo | Responsable | Duración |
|------|------|--------|-------------|----------|
| **Fase 1** | Unit Tests | Después de cada cambio de código | Desarrollador | Continuo |
| **Fase 2** | Integration Tests | Antes de cada build de release | CI/CD | 5-10 min |
| **Fase 3** | Manual Testing | Después de build ofuscado | QA | 2-3 horas |
| **Fase 4** | Security Testing | Después de cada release | Security Team | 1 día |
| **Fase 5** | UAT | Antes de producción | Product Team | 2-3 días |

### 2.2. Entornos de Testing

| Entorno | Propósito | Configuración |
|---------|-----------|---------------|
| **Local** | Development, unit tests | Debug mode, no obfuscation |
| **CI/CD** | Automated tests | Debug mode, no obfuscation |
| **Staging** | Integration tests | Release mode, WITH obfuscation |
| **Pre-Prod** | UAT, manual testing | Release mode, WITH obfuscation |
| **Production** | Live users | Release mode, WITH obfuscation |

### 2.3. Dispositivos de Prueba

**Android**:
| Dispositivo | OS Version | Arquitectura | Prioridad |
|-------------|------------|--------------|-----------|
| Google Pixel 6 | Android 13 | arm64-v8a | Alta |
| Samsung Galaxy S21 | Android 11 | arm64-v8a | Alta |
| Xiaomi Redmi Note 10 | Android 11 | arm64-v8a | Media |
| Emulator | Android 7.0 (API 24) | x86_64 | Media |

**iOS**:
| Dispositivo | OS Version | Arquitectura | Prioridad |
|-------------|------------|--------------|-----------|
| iPhone 12 | iOS 15 | arm64 | Alta |
| iPhone SE (2020) | iOS 14 | arm64 | Media |
| Simulator | iOS 17 | x86_64/arm64 | Baja |

---

## 3. Test Cases - Unit Tests

### TC-U-001: Repository Tests (Preservación de Funcionalidad)

**Objetivo**: Verificar que serialización JSON funciona con ofuscación

**Prerrequisitos**: Build con ofuscación habilitado

**Test**:
```dart
// test/repositories/note_repository_test.dart

test('toJson y fromJson funcionan con ofuscación', () async {
  // Arrange
  final note = Note(
    id: 1,
    title: 'Test Note',
    content: 'Content',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // Act - Serializar
  final json = note.toJson();

  // Assert - Verificar campos
  expect(json['id'], 1);
  expect(json['title'], 'Test Note');

  // Act - Deserializar
  final decoded = Note.fromJson(json);

  // Assert - Verificar objeto reconstruido
  expect(decoded.id, note.id);
  expect(decoded.title, note.title);
  expect(decoded.content, note.content);
});
```

**Criterio de Éxito**: Test pasa en build ofuscado

**Prioridad**: Crítica

---

### TC-U-002: ViewModel Tests

**Objetivo**: Verificar que lógica de negocio funciona post-ofuscación

**Test**:
```dart
test('ItemListViewModel carga items correctamente', () async {
  // Arrange
  final mockRepository = MockItemRepository();
  when(mockRepository.getAllItems()).thenAnswer(
    (_) async => Right([
      Item(id: 1, title: 'Item 1', description: 'Description 1',
           createdAt: DateTime.now(), updatedAt: DateTime.now()),
      Item(id: 2, title: 'Item 2', description: 'Description 2',
           createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ]),
  );

  final viewModel = ItemListViewModel(repository: mockRepository);

  // Act
  await viewModel.loadItems();

  // Assert
  expect(viewModel.items.length, 2);
  expect(viewModel.items[0].title, 'Item 1');
  expect(viewModel.isLoading, false);
  expect(viewModel.error, null);
});
```

**Criterio de Éxito**: Test pasa en build ofuscado

**Prioridad**: Alta

---

### TC-U-003: Error Handling Tests

**Objetivo**: Verificar que error handling funciona con ofuscación

**Test**:
```dart
test('ItemListViewModel maneja errores correctamente', () async {
  // Arrange
  final mockRepository = MockItemRepository();
  when(mockRepository.getAllItems()).thenAnswer(
    (_) async => Left(DatabaseFailure('Connection failed')),
  );

  final viewModel = ItemListViewModel(repository: mockRepository);

  // Act
  await viewModel.loadItems();

  // Assert
  expect(viewModel.items.length, 0);
  expect(viewModel.error, isNotNull);
  expect(viewModel.error, contains('failed'));
});
```

**Criterio de Éxito**: Test pasa, error handling funciona

**Prioridad**: Alta

---

## 4. Test Cases - Integration Tests

### TC-I-001: CRUD Completo de Notas

**Objetivo**: Verificar flujo completo de CRUD en build ofuscado

**Pasos**:
```dart
// integration_test/crud_test.dart

testWidgets('CRUD completo de notas funciona', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // 1. CREATE
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('title_field')), 'Test Note');
  await tester.enterText(find.byKey(Key('content_field')), 'Test Content');

  await tester.tap(find.byIcon(Icons.save));
  await tester.pumpAndSettle();

  // Verify: Nota aparece en lista
  expect(find.text('Test Note'), findsOneWidget);

  // 2. READ
  await tester.tap(find.text('Test Note'));
  await tester.pumpAndSettle();

  expect(find.text('Test Content'), findsOneWidget);

  // 3. UPDATE
  await tester.tap(find.byIcon(Icons.edit));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(Key('title_field')), 'Updated Note');
  await tester.tap(find.byIcon(Icons.save));
  await tester.pumpAndSettle();

  expect(find.text('Updated Note'), findsOneWidget);

  // 4. DELETE
  await tester.tap(find.text('Updated Note'));
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.delete));
  await tester.pumpAndSettle();

  // Confirmar eliminación
  await tester.tap(find.text('Eliminar'));
  await tester.pumpAndSettle();

  // Verify: Nota ya no aparece
  expect(find.text('Updated Note'), findsNothing);
});
```

**Criterio de Éxito**: Test pasa sin crashes

**Prioridad**: Crítica

---

### TC-I-002: Búsqueda de Notas

**Objetivo**: Verificar que búsqueda funciona con ofuscación

**Test**:
```dart
testWidgets('Búsqueda de notas funciona', (tester) async {
  // Setup: Crear 3 notas
  // ... (código de setup)

  // Act: Buscar
  await tester.enterText(find.byKey(Key('search_field')), 'Flutter');
  await tester.pumpAndSettle();

  // Assert: Solo items con "Flutter" aparecen
  expect(find.text('Flutter Item 1'), findsOneWidget);
  expect(find.text('Flutter Item 2'), findsOneWidget);
  expect(find.text('Dart Item'), findsNothing);
});
```

**Criterio de Éxito**: Búsqueda retorna resultados correctos

**Prioridad**: Alta

---

## 5. Test Cases - Manual Testing

### TC-M-001: Funcionalidad Core

**Checklist** (ejecutar en dispositivo real con APK ofuscado):

#### Creación de Notas
- [ ] **TC-M-001-01**: Crear nota con título y contenido
- [ ] **TC-M-001-02**: Crear nota solo con título
- [ ] **TC-M-001-03**: Crear nota con contenido largo (1000+ chars)
- [ ] **TC-M-001-04**: Crear nota con caracteres especiales (émojis, ñ, acentos)
- [ ] **TC-M-001-05**: Crear 100+ notas (performance)

#### Edición de Notas
- [ ] **TC-M-001-06**: Editar título de nota existente
- [ ] **TC-M-001-07**: Editar contenido de nota existente
- [ ] **TC-M-001-08**: Editar y guardar, luego reabrir (persiste cambios)

#### Eliminación de Notas
- [ ] **TC-M-001-09**: Eliminar nota (con confirmación)
- [ ] **TC-M-001-10**: Cancelar eliminación
- [ ] **TC-M-001-11**: Eliminar todas las notas

#### Búsqueda
- [ ] **TC-M-001-12**: Buscar por título
- [ ] **TC-M-001-13**: Buscar por contenido
- [ ] **TC-M-001-14**: Búsqueda sin resultados
- [ ] **TC-M-001-15**: Búsqueda con texto vacío (mostrar todas)

---

### TC-M-002: Casos Edge

**Checklist**:

#### Rotación de Pantalla
- [ ] **TC-M-002-01**: Rotar en lista de notas (estado preservado)
- [ ] **TC-M-002-02**: Rotar mientras se edita nota (texto no se pierde)
- [ ] **TC-M-002-03**: Rotar durante búsqueda (resultados preservados)

#### Background/Foreground
- [ ] **TC-M-002-04**: Enviar app a background, traer de vuelta (sin crash)
- [ ] **TC-M-002-05**: Editar nota, enviar a background, traer de vuelta (texto preservado)
- [ ] **TC-M-002-06**: Minimizar por > 10 minutos, reabrir (sin crash)

#### Reinicio de App
- [ ] **TC-M-002-07**: Crear nota, cerrar app, reabrir (nota persiste)
- [ ] **TC-M-002-08**: Forzar cierre (kill), reabrir (sin crash, datos OK)

#### Conectividad
- [ ] **TC-M-002-09**: Usar app sin internet (funciona normalmente)
- [ ] **TC-M-002-10**: Modo avión activado (funciona normalmente)

---

### TC-M-003: Performance

**Métricas**:

| Métrica | Target | Cómo Medir |
|---------|--------|------------|
| **Startup Time** | < 3 segundos | Cronómetro desde tap icon hasta UI cargada |
| **Lista con 100 notas** | Scroll fluido (60 FPS) | Inspección visual |
| **Creación de nota** | < 500 ms | Cronómetro tap guardar → nota aparece |
| **Búsqueda 100 notas** | < 1 segundo | Cronómetro tipo texto → resultados |

**Checklist**:
- [ ] **TC-M-003-01**: Startup time < 3s
- [ ] **TC-M-003-02**: Scroll lista 100 notas es fluido
- [ ] **TC-M-003-03**: Crear nota < 500ms
- [ ] **TC-M-003-04**: Búsqueda < 1s

---

## 6. Test Cases - Seguridad

### TC-S-001: Verificar Ofuscación de Código

**Objetivo**: Confirmar que código Dart está ofuscado

**Pasos**:
```bash
# 1. Extraer APK
unzip app-release.apk -d extracted/

# 2. Buscar nombres de clases originales
strings extracted/lib/arm64-v8a/libapp.so | grep -i "UserRepository\|DataService\|MyViewModel"

# Expected: Sin resultados

# 3. Buscar símbolos ofuscados
strings extracted/lib/arm64-v8a/libapp.so | head -50

# Expected: Nombres cortos (a, b, c, aa, ab...)
```

**Criterio de Éxito**:
- 0 matches de clases originales ("UserRepository", "DataService", etc.)
- ≥95% de símbolos son nombres cortos

**Prioridad**: Crítica

---

### TC-S-002: Verificar Shrinking de Código Android

**Objetivo**: Confirmar que R8 eliminó código no usado

**Pasos**:
```bash
# 1. Ver código eliminado
cat build/app/outputs/mapping/release/usage.txt | wc -l

# Expected: > 100 líneas (mucho código eliminado)

# 2. Ver tamaño reducción
echo "APK sin minificación: 15 MB"
echo "APK con minificación: $(du -h app-release.apk | cut -f1)"

# Expected: ≤ 11.3 MB (≥25% reducción)
```

**Criterio de Éxito**:
- APK reducido ≥25%
- Código no usado eliminado

**Prioridad**: Alta

---

### TC-S-003: Verificar Mapping Files

**Objetivo**: Confirmar que mapping files se generaron correctamente

**Pasos**:
```bash
# 1. Verificar existencia
ls -lh build/app/outputs/mapping/release/

# Expected:
# mapping.txt
# configuration.txt
# seeds.txt
# usage.txt
# resources.txt

# 2. Verificar contenido de mapping.txt
head -10 build/app/outputs/mapping/release/mapping.txt

# Expected formato:
# com.example.note_keeper.MainActivity -> a.a.a:
```

**Criterio de Éxito**:
- Todos los archivos generados
- mapping.txt contiene mapeos

**Prioridad**: Crítica

---

### TC-S-004: Test de Des-ofuscación

**Objetivo**: Verificar que crashes pueden ser des-ofuscados

**Pasos**:
```bash
# 1. Provocar crash intencional
# (añadir botón en debug que lanza excepción)

# 2. Capturar stack trace
adb logcat > crash.txt

# 3. Des-ofuscar
flutter symbolize -i crash.txt -d releases/v0.1.0/symbols/

# 4. Verificar legibilidad
grep "UserRepository\|DataService" crash_deobfuscated.txt
```

**Criterio de Éxito**:
- Stack trace des-ofuscado muestra nombres originales
- Líneas de código correctas

**Prioridad**: Crítica

---

### TC-S-005: Análisis de Tiempo de Reversa

**Objetivo**: Estimar tiempo para ingeniería inversa completa

**Metodología**:
1. Entregar APK a security analyst externo
2. Medir tiempo para recuperar lógica de negocio principal
3. Medir tiempo para extraer estructura de base de datos

**Target**: ≥ 80 horas para reversa completa

**Criterio de Éxito**: Tiempo medido ≥ 80 horas

**Prioridad**: Alta

---

## 7. Criterios de Aceptación

### 7.1. Criterios Críticos (MUST PASS)

**Funcionalidad**:
- ✅ **CA-001**: 100% de unit tests pasando
- ✅ **CA-002**: 100% de integration tests pasando
- ✅ **CA-003**: 100% de checklist manual completado sin issues críticos
- ✅ **CA-004**: 0 crashes en testing (crash-free rate = 100%)

**Performance**:
- ✅ **CA-005**: Build time ≤ 5 minutos
- ✅ **CA-006**: Startup time < 3 segundos
- ✅ **CA-007**: App responsiva (scroll fluido, sin lag)

**Seguridad**:
- ✅ **CA-008**: APK reducido ≥ 25% vs baseline
- ✅ **CA-009**: IPA reducido ≥ 20% vs baseline
- ✅ **CA-010**: ≥95% de símbolos ofuscados
- ✅ **CA-011**: Mapping files generados y archivados

**Operación**:
- ✅ **CA-012**: Scripts de build funcionan sin errores
- ✅ **CA-013**: Des-ofuscación de crashes funciona

### 7.2. Criterios No Críticos (SHOULD PASS)

- ⚠️ **CA-014**: Nivel de seguridad ≥ 8/10 (auditoría externa)
- ⚠️ **CA-015**: Tiempo de reversa ≥ 80 horas (estimación)
- ⚠️ **CA-016**: Documentación completa (6 documentos)

---

## 8. Matriz de Cobertura

### 8.1. Cobertura por Requisito

| Requisito | Test Cases | Cobertura |
|-----------|------------|-----------|
| RF-01 (Ofuscación Dart) | TC-U-001, TC-S-001 | 100% |
| RF-02 (R8 Android) | TC-S-002 | 100% |
| RF-03 (Preservación código) | TC-U-001, TC-U-002, TC-I-001 | 100% |
| RF-04 (Mapping files) | TC-S-003, TC-S-004 | 100% |
| RF-05 (iOS strip) | TC-M-003 (iOS device) | 100% |
| RF-06 (Automatización) | Manual (script execution) | 100% |

### 8.2. Cobertura por Componente

| Componente | Unit | Integration | Manual | Security | Total |
|------------|------|-------------|--------|----------|-------|
| Models | ✅ | ✅ | ✅ | ✅ | 100% |
| Repositories | ✅ | ✅ | ✅ | ⚠️ | 90% |
| ViewModels | ✅ | ✅ | ✅ | N/A | 100% |
| Views | ⚠️ | ✅ | ✅ | N/A | 80% |
| Build System | N/A | N/A | ✅ | ✅ | 100% |

### 8.3. Cobertura por Plataforma

| Plataforma | Test Cases | Dispositivos | Cobertura |
|-----------|------------|--------------|-----------|
| Android | 25 | 4 (físicos + emulator) | 100% |
| iOS | 20 | 3 (físicos + simulator) | 80% |

---

## 9. Reporte de Testing

### 9.1. Template de Reporte

```markdown
# Reporte de Testing - v0.1.0

## Resumen Ejecutivo
- **Fecha**: ___/___/2025
- **Versión**: v0.1.0
- **Tester**: __________
- **Duración**: ___ horas

## Resultados

### Unit Tests
- Total: 50
- Passed: ___
- Failed: ___
- Pass Rate: ___%

### Integration Tests
- Total: 10
- Passed: ___
- Failed: ___
- Pass Rate: ___%

### Manual Tests
- Total: 30
- Passed: ___
- Failed: ___
- Pass Rate: ___%

### Security Tests
- Total: 5
- Passed: ___
- Failed: ___
- Pass Rate: ___%

## Métricas

| Métrica | Target | Actual | Status |
|---------|--------|--------|--------|
| APK Size | ≤11.3 MB | ___ MB | ___ |
| IPA Size | ≤16.0 MB | ___ MB | ___ |
| Build Time | ≤5 min | ___ min | ___ |
| Startup Time | <3 sec | ___ sec | ___ |
| Symbols Obf. | ≥95% | ___% | ___ |

## Issues Encontrados

### Critical
1. ___

### High
1. ___

### Medium
1. ___

### Low
1. ___

## Recomendación
- [ ] **APROBADO** - Listo para producción
- [ ] **APROBADO CON CONDICIONES** - Arreglar issues minor
- [ ] **RECHAZADO** - Issues críticos encontrados
```

---

## 10. Plan de Regresión

**Cuándo ejecutar tests de regresión**:
- Después de cada modificación de ProGuard rules
- Antes de cada release a producción
- Después de actualizar Flutter SDK
- Después de actualizar dependencias (plugins)

**Suite de Regresión**:
- Ejecutar todos los test cases de Sección 5 (Manual Testing)
- Verificar métricas de Sección 7 (Criterios de Aceptación)
- Tiempo estimado: 2-3 horas

---

**Documento creado**: 2025-10-11
**Aprobado por**: QA Lead
**Próxima revisión**: Después de cada release
