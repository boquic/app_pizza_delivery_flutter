import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 400) {
      return Exception('Datos inválidos');
    } else if (e.response?.statusCode == 401) {
      return Exception('Credenciales incorrectas');
    } else if (e.response?.statusCode == 409) {
      return Exception('El email ya está registrado');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
