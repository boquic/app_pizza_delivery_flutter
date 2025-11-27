import 'package:dio/dio.dart';
import '../../../../core/network/network_exception.dart';
import '../models/pizza_model.dart';
import '../models/pizza_category_model.dart';

/// Fuente de datos remota para pizzas
abstract class PizzaRemoteDataSource {
  Future<List<PizzaModel>> getPizzas({
    required int page,
    required int limit,
    String? category,
  });
  
  Future<List<PizzaCategoryModel>> getCategories();
  
  Future<PizzaModel> getPizzaById(String id);
}

class PizzaRemoteDataSourceImpl implements PizzaRemoteDataSource {
  final Dio _dio;

  PizzaRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PizzaModel>> getPizzas({
    required int page,
    required int limit,
    String? category,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
      };

      final response = await _dio.get(
        '/pizzas',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => PizzaModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener pizzas');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw NoInternetException();
      } else if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException('Pizzas no encontradas');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Error del servidor',
        );
      }
    }
  }

  @override
  Future<List<PizzaCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => PizzaCategoryModel.fromJson(json)).toList();
      } else {
        throw ServerException('Error al obtener categorías');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw NoInternetException();
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Error del servidor',
        );
      }
    }
  }

  @override
  Future<PizzaModel> getPizzaById(String id) async {
    try {
      final response = await _dio.get('/pizzas/$id');

      if (response.statusCode == 200) {
        return PizzaModel.fromJson(response.data['data']);
      } else {
        throw ServerException('Error al obtener pizza');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw NoInternetException();
      } else if (e.response?.statusCode == 404) {
        throw NotFoundException('Pizza no encontrada');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Error del servidor',
        );
      }
    }
  }
}
