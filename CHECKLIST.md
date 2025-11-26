# ✅ Checklist de Integración Backend

## 📋 Verificación de Archivos Creados

### Modelos Core
- [x] `lib/core/models/ingrediente_model.dart`
- [x] `lib/core/models/usuario_model.dart`

### Autenticación
- [x] `lib/features/auth/data/models/auth_response_model.dart`
- [x] `lib/features/auth/data/models/login_request_model.dart`
- [x] `lib/features/auth/data/models/register_request_model.dart`
- [x] `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- [x] `lib/core/storage/auth_storage.dart`

### Catálogo
- [x] `lib/features/catalog/data/models/pizza_model.dart` (actualizado)
- [x] `lib/features/catalog/data/datasources/pizza_api_datasource.dart`

### Carrito
- [x] `lib/features/cart/data/models/carrito_model.dart`
- [x] `lib/features/cart/data/models/carrito_item_model.dart`
- [x] `lib/features/cart/data/models/agregar_item_request_model.dart`
- [x] `lib/features/cart/data/datasources/cart_remote_datasource.dart`

### Pedidos
- [x] `lib/features/orders/data/models/pedido_model.dart`
- [x] `lib/features/orders/data/models/pedido_detalle_model.dart`
- [x] `lib/features/orders/data/models/crear_pedido_request_model.dart`
- [x] `lib/features/orders/data/datasources/orders_remote_datasource.dart`

### Admin
- [x] `lib/features/admin/data/models/crear_pizza_request_model.dart`
- [x] `lib/features/admin/data/datasources/admin_pizzas_datasource.dart`
- [x] `lib/features/admin/data/datasources/admin_orders_datasource.dart`

### Servicios
- [x] `lib/core/services/websocket_service.dart`
- [x] `lib/core/network/dio_client.dart` (actualizado)
- [x] `lib/core/constants/api_constants.dart`

### Documentación
- [x] `API_INTEGRATION.md`
- [x] `SETUP_INSTRUCTIONS.md`
- [x] `CAMBIOS_BACKEND.md`
- [x] `lib/core/examples/api_usage_examples.dart`

### Scripts
- [x] `scripts/setup.bat`
- [x] `scripts/generate.bat`

### Configuración
- [x] `.env.example` (actualizado)
- [x] `pubspec.yaml` (actualizado con stomp_dart_client)
- [x] `README.md` (actualizado)

## 🔧 Pasos de Configuración

### 1. Instalación
- [ ] Ejecutar `flutter pub get`
- [ ] Verificar que todas las dependencias se instalaron correctamente

### 2. Generación de Código
- [ ] Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Verificar que se generaron todos los archivos `.freezed.dart` y `.g.dart`
- [ ] No hay errores de compilación

### 3. Configuración de Entorno
- [ ] Copiar `.env.example` a `.env`
- [ ] Configurar `API_BASE_URL` según tu entorno
- [ ] Configurar `WS_URL` según tu entorno
- [ ] Para Android Emulator, usar `10.0.2.2:8080`

### 4. Backend
- [ ] Backend Spring Boot está corriendo
- [ ] Backend accesible en `http://localhost:8080`
- [ ] Endpoints de API responden correctamente
- [ ] WebSocket está habilitado

### 5. Pruebas Básicas
- [ ] La app compila sin errores
- [ ] Puedes hacer login con credenciales admin
- [ ] Puedes obtener la lista de pizzas
- [ ] El token se guarda correctamente

## 🧪 Tests de Endpoints

### Autenticación
- [ ] `POST /api/auth/login` - Login funciona
- [ ] `POST /api/auth/register` - Registro funciona
- [ ] Token se guarda en SharedPreferences
- [ ] Token se incluye automáticamente en peticiones

### Catálogo
- [ ] `GET /api/pizzas` - Lista de pizzas
- [ ] `GET /api/pizzas/{id}` - Detalle de pizza
- [ ] Ingredientes se cargan correctamente

### Carrito (requiere autenticación)
- [ ] `GET /api/usuario/carrito` - Obtener carrito
- [ ] `POST /api/usuario/carrito/agregar` - Agregar item
- [ ] `DELETE /api/usuario/carrito/limpiar` - Limpiar carrito

### Pedidos (requiere autenticación)
- [ ] `POST /api/usuario/pedidos` - Crear pedido
- [ ] `GET /api/usuario/pedidos` - Historial
- [ ] `GET /api/usuario/pedidos/{id}` - Detalle

