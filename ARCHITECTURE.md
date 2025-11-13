# Arquitectura del Proyecto - Pizzas Reyna

## 📐 Clean Architecture

El proyecto sigue los principios de Clean Architecture, separando las responsabilidades en tres capas principales:

### 1. Domain Layer (Capa de Dominio)
- **Entities**: Objetos de negocio inmutables (usando Freezed)
- **Repositories**: Interfaces que definen contratos de datos
- **Use Cases**: Lógica de negocio específica (opcional, para casos complejos)

### 2. Data Layer (Capa de Datos)
- **Models**: DTOs para serialización JSON
- **Data Sources**: Implementaciones de acceso a datos (Remote, Local)
- **Repositories**: Implementaciones concretas de las interfaces del dominio
- **Mappers**: Transformación entre Models y Entities

### 3. Presentation Layer (Capa de Presentación)
- **Pages**: Pantallas de la aplicación
- **Widgets**: Componentes reutilizables de UI
- **Providers**: State management con Riverpod
- **View Models**: Lógica de presentación (integrada en providers)

## 🗂️ Estructura de Carpetas

```
lib/
├── core/                           # Código compartido
│   ├── config/                     # Configuración
│   │   ├── env_config.dart        # Variables de entorno
│   │   └── flavor_config.dart     # Configuración de flavors
│   ├── constants/                  # Constantes
│   │   ├── app_colors.dart        # Paleta de colores
│   │   └── app_strings.dart       # Strings de la app
│   ├── network/                    # Networking
│   │   ├── api_response.dart      # Wrapper de respuestas
│   │   ├── dio_client.dart        # Cliente HTTP
│   │   └── network_exception.dart # Excepciones personalizadas
│   ├── theme/                      # Tema
│   │   └── app_theme.dart         # Material Design 3
│   ├── utils/                      # Utilidades
│   │   ├── connectivity_utils.dart
│   │   └── logger_utils.dart
│   └── widgets/                    # Widgets compartidos
│       ├── custom_button.dart
│       ├── empty_state.dart
│       ├── error_view.dart
│       └── price_indicator.dart
│
├── features/                       # Funcionalidades
│   ├── catalog/                    # Catálogo de pizzas
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── pizza_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── pizza_model.dart
│   │   │   │   └── pizza_category_model.dart
│   │   │   └── repositories/
│   │   │       └── pizza_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── pizza.dart
│   │   │   │   └── pizza_category.dart
│   │   │   └── repositories/
│   │   │       └── pizza_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── catalog_page.dart
│   │       ├── providers/
│   │       │   └── pizza_providers.dart
│   │       └── widgets/
│   │           ├── category_filter.dart
│   │           ├── pizza_card.dart
│   │           └── pizza_grid_shimmer.dart
│   │
│   ├── builder/                    # Constructor de pizzas
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── cart/                       # Carrito de compras
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── tracking/                   # Seguimiento de pedidos
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/                    # Perfil de usuario
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── injection_container.dart        # Inyección de dependencias
└── main.dart                       # Punto de entrada

test/                               # Tests
├── features/
│   └── catalog/
│       ├── domain/
│       │   └── entities/
│       │       └── pizza_test.dart
│       └── presentation/
│           └── widgets/
│               └── pizza_card_test.dart
└── ...
```

## 🔄 Flujo de Datos

```
UI (Widget) 
    ↓ (user action)
Provider (Riverpod)
    ↓ (calls)
Repository Interface (Domain)
    ↓ (implements)
Repository Implementation (Data)
    ↓ (uses)
Data Source (Remote/Local)
    ↓ (fetches)
API / Local Storage
    ↓ (returns)
Model (Data)
    ↓ (maps to)
Entity (Domain)
    ↓ (updates)
Provider State
    ↓ (rebuilds)
UI (Widget)
```

## 🎯 Principios Aplicados

