import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

/// Configuración de variables de entorno
class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  /// Dev helper: On Android emulators, `localhost` should be `10.0.2.2`.
  /// This normalizes the base URL so requests succeed across platforms.
  static String get apiBaseUrlNormalized {
    final base = apiBaseUrl;
    if (base.isEmpty) return base;
    // Web keeps as-is; iOS/macOS/windows keep localhost fine.
    if (kIsWeb) return base;
    // Best effort detection for Android
    try {
      if (Platform.isAndroid && base.contains('localhost')) {
        return base.replaceFirst('localhost', '10.0.2.2');
      }
    } catch (_) {
      // Platform may not be available in some contexts; fallback to base
    }
    return base;
  }
  static String get wsUrl => dotenv.env['WS_URL'] ?? '';
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'dev';

  static bool get isDev => environment == 'dev';
  static bool get isStaging => environment == 'staging';
  static bool get isProd => environment == 'prod';
}
