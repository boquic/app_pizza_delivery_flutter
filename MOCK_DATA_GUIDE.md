# Guía de Datos Mock - Pizzas Reyna

## 🎭 Modo Mock vs API Real

La aplicación está configurada para funcionar con **datos mock** por defecto, lo que te permite desarrollar y probar la UI sin necesidad de tener una API backend funcionando.

## 🔄 Cambiar entre Mock y API Real

### Usar Datos Mock (Por Defecto)

En `lib/main.dart`:

```dart
await initDependencies(useMockData: true);  // ✅ Datos mock
```

**Ventajas:**
- ✅ No requiere backend
- ✅ Respuestas instantáneas
- ✅ Datos consistentes para testing
- ✅ Funciona offline
- ✅ Ideal para desarrollo de UI

### Usar API Real

En `lib/main.dart`:

```dart
await initDependencies(useMockData: false);  // 🌐 API real
```

**Requisitos:**
- ⚠️ Backend funcionando
- ⚠️ URL correcta en `.env`
- ⚠️ Conexión a internet

## 📊 Datos Mock Disponibles

### Categorías (4)
- 🍕 Clásicas (8 pizzas)
- ⭐ Especiales (6 pizzas)
- 🥗 Vegetarianas (4 pizzas)
- 👑 Premium (5 pizzas)

### Pizzas (20 en total)

#### Clásicas
1. Margarita - $12.99
2. Pepperoni - $14.99
3. Hawaiana - $13.99
4. Cuatro Quesos - $15.99
5. Napolitana - $13.49
6. Calzone Especial - $13.99

#### Especiales
7. BBQ Chicken - $16.99
8. Mexicana - $15.49
9. Mediterránea - $14.99
10. Carbonara - $15.99
11. Diavola - $14.99
12. Carne Lovers - $17.99

#### Vegetarianas
13. Vegetariana Supreme - $13.99
14. Caprese - $14.49
15. Funghi - $13.49
16. Pesto Genovese - $16.49

#### Premium
17. Trufa Negra - $24.99
18. Langosta y Camarones - $28.99
19. Prosciutto e Rúcula - $22.99
20. Salmón Ahumado - $21.99

## 🎨 Características del Mock

### Simulación Realista
- ⏱️ Delay de red simulado (500ms)
- 📄 Paginación funcional
- 🔍 Filtrado por categoría
- ⭐ Ratings y reseñas
- 🏷️ Tags y etiquetas
- 📸 URLs de imágenes reales (Unsplash)

### Funcionalidades Implementadas
- ✅ Obtener lista de pizzas con paginación
- ✅ Filtrar por categoría
- ✅ Obtener categorías
- ✅ Obtener pizza por ID
- ✅ Manejo de errores (pizza no encontrada)

## 🔧 Personalizar Datos Mock

### Agregar Nuevas Pizzas

Edita `lib/features/catalog/data/datasources/pizza_mock_datasource.dart`:

```dart
const PizzaModel(
  id: '21',
  name: 'Tu Pizza',
  description: 'Descripción de tu pizza',
  basePrice: 15.99,
  imageUrl: 'https://images.unsplash.com/photo-xxxxx',
  rating: 4.5,
  reviewCount: 100,
  category: 'clasicas',
  availableSizes: ['mediana', 'grande'],
  isAvailable: true,
  tags: ['nueva', 'popular'],
),
```

### Agregar Nuevas Categorías

```dart
const PizzaCategoryModel(
  id: 'nueva_categoria',
  name: 'Nueva Categoría',
  icon: '🎉',
  pizzaCount: 3,
),
```

### Cambiar Delay de Red

```dart
Future<void> _simulateNetworkDelay() async {
  await Future.delayed(const Duration(milliseconds: 500)); // Cambiar aquí
}
```

## 🌐 Configurar API Real

### 1. Configurar .env

```env
API_BASE_URL=https://tu-api.com/api/v1
WS_URL=wss://tu-api.com/ws
GOOGLE_MAPS_API_KEY=tu_api_key
ENVIRONMENT=dev
```

### 2. Verificar Endpoints

La API debe implementar estos endpoints:

