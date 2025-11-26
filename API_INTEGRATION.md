# Integración con API Backend - Pizzas Reyna

## 📋 Resumen de Cambios

Este documento describe la integración del frontend Flutter con el backend actualizado.

## 🔧 Configuración

### 1. Variables de Entorno

Actualiza tu archivo `.env` según tu entorno:

```env
# Desarrollo Local (iOS Simulator)
API_BASE_URL=http://localhost:8080

# Desarrollo Local (Android Emulator)
API_BASE_URL=http://10.0.2.2:8080

# Producción
API_BASE_URL=https://api.pizzasreyna.com
```

### 2. Dependencias Requeridas

Asegúrate de tener estas dependencias en `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.4.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  shared_preferences: ^2.2.2
  stomp_dart_client: ^1.0.0
  flutter_dotenv: ^5.1.0
  logger: ^2.0.2

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

## 📁 Estructura de Archivos Creados

### Modelos Core
- `lib/core/models/ingrediente_model.dart` - Modelo de ingredientes
- `lib/core/models/usuario_model.dart` - Modelo de usuario

### Autenticación
- `lib/features/auth/data/models/auth_response_model.dart`
- `lib/features/auth/data/models/login_request_model.dart`
- `lib/features/auth/data/models/register_request_model.dart`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/core/storage/auth_storage.dart`

### Catálogo (Actualizado)
- `lib/features/catalog/data/models/pizza_model.dart` - Actualizado para coincidir con API
- `lib/features/catalog/data/datasources/pizza_api_datasource.dart`

### Carrito
- `lib/features/cart/data/models/carrito_model.dart`
- `lib/features/cart/data/models/carrito_item_model.dart`
- `lib/features/cart/data/models/agregar_item_request_model.dart`
- `lib/features/cart/data/datasources/cart_remote_datasource.dart`

### Pedidos
- `lib/features/orders/data/models/pedido_model.dart`
- `lib/features/orders/data/models/pedido_detalle_model.dart`
- `lib/features/orders/data/models/crear_pedido_request_model.dart`
- `lib/features/orders/data/datasources/orders_remote_datasource.dart`

### Admin
- `lib/features/admin/data/models/crear_pizza_request_model.dart`
- `lib/features/admin/data/datasources/admin_pizzas_datasource.dart`
- `lib/features/admin/data/datasources/admin_orders_datasource.dart`

### Servicios
- `lib/core/services/websocket_service.dart` - Tracking en tiempo real
- `lib/core/constants/api_constants.dart` - Constantes de estados y tamaños

## 🚀 Uso

### Generar Código Freezed

Después de crear los modelos, ejecuta:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Autenticación

```dart
// Login
final authDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);
final response = await authDataSource.login(
  LoginRequestModel(
    email: 'admin@pizzasreyna.com',
    password: 'admin123',
  ),
);

// Guardar token
final authStorage = AuthStorage(prefs);
await authStorage.saveToken(response.token, response.refreshToken);
await authStorage.saveUserId(response.usuario.id);
await authStorage.saveUserRol(response.usuario.rol);

// Configurar token en DioClient
dioClient.setAuthToken(response.token);
```

### Obtener Pizzas

```dart
final pizzaDataSource = PizzaApiDataSourceImpl(dioClient: dioClient);
final pizzas = await pizzaDataSource.getPizzas();
```

### Carrito

```dart
final cartDataSource = CartRemoteDataSourceImpl(dioClient: dioClient);

// Obtener carrito
final carrito = await cartDataSource.getCarrito();

// Agregar item
await cartDataSource.agregarItem(
  AgregarItemRequestModel(
    pizzaId: 1,
    cantidad: 2,
    notas: 'Sin cebolla',
    ingredientesPersonalizadosIds: [10, 12],
  ),
);

// Limpiar carrito
await cartDataSource.limpiarCarrito();
```

### Pedidos

```dart
final ordersDataSource = OrdersRemoteDataSourceImpl(dioClient: dioClient);

// Crear pedido
final pedido = await ordersDataSource.crearPedido(
  CrearPedidoRequestModel(
    direccionEntrega: 'Av. Principal 123',
    telefonoContacto: '987654321',
    notas: 'Tocar el timbre',
    items: [
      CrearPedidoItemModel(
        pizzaId: 1,
        cantidad: 2,
        notas: 'Sin cebolla',
      ),
    ],
  ),
);

// Historial
final historial = await ordersDataSource.getHistorialPedidos();

// Detalle
final detalle = await ordersDataSource.getPedidoById(1);
```

### WebSocket (Tracking)

```dart
final wsService = WebSocketService();

// Conectar
wsService.connect(
  onPedidoUpdate: (estado) {
    print('Estado actualizado: ${estado['estadoNombre']}');
  },
  onNuevoPedido: (pedidoId) {
    print('Nuevo pedido: $pedidoId');
  },
);

// Suscribirse a un pedido específico
wsService.subscribeToPedido(1, (estado) {
  print('Pedido #1 - Estado: ${estado['estadoNombre']}');
});

// Desconectar
wsService.disconnect();
```

### Admin

```dart
final adminPizzasDataSource = AdminPizzasDataSourceImpl(dioClient: dioClient);
final adminOrdersDataSource = AdminOrdersDataSourceImpl(dioClient: dioClient);

// Crear pizza
await adminPizzasDataSource.crearPizza(
  CrearPizzaRequestModel(
    nombre: 'Pizza BBQ',
    descripcion: 'Pizza con salsa BBQ',
    precioBase: 35.0,
    tamanio: TamanioPizza.grande,
    disponible: true,
    esPersonalizada: false,
  ),
);

// Actualizar estado de pedido
await adminOrdersDataSource.actualizarEstado(1, EstadoPedido.enCamino);

// Asignar repartidor
await adminOrdersDataSource.asignarRepartidor(1, 5);
```

## 🔐 Credenciales de Prueba

### Admin
- Email: `admin@pizzasreyna.com`
- Password: `admin123`

## 📝 Notas Importantes

1. **Interceptor de Autenticación**: El `DioClient` ahora incluye automáticamente el token en todas las peticiones si está disponible en `AuthStorage`.

2. **Manejo de Errores**: Todos los datasources incluyen manejo de errores específico para códigos HTTP comunes (401, 403, 404, etc.).

3. **WebSocket**: Requiere que el backend esté corriendo para establecer la conexión.

4. **Modelos Freezed**: Todos los modelos usan Freezed para inmutabilidad y generación de código.

5. **Estados de Pedido**: Usa las constantes en `EstadoPedido` para evitar errores de tipeo.

6. **Tamaños de Pizza**: Usa las constantes en `TamanioPizza` para consistencia.

## 🔄 Próximos Pasos

1. Ejecutar `build_runner` para generar código Freezed
2. Implementar repositorios y casos de uso siguiendo Clean Architecture
3. Crear providers con Riverpod para gestión de estado
4. Implementar UI para login, registro, catálogo, carrito y pedidos
5. Agregar manejo de errores en UI
6. Implementar tracking en tiempo real con WebSocket
7. Crear panel de administración

## 🐛 Troubleshooting

### Error de conexión en Android Emulator
Usa `http://10.0.2.2:8080` en lugar de `localhost:8080`

### Token expirado
El interceptor limpia automáticamente el storage cuando recibe un 401

### WebSocket no conecta
Verifica que el backend esté corriendo y que la URL sea correcta