### SOLID
- **S**ingle Responsibility: Cada clase tiene una única responsabilidad
- **O**pen/Closed: Abierto para extensión, cerrado para modificación
- **L**iskov Substitution: Las implementaciones pueden sustituir interfaces
- **I**nterface Segregation: Interfaces específicas y pequeñas
- **D**ependency Inversion: Dependencias hacia abstracciones

### DRY (Don't Repeat Yourself)
- Widgets reutilizables en `core/widgets/`
- Utilidades compartidas en `core/utils/`
- Constantes centralizadas en `core/constants/`

### Separation of Concerns
- Lógica de negocio en Domain
- Acceso a datos en Data
- UI y estado en Presentation

## 🔌 Inyección de Dependencias

Usamos **GetIt** para inyección de dependencias:

```dart
// Registro en injection_container.dart
getIt.registerLazySingleton<PizzaRepository>(
  () => PizzaRepositoryImpl(getIt<PizzaRemoteDataSource>()),
);

// Uso en providers
@riverpod
PizzaRepository pizzaRepository(PizzaRepositoryRef ref) {
  return getIt<PizzaRepository>();
}
```

## 📦 State Management

### Riverpod con Code Generation

```dart
// Provider simple
@riverpod
Future<List<Pizza>> pizzas(PizzasRef ref) async {
  final repository = ref.watch(pizzaRepositoryProvider);
  return repository.getPizzas();
}

// Notifier para estado mutable
@riverpod
class PizzaCatalog extends _$PizzaCatalog {
  @override
  PizzaCatalogState build() {
    return PizzaCatalogState();
  }

  void loadMore() {
    // Lógica para cargar más pizzas
  }
}
```

## 🧪 Testing

### Estructura de Tests
- **Unit Tests**: Lógica de negocio y utilidades
- **Widget Tests**: Componentes de UI
- **Integration Tests**: Flujos completos (opcional)

### Mocking
Usamos **Mockito** para crear mocks de dependencias:

```dart
@GenerateMocks([PizzaRepository])
void main() {
  late MockPizzaRepository mockRepository;

  setUp(() {
    mockRepository = MockPizzaRepository();
  });

  test('should return list of pizzas', () async {
    // Arrange
    when(mockRepository.getPizzas())
        .thenAnswer((_) async => [testPizza]);

    // Act
    final result = await mockRepository.getPizzas();

    // Assert
    expect(result, [testPizza]);
  });
}
```

## 🎨 UI/UX Guidelines

### Material Design 3
- Componentes M3: Cards, Buttons, NavigationBar
- Elevation y sombras sutiles
- Esquinas redondeadas (8-12px)

### Responsive Design
- **Mobile** (< 800px): Bottom Navigation
- **Tablet** (800-1200px): Navigation Rail
- **Desktop** (> 1200px): Drawer Navigation

### Animaciones
- Hero transitions entre pantallas
- Staggered animations en listas
- Shimmer effects para loading

### Accesibilidad
- Contraste de colores WCAG AA
- Tamaños de fuente escalables
- Semantic labels para screen readers

## 🔐 Seguridad

- Variables de entorno para API keys
- Tokens JWT para autenticación
- Validación de inputs
- Sanitización de datos
- HTTPS obligatorio

## 📱 Flavors

### Development
- Logging habilitado
- API de desarrollo
- Debug mode

### Staging
- Logging habilitado
- API de staging
- Release mode

### Production
- Logging deshabilitado
- API de producción
- Release mode optimizado

## 🚀 Performance

### Optimizaciones
- Lazy loading de imágenes con `cached_network_image`
- Paginación infinita en listas
- Debouncing en búsquedas
- Memoization de cálculos costosos
- Build optimizations con `const` constructors

### Monitoring
- Logger para debug
- Error tracking (Firebase Crashlytics)
- Analytics (Firebase Analytics)

## 📚 Recursos Adicionales

- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design 3](https://m3.material.io/)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
