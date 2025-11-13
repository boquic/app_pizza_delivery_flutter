# Próximos Pasos - Pizzas Reyna

## ✅ Completado

### Setup Inicial
- [x] Estructura de carpetas Clean Architecture
- [x] Configuración de dependencias (pubspec.yaml)
- [x] Variables de entorno (.env)
- [x] Tema Material Design 3
- [x] Paleta de colores personalizada
- [x] Cliente HTTP con Dio
- [x] Inyección de dependencias con GetIt
- [x] Configuración de flavors (dev, staging, prod)

### Feature: Catálogo de Pizzas
- [x] Entidades de dominio (Pizza, PizzaCategory)
- [x] Modelos de datos con Freezed
- [x] Repositorio e implementación
- [x] Data source remoto
- [x] Providers con Riverpod
- [x] Página de catálogo con grid
- [x] Widget PizzaCard reutilizable
- [x] Filtro por categorías
- [x] Paginación infinita
- [x] Shimmer loading effect
- [x] Manejo de errores
- [x] Pull to refresh

### Core
- [x] Widgets reutilizables (CustomButton, ErrorView, EmptyState, PriceIndicator)
- [x] Utilidades (Logger, Connectivity)
- [x] Constantes (Colores, Strings)
- [x] Excepciones personalizadas
- [x] API Response wrapper

### Testing
- [x] Tests unitarios para entidades
- [x] Tests de widgets para PizzaCard
- [x] Configuración de CI/CD con GitHub Actions

### Documentación
- [x] README.md completo
- [x] ARCHITECTURE.md
- [x] CONTRIBUTING.md
- [x] .env.example
- [x] Scripts de ayuda (Windows)

## 🚧 Pendiente

### 1. Constructor de Pizza Personalizada (Prioridad Alta)

#### Entidades y Modelos
- [ ] Crear entidad `Ingredient` (id, name, price, category, imageUrl)
- [ ] Crear entidad `PizzaSize` (id, name, multiplier)
- [ ] Crear entidad `DoughType` (id, name, price)
- [ ] Crear entidad `Combo` (id, name, items, price)
- [ ] Crear entidad `CustomPizza` (size, dough, ingredients, combos, totalPrice)

#### Data Layer
- [ ] Implementar `IngredientRemoteDataSource`
- [ ] Implementar `IngredientRepository`
- [ ] Crear modelos con Freezed y JSON serialization

#### Presentation Layer
- [ ] Crear `PizzaBuilderPage` con wizard de 4 pasos
- [ ] Implementar `SizeSelector` widget
- [ ] Implementar `DoughSelector` widget
- [ ] Implementar `IngredientSelector` widget (máximo 8)
- [ ] Implementar `ComboSelector` widget
- [ ] Crear `PizzaPreview` widget con visualización
- [ ] Implementar cálculo de precio en tiempo real
- [ ] Agregar validaciones (máximo ingredientes)
- [ ] Implementar navegación entre pasos
- [ ] Hero transition desde catálogo

#### Providers
- [ ] `pizzaBuilderProvider` para estado del wizard
- [ ] `ingredientsProvider` para lista de ingredientes
- [ ] `sizesProvider` para tamaños disponibles
- [ ] `doughTypesProvider` para tipos de masa
- [ ] `combosProvider` para combos disponibles

### 2. Carrito de Compras (Prioridad Alta)

#### Entidades y Modelos
- [ ] Crear entidad `CartItem` (pizza, quantity, customizations)
- [ ] Crear entidad `Cart` (items, subtotal, delivery, tip, total)
- [ ] Crear entidad `Address` (street, city, coordinates, isDefault)
- [ ] Crear entidad `PaymentMethod` (type, details)

#### Data Layer
- [ ] Implementar `CartLocalDataSource` con shared_preferences
- [ ] Implementar `CartRepository`
- [ ] Implementar persistencia local del carrito

#### Presentation Layer
- [ ] Crear `CartPage` con lista de items
- [ ] Implementar `CartItem` widget
- [ ] Implementar edición de cantidad
- [ ] Implementar eliminación de items
- [ ] Crear `AddressSelector` con Google Places autocomplete
- [ ] Crear `PaymentMethodSelector`
- [ ] Implementar selector de propina (0%, 10%, 15%, 20%, custom)
- [ ] Mostrar resumen de precios
- [ ] Botón de checkout

#### Providers
- [ ] `cartProvider` para estado del carrito
- [ ] `addressesProvider` para direcciones guardadas
- [ ] `paymentMethodsProvider` para métodos de pago

### 3. Seguimiento en Tiempo Real (Prioridad Media)

#### Entidades y Modelos
- [ ] Crear entidad `Order` (id, items, status, deliveryAddress, estimatedTime)
- [ ] Crear entidad `OrderStatus` (pending, preparing, onTheWay, delivered)
- [ ] Crear entidad `DeliveryLocation` (lat, lng, timestamp)

#### Data Layer
- [ ] Implementar `WebSocketService` para tracking
- [ ] Implementar `OrderRemoteDataSource`
- [ ] Implementar `OrderRepository`
- [ ] Configurar Firebase Messaging

