import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../catalog/data/models/pizza_model.dart';
import '../models/crear_pizza_request_model.dart';

abstract class AdminPizzasDataSource {
  Future<List<PizzaModel>> getAllPizzas();
  Future<PizzaModel> crearPizza(CrearPizzaRequestModel request);
  Future<PizzaModel> actualizarPizza(int id, CrearPizzaRequestModel request);
  Future<void> eliminarPizza(int id);
}

class AdminPizzasDataSourceImpl implements AdminPizzasDataSource {
  final DioClient dioClient;

  AdminPizzasDataSourceImpl({required this.dioClient});

  @override
  Future<List<PizzaModel>> getAllPizzas() async {
    try {
      final response = await dioClient.dio.get('/api/admin/pizzas');
      final List<dynamic> data = response.data;
      return data.map((json) => PizzaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PizzaModel> crearPizza(CrearPizzaRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/admin/pizzas',
        data: request.toJson(),
      );
      return PizzaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PizzaModel> actualizarPizza(
    int id,
    CrearPizzaRequestModel request,
  ) async {
    try {
      final response = await dioClient.dio.put(
        '/api/admin/pizzas/$id',
        data: request.toJson(),
      );
      return PizzaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> eliminarPizza(int id) async {
    try {
      await dioClient.dio.delete('/api/admin/pizzas/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('No autenticado');
    } else if (e.response?.statusCode == 403) {
      return Exception('No tiene permisos de administrador');
    } else if (e.response?.statusCode == 404) {
      return Exception('Pizza no encontrada');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
