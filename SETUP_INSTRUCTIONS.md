# 🚀 Instrucciones de Configuración

## Pasos para configurar el proyecto después de los cambios

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Generar código Freezed y JSON Serialization

Todos los modelos creados usan `freezed` y `json_serializable`, por lo que necesitas generar el código:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Este comando generará los archivos:
- `*.freezed.dart` - Código generado por Freezed
- `*.g.dart` - Código generado por json_serializable

**Nota**: Este proceso puede tomar varios minutos la primera vez.

### 3. Configurar variables de entorno

Copia el archivo de ejemplo y configúralo según tu entorno:

```bash
# Windows (CMD)
copy .env.example .env

# Windows (PowerShell)
Copy-Item .env.example .env
```

Edita el archivo `.env` con tus configuraciones:

```env
# Para desarrollo local en iOS Simulator
API_BASE_URL=http://localhost:8080
WS_URL=ws://localhost:8080/ws

# Para desarrollo local en Android Emulator
# API_BASE_URL=http://10.0.2.2:8080
# WS_URL=ws://10.0.2.2:8080/ws
```

### 4. Verificar que el backend esté corriendo

Asegúrate de que tu backend Spring Boot esté corriendo en el puerto 8080:

```bash
# El backend debe estar accesible en:
http://localhost:8080
```

### 5. Ejecutar la aplicación

```bash
flutter run
```

## 📋 Checklist de Verificación

- [ ] ✅ Dependencias instaladas (`flutter pub get`)
- [ ] ✅ Código generado (`build_runner`)
- [ ] ✅ Archivo `.env` configurado
- [ ] ✅ Backend corriendo en puerto 8080
- [ ] ✅ Sin errores de compilación

## 🔧 Comandos Útiles

### Regenerar código cuando cambies modelos

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Modo watch (regenera automáticamente)

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Limpiar y regenerar todo

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🐛 Solución de Problemas

### Error: "No se encuentra el archivo .freezed.dart"

**Solución**: Ejecuta el build_runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "Conflicting outputs"

**Solución**: Usa el flag `--delete-conflicting-outputs`:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error de conexión en Android Emulator

**Problema**: `localhost` no funciona en Android Emulator

**Solución**: Usa `10.0.2.2` en lugar de `localhost`:
```env
API_BASE_URL=http://10.0.2.2:8080
```

### Error: "DioException: Connection refused"

**Problema**: El backend no está corriendo o no es accesible

**Solución**:
1. Verifica que el backend esté corriendo
2. Verifica la URL en el archivo `.env`
3. En Android Emulator, usa `10.0.2.2` en lugar de `localhost`

### Error: "401 Unauthorized"

**Problema**: Token expirado o no válido

**Solución**: Vuelve a hacer login. El interceptor limpiará automáticamente el token.

## 📚 Archivos Importantes

### Modelos Core
- `lib/core/models/ingrediente_model.dart`
- `lib/core/models/usuario_model.dart`

### Autenticación
- `lib/features/auth/data/models/` - Modelos de auth
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/core/storage/auth_storage.dart`

### Catálogo
- `lib/features/catalog/data/models/pizza_model.dart` (actualizado)
- `lib/features/catalog/data/datasources/pizza_api_datasource.dart`

### Carrito
- `lib/features/cart/data/models/` - Modelos de carrito
- `lib/features/cart/data/datasources/cart_remote_datasource.dart`

### Pedidos
- `lib/features/orders/data/models/` - Modelos de pedidos
- `lib/features/orders/data/datasources/orders_remote_datasource.dart`

### Admin
- `lib/features/admin/data/datasources/` - Datasources de admin
- `lib/features/admin/data/models/` - Modelos de admin

### Servicios
- `lib/core/services/websocket_service.dart` - WebSocket para tracking
- `lib/core/network/dio_client.dart` - Cliente HTTP con interceptores
- `lib/core/storage/auth_storage.dart` - Almacenamiento de tokens

### Constantes
- `lib/core/constants/api_constants.dart` - Estados, tamaños, roles

### Ejemplos
- `lib/core/examples/api_usage_examples.dart` - Ejemplos de uso

## 🎯 Próximos Pasos

1. **Implementar Repositorios**: Crear la capa de repositorios siguiendo Clean Architecture
2. **Casos de Uso**: Implementar use cases para cada feature
3. **Providers**: Crear providers con Riverpod para gestión de estado
4. **UI**: Implementar las pantallas de login, registro, catálogo, carrito, pedidos
5. **Testing**: Agregar tests unitarios y de integración

## 📖 Documentación Adicional

- [API_INTEGRATION.md](./API_INTEGRATION.md) - Documentación completa de la API
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Arquitectura del proyecto
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Guía de contribución

## 🔐 Credenciales de Prueba

### Usuario Admin
- Email: `admin@pizzasreyna.com`
- Password: `admin123`

Usa estas credenciales para probar los endpoints de administrador.