### Admin (requiere rol ADMIN)
- [ ] `GET /api/admin/pizzas` - Todas las pizzas
- [ ] `POST /api/admin/pizzas` - Crear pizza
- [ ] `PUT /api/admin/pizzas/{id}` - Actualizar pizza
- [ ] `DELETE /api/admin/pizzas/{id}` - Eliminar pizza
- [ ] `GET /api/admin/pedidos` - Todos los pedidos
- [ ] `PUT /api/admin/pedidos/{id}/estado` - Actualizar estado
- [ ] `PUT /api/admin/pedidos/{id}/repartidor` - Asignar repartidor

### WebSocket
- [ ] Conexión a WebSocket exitosa
- [ ] Suscripción a `/topic/pedidos/{id}` funciona
- [ ] Suscripción a `/topic/pedidos/nuevos` funciona (admin)
- [ ] Recibe actualizaciones en tiempo real

## 🚀 Próximos Pasos

### Capa de Dominio
- [ ] Crear entidades de dominio para cada feature
- [ ] Crear interfaces de repositorios
- [ ] Implementar casos de uso

### Repositorios
- [ ] Implementar `AuthRepositoryImpl`
- [ ] Actualizar `PizzaRepositoryImpl`
- [ ] Implementar `CartRepositoryImpl`
- [ ] Implementar `OrderRepositoryImpl`
- [ ] Implementar `AdminRepositoryImpl`

### Providers (Riverpod)
- [ ] Provider de autenticación
- [ ] Provider de usuario actual
- [ ] Actualizar providers de catálogo
- [ ] Provider de carrito
- [ ] Provider de pedidos
- [ ] Provider de WebSocket

### UI - Autenticación
- [ ] Pantalla de Login
- [ ] Pantalla de Registro
- [ ] Pantalla de Splash con verificación de token
- [ ] Manejo de sesión expirada

### UI - Catálogo
- [ ] Actualizar CatalogPage para nueva API
- [ ] Actualizar PizzaCard con nuevos campos
- [ ] Pantalla de detalle de pizza
- [ ] Selector de ingredientes personalizados

### UI - Carrito
- [ ] Pantalla de carrito
- [ ] Item de carrito con ingredientes
- [ ] Botón de limpiar carrito
- [ ] Navegación a checkout

### UI - Pedidos
- [ ] Pantalla de checkout
- [ ] Formulario de dirección y contacto
- [ ] Pantalla de confirmación
- [ ] Pantalla de historial de pedidos
- [ ] Pantalla de detalle de pedido
- [ ] Tracking en tiempo real con WebSocket

### UI - Admin
- [ ] Panel de administración
- [ ] Lista de pizzas (CRUD)
- [ ] Formulario de crear/editar pizza
- [ ] Lista de pedidos
- [ ] Actualizar estado de pedido
- [ ] Asignar repartidor

### Features Adicionales
- [ ] Manejo de errores en UI
- [ ] Loading states
- [ ] Pull to refresh
- [ ] Caché de datos
- [ ] Modo offline
- [ ] Notificaciones push
- [ ] Refresh token automático

### Testing
- [ ] Tests unitarios de datasources
- [ ] Tests unitarios de repositorios
- [ ] Tests unitarios de casos de uso
- [ ] Tests de widgets
- [ ] Tests de integración

## 📝 Notas

### Cambios Breaking
- El modelo `PizzaModel` cambió completamente
- Necesitas actualizar cualquier código que use el modelo antiguo
- Los IDs ahora son `int` en lugar de `String`

### Consideraciones
- El interceptor de DioClient agrega automáticamente el token
- Los errores 401 limpian automáticamente el storage
- WebSocket requiere backend corriendo
- Android Emulator necesita `10.0.2.2` en lugar de `localhost`

### Credenciales
- Admin: `admin@pizzasreyna.com` / `admin123`

## ✅ Estado Actual

**Completado:**
- ✅ Todos los modelos creados
- ✅ Todos los datasources implementados
- ✅ Servicio de WebSocket
- ✅ Interceptor de autenticación
- ✅ Storage de tokens
- ✅ Constantes de API
- ✅ Documentación completa
- ✅ Scripts de ayuda

**Pendiente:**
- ⏳ Generar código Freezed (ejecutar build_runner)
- ⏳ Implementar capa de dominio
- ⏳ Implementar repositorios
- ⏳ Crear providers
- ⏳ Implementar UI

## 🎯 Siguiente Acción Inmediata

1. Ejecutar: `flutter pub run build_runner build --delete-conflicting-outputs`
2. Verificar que no hay errores de compilación
3. Configurar archivo `.env`
4. Probar login con credenciales admin