```
GET /pizzas?page=1&limit=20&category=clasicas
GET /categories
GET /pizzas/:id
```

### 3. Formato de Respuesta Esperado

#### GET /pizzas
```json
{
  "data": [
    {
      "id": "1",
      "name": "Margarita",
      "description": "...",
      "base_price": 12.99,
      "image_url": "...",
      "rating": 4.5,
      "review_count": 120,
      "category": "clasicas",
      "available_sizes": ["pequeña", "mediana", "grande"],
      "is_available": true,
      "tags": ["vegetariana"]
    }
  ]
}
```

#### GET /categories
```json
{
  "data": [
    {
      "id": "clasicas",
      "name": "Clásicas",
      "icon": "🍕",
      "pizza_count": 8
    }
  ]
}
```

## 🧪 Testing con Mock

Los datos mock son ideales para:

- ✅ Desarrollo de UI
- ✅ Tests unitarios
- ✅ Tests de widgets
- ✅ Demos y presentaciones
- ✅ Desarrollo offline

## 🚀 Migración a API Real

### Checklist

1. ✅ Backend implementado y funcionando
2. ✅ Endpoints probados con Postman/Insomnia
3. ✅ Variables de entorno configuradas
4. ✅ Cambiar `useMockData: false` en main.dart
5. ✅ Probar todas las funcionalidades
6. ✅ Manejar errores de red apropiadamente

### Problemas Comunes

#### Error de Conexión
```
⛔ ERROR[null] => PATH: /categories
```

**Solución:**
- Verificar que el backend esté corriendo
- Verificar la URL en `.env`
- Verificar conectividad de red
- Volver a modo mock temporalmente

#### Timeout
```
TimeoutException: Tiempo de espera agotado
```

**Solución:**
- Aumentar timeout en `dio_client.dart`
- Verificar velocidad de red
- Optimizar backend

#### Formato de Datos Incorrecto
```
FormatException: Unexpected character
```

**Solución:**
- Verificar que la API retorne el formato esperado
- Revisar los modelos en `data/models/`
- Agregar logs para debug

## 💡 Tips

### Desarrollo Híbrido

Puedes usar mock para algunas features y API real para otras:

```dart
// En injection_container.dart
if (useMockData) {
  getIt.registerLazySingleton<PizzaRepository>(
    () => PizzaRepositoryMockImpl(getIt<PizzaMockDataSource>()),
  );
} else {
  getIt.registerLazySingleton<PizzaRepository>(
    () => PizzaRepositoryImpl(getIt<PizzaRemoteDataSource>()),
  );
}
```

### Debug Mode

Agregar logs para saber qué modo estás usando:

```dart
void main() async {
  const useMockData = true;
  
  debugPrint('🎭 Modo: ${useMockData ? "MOCK" : "API REAL"}');
  
  await initDependencies(useMockData: useMockData);
  // ...
}
```

### Feature Flags

Para producción, considera usar feature flags:

```dart
final useMockData = FlavorConfig.instance.isDev;
```

## 📚 Recursos

- [Unsplash](https://unsplash.com) - Imágenes de pizzas
- [Mockaroo](https://mockaroo.com) - Generar datos mock
- [JSON Generator](https://json-generator.com) - Generar JSON mock

## ❓ FAQ

**P: ¿Puedo usar mock en producción?**
R: No, solo para desarrollo y testing.

**P: ¿Los datos mock se guardan?**
R: No, se regeneran en cada ejecución.

**P: ¿Puedo modificar datos mock en runtime?**
R: Sí, pero se perderán al reiniciar la app.

**P: ¿Cómo agrego más pizzas?**
R: Edita `_mockPizzas` en `pizza_mock_datasource.dart`.

**P: ¿Las imágenes funcionan offline?**
R: No, las URLs de Unsplash requieren internet. Puedes usar assets locales.

## 🎯 Próximos Pasos

1. Desarrollar UI con datos mock ✅
2. Implementar backend
3. Probar con API real
4. Migrar a producción
5. Remover código mock (opcional)

---

**Nota:** El modo mock está activo por defecto. Cambia a API real cuando tu backend esté listo.
