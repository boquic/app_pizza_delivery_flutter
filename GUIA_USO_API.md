# 🚀 Guía de Uso con API Real - Pizzas Reyna

## ✅ Configuración Actual

La aplicación está configurada para **consumir la API real** en:
- **URL**: `http://10.0.2.2:8080` (localhost del emulador Android)
- **Modo**: API Real (no mock)

## 📱 Funcionalidades Implementadas

### 1. Catálogo de Pizzas ✅
- **Endpoint**: `GET /api/pizzas`
- **Funcionalidad**: 
  - Lista todas las pizzas disponibles
  - Muestra imagen, nombre, descripción, precio y tamaño
  - Indica si está disponible o no
  - Pull to refresh para recargar

### 2. Detalle de Pizza ✅
- **Endpoint**: `GET /api/pizzas/:id`
- **Funcionalidad**:
  - Ver información completa de la pizza
  - Ver ingredientes con imágenes
  - Seleccionar cantidad
  - Calcular precio total
  - Botón "Agregar al carrito"

### 3. Autenticación ✅
- **Endpoints**: 
  - `POST /api/auth/login`
  - `POST /api/auth/register`
- **Funcionalidad**:
  - Login con email y contraseña
  - Registro de nuevos usuarios
  - Almacenamiento seguro del token JWT
  - Auto-login si hay token guardado

### 4. Carrito de Compras ✅
- **Endpoints**:
  - `GET /api/carrito` - Ver carrito
  - `POST /api/carrito/agregar` - Agregar item
  - `PUT /api/carrito/item/:id` - Actualizar cantidad
  - `DELETE /api/carrito/item/:id` - Eliminar item
- **Funcionalidad**:
  - Agregar pizzas al carrito (requiere autenticación)
  - Ver items del carrito
  - Modificar cantidades
  - Eliminar items
  - Ver total

## 🔐 Flujo de Autenticación

### Paso 1: Usuario No Autenticado
```
Usuario ve catálogo → Click en pizza → Ve detalle → 
Click "Agregar al carrito" → Aparece diálogo "Inicia sesión"
```

### Paso 2: Login
```
Click "Iniciar sesión" → Pantalla de login → 
Ingresa email y contraseña → Click "Ingresar" → 
Token guardado → Redirige al catálogo
```

### Paso 3: Usuario Autenticado
```
Usuario ve catálogo → Click en pizza → Ve detalle → 
Click "Agregar al carrito" → Item agregado → 
SnackBar "Pizza agregada" → Puede ver carrito
```

## 📋 Cómo Usar la Aplicación

### 1. Iniciar el Backend
Asegúrate de que tu backend esté corriendo en `http://localhost:8080`

```bash
# En tu proyecto backend
./mvnw spring-boot:run
```

### 2. Ejecutar la App
```bash
flutter run
```

### 3. Navegar por la App

#### Ver Catálogo
- La app inicia mostrando el catálogo de pizzas
- Scroll para ver todas las pizzas
- Pull down para refrescar

#### Ver Detalle
- Click en cualquier pizza
- Se abre la pantalla de detalle
- Puedes ver:
  - Imagen grande
  - Nombre y descripción
  - Tamaño
  - Ingredientes (si tiene)
  - Precio
  - Selector de cantidad

#### Agregar al Carrito (Sin Login)
1. Click en "Agregar al carrito"
2. Aparece diálogo: "Necesitas iniciar sesión"
3. Click en "Iniciar sesión"
4. Te lleva a la pantalla de login

#### Login
1. Ingresa tu email
2. Ingresa tu contraseña
3. Click en "Ingresar"
4. Si es correcto, vuelves al catálogo autenticado

#### Agregar al Carrito (Con Login)
1. Click en una pizza
2. Selecciona cantidad con +/-
3. Click en "Agregar al carrito"
4. Aparece SnackBar: "Pizza agregada al carrito"
5. Click en "Ver carrito" para ir al carrito

## 🔧 Configuración de la API

### Cambiar URL de la API

Edita el archivo `.env`:

```env
# Para emulador Android
API_BASE_URL=http://10.0.2.2:8080

# Para dispositivo físico (usa tu IP local)
API_BASE_URL=http://192.168.1.100:8080

# Para producción
API_BASE_URL=https://api.pizzasreyna.com
```

Después de cambiar, ejecuta:
```bash
flutter clean
flutter pub get
flutter run
```

## 📊 Estructura de Datos

### Pizza
```json
{
  "id": 1,
  "nombre": "Margarita",
  "descripcion": "Pizza clásica con tomate y mozzarella",
  "precioBase": 12.99,
  "tamanio": "MEDIANA",
  "disponible": true,
  "imagenUrl": "https://...",
  "esPersonalizada": false,
  "ingredientes": [
    {
      "id": 1,
      "nombre": "Mozzarella",
      "descripcion": "Queso mozzarella fresco",
      "precioAdicional": 0.0,
      "disponible": true,
      "imagenUrl": "https://..."
    }
  ]
}
```

### Request Agregar al Carrito
```json
{
  "pizzaId": 1,
  "cantidad": 2
}
```

### Response Carrito
```json
{
  "id": 1,
  "usuarioId": 1,
  "items": [
    {
      "id": 1,
      "pizza": { /* objeto pizza */ },
      "cantidad": 2,
      "precioUnitario": 12.99,
      "subtotal": 25.98
    }
  ],
  "total": 25.98
}
```

## 🐛 Troubleshooting

### Error: "Connection refused"
**Causa**: El backend no está corriendo o la URL es incorrecta
**Solución**: 
1. Verifica que el backend esté corriendo
2. Verifica la URL en `.env`
3. Si usas emulador, usa `10.0.2.2` en lugar de `localhost`

### Error: "401 Unauthorized"
**Causa**: Token expirado o inválido
**Solución**:
1. Cierra sesión
2. Vuelve a iniciar sesión
3. El token se renovará automáticamente

### Error: "No se pueden ver las pizzas"
**Causa**: El endpoint `/api/pizzas` no responde
**Solución**:
1. Verifica que el backend tenga datos de pizzas
2. Verifica los logs del backend
3. Prueba el endpoint con Postman

### Error: "No puedo agregar al carrito"
**Causa**: No estás autenticado o el token es inválido
**Solución**:
1. Verifica que iniciaste sesión
2. Verifica que el token se guardó correctamente
3. Revisa los logs de la app

## 📱 Pantallas Disponibles

### ✅ Implementadas
1. **Catálogo** - Lista de pizzas
2. **Detalle de Pizza** - Información completa
3. **Login** - Autenticación
4. **Registro** - Crear cuenta
5. **Carrito** - Ver y gestionar items
6. **Perfil** - Información del usuario

### 🚧 Por Implementar
1. **Checkout** - Finalizar pedido
2. **Tracking** - Seguimiento en tiempo real
3. **Historial** - Pedidos anteriores
4. **Favoritos** - Pizzas favoritas

## 🎯 Próximos Pasos

1. ✅ Consumir API real
2. ✅ Implementar autenticación
3. ✅ Agregar al carrito
4. ✅ Ver detalle de pizza
5. 🚧 Implementar checkout
6. 🚧 Implementar tracking con WebSocket
7. 🚧 Implementar historial de pedidos

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs de Flutter: `flutter logs`
2. Revisa los logs del backend
3. Verifica la configuración en `.env`
4. Asegúrate de que el backend esté corriendo

---

**¡La aplicación está lista para usar con la API real!** 🎉
