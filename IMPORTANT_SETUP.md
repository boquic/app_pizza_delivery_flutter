# ⚠️ CONFIGURACIÓN IMPORTANTE - LEER PRIMERO

## 🎭 Modo Mock Activado

La aplicación está configurada para usar **DATOS MOCK** por defecto. Esto significa que **NO NECESITAS UN BACKEND** para que funcione.

## ✅ Estado Actual

```dart
// En lib/main.dart
const useMockData = true;  // ✅ MOCK ACTIVADO
```

## 🚫 NO Modificar Estos Archivos (a menos que sepas lo que haces)

### 1. `lib/injection_container.dart`
Este archivo gestiona las dependencias y el switch entre mock y API real.

**Versión Correcta:**
```dart
Future<void> initDependencies({bool useMockData = true}) async {
  // ...
  if (useMockData) {
    // Usar datos mock
  } else {
    // Usar API real
  }
}
```

### 2. `lib/main.dart`
Este archivo inicializa la app con datos mock.

**Versión Correcta:**
```dart
void main() async {
  // ...
  const useMockData = true;  // ✅ MOCK
  await initDependencies(useMockData: useMockData);
  // ...
}
```

## 🔧 Si el IDE Sobrescribe los Archivos

Si ves errores como:
```
Error: Exception: Error de conexion: status code of 500
```

Significa que el IDE modificó los archivos y la app está intentando conectarse a una API que no existe.

### Solución Rápida:

1. **Restaurar `lib/injection_container.dart`:**
   - Debe tener el parámetro `useMockData`
   - Debe registrar `PizzaMockDataSource` cuando `useMockData = true`

2. **Restaurar `lib/main.dart`:**
   - Debe tener `const useMockData = true;`
   - Debe llamar `initDependencies(useMockData: useMockData)`
   - Debe usar `CatalogPage()` como home, NO un router

3. **Ejecutar:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📱 Qué Deberías Ver

Cuando la app funciona correctamente:

1. ✅ Pantalla de catálogo con pizzas
2. ✅ 4 categorías (Clásicas, Especiales, Vegetarianas, Premium)
3. ✅ 20 pizzas con imágenes
4. ✅ Scroll infinito funcional
5. ✅ Filtros por categoría funcionando
6. ✅ NO errores de conexión

## 🐛 Errores Comunes

### Error: "status code of 500"
**Causa:** La app está intentando conectarse a la API real
**Solución:** Verificar que `useMockData = true` en main.dart

### Error: "Undefined class 'PizzaMockDataSource'"
**Causa:** El archivo fue eliminado o no se importó
**Solución:** Verificar que existe `lib/features/catalog/data/datasources/pizza_mock_datasource.dart`

### Error: "routerProvider not found"
**Causa:** El IDE agregó código de router que no existe
**Solución:** Usar `home: const CatalogPage()` en lugar de `routerConfig`

## 🎯 Archivos Críticos

Estos archivos DEBEN existir para que el modo mock funcione:

```
lib/
├── main.dart                                          ✅ Con useMockData = true
├── injection_container.dart                           ✅ Con parámetro useMockData
└── features/catalog/
    ├── data/
    │   ├── datasources/
    │   │   ├── pizza_mock_datasource.dart            ✅ Datos mock
    │   │   └── pizza_remote_datasource.dart          ⚠️ Para API real
    │   └── repositories/
    │       ├── pizza_repository_mock_impl.dart       ✅ Implementación mock
    │       └── pizza_repository_impl.dart            ⚠️ Para API real
    └── ...
```

## 🔄 Cambiar a API Real (Cuando esté lista)

1. Asegúrate de que tu backend esté funcionando
2. Configura `.env` con la URL correcta
3. En `lib/main.dart` cambia:
   ```dart
   const useMockData = false;  // 🌐 API REAL
   ```
4. Reinicia la app

## 💡 Tips

### Ver Modo Actual
Busca en los logs al iniciar la app:
```
🎭 Modo: MOCK DATA
```

### Verificar Imports
En `injection_container.dart` debe tener:
```dart
import 'features/catalog/data/datasources/pizza_mock_datasource.dart';
import 'features/catalog/data/repositories/pizza_repository_mock_impl.dart';
```

### Hot Reload
Después de cambiar `useMockData`, necesitas **Hot Restart** (no Hot Reload):
- VS Code: `Ctrl + Shift + F5`
- Android Studio: Click en el botón de restart

## 📞 Soporte

Si sigues teniendo problemas:

1. Ejecuta:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run
   ```

2. Verifica que estos archivos existan y tengan el contenido correcto:
   - `lib/main.dart`
   - `lib/injection_container.dart`
   - `lib/features/catalog/data/datasources/pizza_mock_datasource.dart`

3. Lee `MOCK_DATA_GUIDE.md` para más detalles

## ⚡ Comando Rápido de Verificación

```bash
# Verificar que los archivos mock existen
ls lib/features/catalog/data/datasources/pizza_mock_datasource.dart
ls lib/features/catalog/data/repositories/pizza_repository_mock_impl.dart

# Si no existen, hay un problema
```

---

**Recuerda:** El modo mock está diseñado para que puedas desarrollar la UI sin preocuparte por el backend. ¡Aprovéchalo! 🚀
