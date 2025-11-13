import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart';

/// Cliente HTTP configurado con Dio
class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  DioClient() {
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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
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
