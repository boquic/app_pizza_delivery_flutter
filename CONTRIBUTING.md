# Guía de Contribución - Pizzas Reyna

## 🤝 Cómo Contribuir

Gracias por tu interés en contribuir al proyecto Pizzas Reyna. Esta guía te ayudará a entender el proceso de contribución.

## 📋 Antes de Empezar

1. Asegúrate de tener instalado:
   - Flutter 3.19+
   - Dart 3.2+
   - Git

2. Familiarízate con:
   - Clean Architecture
   - Riverpod
   - Material Design 3
   - Freezed y code generation

## 🔀 Flujo de Trabajo

### 1. Fork y Clone

```bash
git clone https://github.com/tu-usuario/pizzas-reyna-flutter.git
cd pizzas-reyna-flutter
```

### 2. Crear una Rama

```bash
git checkout -b feature/nombre-de-tu-feature
# o
git checkout -b fix/nombre-del-bug
```

### 3. Instalar Dependencias

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Hacer Cambios

- Sigue las convenciones de código
- Escribe tests para tu código
- Documenta funciones públicas
- Mantén commits atómicos y descriptivos

### 5. Ejecutar Tests

```bash
flutter test
flutter analyze
dart format lib/
```

### 6. Commit

```bash
git add .
git commit -m "feat: descripción del cambio"
```

### 7. Push y Pull Request

```bash
git push origin feature/nombre-de-tu-feature
```

Luego crea un Pull Request en GitHub.

## 📝 Convenciones de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Cambios de formato (no afectan el código)
- `refactor:` Refactorización de código
- `test:` Agregar o modificar tests
- `chore:` Tareas de mantenimiento

Ejemplos:
```
feat: agregar filtro por categoría en catálogo
fix: corregir error en cálculo de precio
docs: actualizar README con instrucciones de setup
refactor: simplificar lógica de paginación
test: agregar tests para PizzaCard widget
```

## 🎨 Estándares de Código

### Dart/Flutter

1. **Nombres**
   - Clases: `PascalCase`
   - Variables/Funciones: `camelCase`
   - Archivos: `snake_case.dart`
   - Constantes: `camelCase` o `SCREAMING_SNAKE_CASE`

2. **Formato**
   ```bash
   dart format lib/
   ```

3. **Análisis**
   ```bash
   flutter analyze
   ```

4. **Imports**
   - Primero: dart packages
   - Segundo: flutter packages
   - Tercero: third-party packages
   - Cuarto: imports relativos

   ```dart
   import 'dart:async';
   
   import 'package:flutter/material.dart';
   
   import 'package:riverpod/riverpod.dart';
   
   import '../domain/entities/pizza.dart';
   ```

### Estructura de Archivos

```dart
// 1. Imports
import 'package:flutter/material.dart';

// 2. Part statements (si aplica)
part 'file.g.dart';
part 'file.freezed.dart';

// 3. Constantes privadas
const _kConstant = 'value';

// 4. Clase principal
class MyWidget extends StatelessWidget {
  // 4.1 Campos
  final String title;
  
  // 4.2 Constructor
  const MyWidget({
    super.key,
    required this.title,
  });
  
  // 4.3 Métodos públicos
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 4.4 Métodos privados
  void _privateMethod() {}
}

// 5. Clases auxiliares privadas
class _PrivateHelper {}
```

## 🧪 Testing

### Cobertura Mínima

- Unit tests: 80%
- Widget tests: 70%
- Integration tests: 50%

### Escribir Tests

```dart
void main() {
  group('Feature Tests', () {
    setUp(() {
      // Setup antes de cada test
    });

    tearDown(() {
      // Cleanup después de cada test
    });

    test('should do something', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = doSomething(input);
      
      // Assert
      expect(result, 'expected');
    });
  });
}
```

### Widget Tests

```dart
testWidgets('should display widget correctly', (tester) async {
  // Arrange
  await tester.pumpWidget(
    MaterialApp(home: MyWidget()),
  );

  // Act
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();

  // Assert
  expect(find.text('Result'), findsOneWidget);
});
```

## 📚 Documentación

### Dartdoc

Documenta todas las clases y métodos públicos:

```dart
/// Repositorio para gestionar pizzas.
///
/// Proporciona métodos para obtener, crear y actualizar pizzas
/// desde diferentes fuentes de datos.
abstract class PizzaRepository {
  /// Obtiene una lista paginada de pizzas.
  ///
  /// [page] es el número de página (empezando en 1).
  /// [limit] es la cantidad de items por página.
  /// [category] es un filtro opcional por categoría.
  ///
  /// Retorna una lista de [Pizza] o lanza una excepción si falla.
  Future<List<Pizza>> getPizzas({
    required int page,
    required int limit,
    String? category,
  });
}
```

## 🐛 Reportar Bugs

Al reportar un bug, incluye:

1. **Descripción clara** del problema
2. **Pasos para reproducir**
3. **Comportamiento esperado**
4. **Comportamiento actual**
5. **Screenshots** (si aplica)
6. **Versión de Flutter/Dart**
7. **Dispositivo/OS**

## ✨ Solicitar Features

Al solicitar una feature:

1. **Descripción clara** de la funcionalidad
2. **Caso de uso** (por qué es necesaria)
3. **Propuesta de implementación** (opcional)
4. **Mockups/Wireframes** (si aplica)

## 🔍 Code Review

### Checklist del Revisor

- [ ] El código sigue las convenciones del proyecto
- [ ] Los tests pasan y hay cobertura adecuada
- [ ] La documentación está actualizada
- [ ] No hay código duplicado
- [ ] Las funciones son pequeñas y enfocadas
- [ ] Los nombres son descriptivos
- [ ] No hay hardcoded values (usar constantes)
- [ ] Manejo apropiado de errores
- [ ] Performance considerada
- [ ] Accesibilidad considerada

### Checklist del Autor

Antes de solicitar review:

- [ ] He ejecutado `flutter analyze` sin errores
- [ ] He ejecutado `flutter test` y todos pasan
- [ ] He formateado el código con `dart format`
- [ ] He actualizado la documentación
- [ ] He agregado tests para mi código
- [ ] He probado en diferentes dispositivos/tamaños
- [ ] He verificado que no rompo funcionalidad existente

## 🎯 Prioridades

### Alta Prioridad
- Bugs críticos que rompen la app
- Problemas de seguridad
- Pérdida de datos

### Media Prioridad
- Bugs menores
- Mejoras de performance
- Refactorizaciones importantes

### Baja Prioridad
- Mejoras de UI/UX
- Optimizaciones menores
- Documentación

## 💬 Comunicación

- **Issues**: Para bugs y features
- **Pull Requests**: Para cambios de código
- **Discussions**: Para preguntas y discusiones generales

## 📜 Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la misma licencia del proyecto.

## 🙏 Agradecimientos

¡Gracias por contribuir a Pizzas Reyna! Tu ayuda hace que este proyecto sea mejor para todos.
