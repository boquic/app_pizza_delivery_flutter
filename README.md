# Pizzas Reyna - Flutter App

Aplicación móvil de e-commerce y delivery para Pizzas Reyna, desarrollada con Flutter siguiendo Clean Architecture y Material Design 3.

## 🚀 Características

- **Catálogo de Pizzas**: Grid con paginación infinita y filtrado por categorías
- **Constructor de Pizza Personalizada**: Wizard de 4 pasos con preview visual
- **Carrito de Compras**: Gestión completa con dirección y métodos de pago
- **Seguimiento en Tiempo Real**: WebSocket con mapa y timeline animado
- **Perfil de Usuario**: Historial, direcciones, favoritos y chat de soporte

## 🛠️ Stack Tecnológico

- **Flutter**: 3.19+
- **Dart**: 3.2+
- **State Management**: Riverpod (flutter_riverpod + riverpod_annotation)
- **Networking**: Dio + WebSocket
- **Navigation**: go_router
- **Maps**: flutter_map
- **Local Storage**: shared_preferences
- **Code Generation**: freezed, json_serializable

## 📁 Arquitectura

El proyecto sigue **Clean Architecture** con la siguiente estructura:

```
lib/
├── core/
│   ├── config/          # Configuración de la app
│   ├── constants/       # Constantes (colores, strings)
│   ├── network/         # Cliente HTTP y excepciones
│   └── theme/           # Tema Material Design 3
├── features/
│   ├── catalog/         # Catálogo de pizzas
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   ├── builder/         # Constructor de pizzas
│   ├── cart/            # Carrito de compras
│   ├── tracking/        # Seguimiento de pedidos
│   └── profile/         # Perfil de usuario
└── injection_container.dart
```

## 🎨 Diseño

### Paleta de Colores

- **Primario**: #F28C0F
- **Secundario Claro**: #F2AA6B
- **Acento**: #BF3415
- **Error**: #F20505

### Tipografía

- **Títulos**: Poppins
- **Body**: Roboto

## 🔧 Setup e Instalación

### Prerrequisitos

- Flutter SDK 3.19 o superior
- Dart SDK 3.2 o superior
- Android Studio / VS Code con extensiones de Flutter
- Backend Spring Boot corriendo en puerto 8080

### Instalación Rápida (Windows)

Ejecuta el script de setup automático:

```bash
scripts\setup.bat
```

Este script:
1. Instala las dependencias
2. Genera el código Freezed
3. Crea el archivo `.env` si no existe
4. Verifica la configuración

### Instalación Manual

1. **Clonar el repositorio**

```bash
git clone https://github.com/tu-usuario/pizzas-reyna-flutter.git
cd pizzas-reyna-flutter
```

2. **Instalar dependencias**

```bash
flutter pub get
```

3. **Configurar variables de entorno**

Copia el archivo `.env.example` a `.env`:

```bash
# Windows (CMD)
copy .env.example .env

# Windows (PowerShell)
Copy-Item .env.example .env
```

Edita `.env` según tu entorno:

```env
# Desarrollo Local (iOS Simulator)
API_BASE_URL=http://localhost:8080
WS_URL=ws://localhost:8080/ws

# Desarrollo Local (Android Emulator)
# API_BASE_URL=http://10.0.2.2:8080
# WS_URL=ws://10.0.2.2:8080/ws

# Producción
# API_BASE_URL=https://api.pizzasreyna.com
# WS_URL=wss://api.pizzasreyna.com/ws

GOOGLE_MAPS_API_KEY=tu_api_key_aqui
ENVIRONMENT=dev
```

4. **Generar código Freezed**

```bash
flutter pub run build_runner build --delete-conflicting-outputs

# O usa el script de Windows
scripts\generate.bat
```

5. **Verificar que el backend esté corriendo**

Asegúrate de que tu backend Spring Boot esté corriendo en `http://localhost:8080`

6. **Ejecutar la aplicación**

```bash
flutter run
```

### 📚 Documentación Adicional

- **[CAMBIOS_BACKEND.md](CAMBIOS_BACKEND.md)** - Resumen completo de cambios realizados
- **[API_INTEGRATION.md](API_INTEGRATION.md)** - Documentación de integración con API
- **[SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)** - Instrucciones detalladas paso a paso

### 🔐 Credenciales de Prueba

**Usuario Admin:**
- Email: `admin@pizzasreyna.com`
- Password: `admin123`

## 🧪 Testing

### Ejecutar todos los tests

```bash
flutter test
```

### Ejecutar tests con cobertura

```bash
flutter test --coverage
```

### Ver reporte de cobertura

```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📦 Build

### Android

```bash
# Debug
flutter build apk --flavor dev

# Release
flutter build apk --flavor prod --release
```

### iOS

```bash
# Debug
flutter build ios --flavor dev

# Release
flutter build ios --flavor prod --release
```

## 🔍 Análisis de Código

```bash
# Análisis estático
flutter analyze

# Formateo de código
dart format lib/

# Verificar formato
dart format --set-exit-if-changed lib/
```

## 📝 Convenciones de Código

- Seguir las guías de estilo de Dart y Flutter
- Usar `flutter_lints` estricto
- Documentar clases y métodos públicos con Dartdoc
- Nombres de archivos en snake_case
- Nombres de clases en PascalCase
- Nombres de variables y funciones en camelCase

## 🚦 CI/CD

El proyecto incluye GitHub Actions para:

- Análisis estático (`flutter analyze`)
- Tests unitarios y de widgets (`flutter test`)
- Build de APK (`flutter build apk`)

## 📱 Responsive Design

La aplicación se adapta a diferentes tamaños de pantalla:

- **Mobile** (< 800px): Bottom Navigation Bar
- **Tablet** (800px - 1200px): Navigation Rail
- **Web** (> 1200px): Drawer Navigation

## 🔐 Seguridad

- No commitear archivos `.env` con credenciales reales
- Usar variables de entorno para API keys
- Implementar autenticación JWT
- Validar inputs del usuario
- Sanitizar datos antes de enviar a la API

## 📄 Licencia

Este proyecto es privado y confidencial.

## 👥 Equipo

Desarrollado por el equipo de Pizzas Reyna.

## 📞 Soporte

Para soporte técnico, contactar a: dev@pizzasreyna.com
