import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/pizza_model.dart';

abstract class PizzaApiDataSource {
  Future<List<PizzaModel>> getPizzas();
  Future<PizzaModel> getPizzaById(int id);
}

class PizzaApiDataSourceImpl implements PizzaApiDataSource {
  final DioClient dioClient;

  PizzaApiDataSourceImpl({required this.dioClient});

  @override
  Future<List<PizzaModel>> getPizzas() async {
    try {
      final response = await dioClient.dio.get('/api/pizzas');
      final List<dynamic> data = response.data;
      return data.map((json) => PizzaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener pizzas: ${e.message}');
    }
  }

  @override
  Future<PizzaModel> getPizzaById(int id) async {
    try {
      final response = await dioClient.dio.get('/api/pizzas/$id');
      return PizzaModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Pizza no encontrada');
      }
      throw Exception('Error al obtener pizza: ${e.message}');
    }
  }
}
