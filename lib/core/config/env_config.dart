import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración de variables de entorno
class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get wsUrl => dotenv.env['WS_URL'] ?? '';
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';

  static bool get isDev => environment == 'dev';
  static bool get isStaging => environment == 'staging';
  static bool get isProd => environment == 'prod';
}
