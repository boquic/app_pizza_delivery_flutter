import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart';
import '../storage/auth_storage.dart';

/// Cliente HTTP configurado con Dio
class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();
  final AuthStorage? authStorage;

  DioClient({this.authStorage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor de autenticación
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Agregar token automáticamente si existe
          if (authStorage != null) {
            final token = authStorage!.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          
          // Si el token expiró (401), limpiar storage
          if (error.response?.statusCode == 401 && authStorage != null) {
            authStorage!.clearAll();
            clearAuthToken();
          }
          
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Configura el token de autenticación
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Elimina el token de autenticación
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