#### Presentation Layer
- [ ] Crear `TrackingPage` con mapa
- [ ] Implementar `OrderMap` widget con flutter_map
- [ ] Crear `StatusTimeline` widget animado
- [ ] Implementar actualización en tiempo real
- [ ] Mostrar ubicación del repartidor
- [ ] Mostrar tiempo estimado de entrega
- [ ] Push notifications para cambios de estado

#### Providers
- [ ] `orderTrackingProvider` para WebSocket connection
- [ ] `deliveryLocationProvider` para ubicación del repartidor
- [ ] `orderStatusProvider` para estado del pedido

### 4. Perfil de Usuario (Prioridad Media)

#### Entidades y Modelos
- [ ] Crear entidad `User` (id, name, email, phone, avatar)
- [ ] Crear entidad `OrderHistory` (orders, pagination)
- [ ] Crear entidad `Favorite` (pizzaId, addedAt)

#### Data Layer
- [ ] Implementar `UserRemoteDataSource`
- [ ] Implementar `UserRepository`
- [ ] Implementar autenticación JWT

#### Presentation Layer
- [ ] Crear `ProfilePage`
- [ ] Implementar `OrderHistoryList`
- [ ] Implementar "Repetir orden"
- [ ] Crear `AddressManagement` page
- [ ] Crear `FavoritesList` page
- [ ] Implementar chat de soporte (opcional)
- [ ] Implementar edición de perfil

#### Providers
- [ ] `userProvider` para datos del usuario
- [ ] `orderHistoryProvider` para historial
- [ ] `favoritesProvider` para favoritos

### 5. Navegación y Routing (Prioridad Alta)

- [ ] Configurar go_router
- [ ] Definir rutas de la aplicación
- [ ] Implementar deep linking
- [ ] Configurar navegación bottom/rail/drawer según tamaño
- [ ] Implementar guards de autenticación

### 6. Autenticación (Prioridad Media)

- [ ] Crear `LoginPage`
- [ ] Crear `RegisterPage`
- [ ] Implementar autenticación con JWT
- [ ] Implementar refresh token
- [ ] Guardar token en secure storage
- [ ] Implementar logout

### 7. Mejoras de UI/UX (Prioridad Baja)

- [ ] Implementar animaciones Hero
- [ ] Agregar staggered animations en listas
- [ ] Implementar skeleton loaders
- [ ] Agregar haptic feedback
- [ ] Implementar dark mode
- [ ] Mejorar accesibilidad (semantic labels)
- [ ] Agregar onboarding screens

### 8. Testing Adicional (Prioridad Media)

- [ ] Tests para PizzaBuilder
- [ ] Tests para Cart
- [ ] Tests para Tracking
- [ ] Tests de integración
- [ ] Aumentar cobertura a 70%+

### 9. Performance y Optimización (Prioridad Baja)

- [ ] Implementar image caching strategy
- [ ] Optimizar build methods
- [ ] Implementar lazy loading
- [ ] Reducir tamaño del APK
- [ ] Implementar code splitting

### 10. Monitoreo y Analytics (Prioridad Baja)

- [ ] Configurar Firebase Crashlytics
- [ ] Configurar Firebase Analytics
- [ ] Implementar event tracking
- [ ] Configurar performance monitoring

## 📋 Checklist de Desarrollo

Para cada nueva feature:

1. **Planificación**
   - [ ] Definir entidades de dominio
   - [ ] Diseñar API contracts
   - [ ] Crear mockups/wireframes

2. **Implementación**
   - [ ] Crear entidades (domain/entities)
   - [ ] Crear modelos (data/models)
   - [ ] Implementar data sources
   - [ ] Implementar repositorios
   - [ ] Crear providers
   - [ ] Implementar UI

3. **Testing**
   - [ ] Unit tests para lógica de negocio
   - [ ] Widget tests para componentes
   - [ ] Integration tests para flujos

4. **Documentación**
   - [ ] Dartdoc en código
   - [ ] Actualizar README si necesario
   - [ ] Agregar ejemplos de uso

5. **Review**
   - [ ] Code review
   - [ ] Testing manual
   - [ ] Verificar performance
   - [ ] Verificar accesibilidad

## 🎯 Hitos del Proyecto

### Milestone 1: MVP (4 semanas)
- Catálogo de pizzas ✅
- Constructor de pizza personalizada
- Carrito básico
- Checkout simple

### Milestone 2: Core Features (4 semanas)
- Autenticación
- Perfil de usuario
- Historial de pedidos
- Seguimiento básico

### Milestone 3: Advanced Features (4 semanas)
- Seguimiento en tiempo real con mapa
- Push notifications
- Chat de soporte
- Favoritos

### Milestone 4: Polish (2 semanas)
- Animaciones
- Dark mode
- Optimizaciones
- Testing completo

## 📞 Contacto

Para preguntas o sugerencias sobre el roadmap:
- Email: dev@pizzasreyna.com
- Slack: #pizzas-reyna-dev

## 📝 Notas

- Priorizar features según feedback de usuarios
- Mantener cobertura de tests > 70%
- Hacer releases incrementales
- Documentar decisiones arquitectónicas importantes
