import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/catalog/presentation/pages/catalog_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Si no existe .env, continuar con valores por defecto
    debugPrint('No se pudo cargar .env: $e');
  }

  // Inicializar dependencias con datos mock
  // Cambiar a false cuando la API esté disponible
  await initDependencies(useMockData: true);

  runApp(
    const ProviderScope(
      child: PizzasReynaApp(),
    ),
  );
}

class PizzasReynaApp extends StatelessWidget {
  const PizzasReynaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzas Reyna',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CatalogPage(),
    );
  }
}
