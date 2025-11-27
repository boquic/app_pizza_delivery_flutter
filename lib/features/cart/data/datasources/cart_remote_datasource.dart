import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/carrito_model.dart';
import '../models/agregar_item_request_model.dart';

abstract class CartRemoteDataSource {
  Future<CarritoModel> getCarrito();
  Future<CarritoModel> agregarItem(AgregarItemRequestModel request);
  Future<void> limpiarCarrito();
  Future<CarritoModel> eliminarItem(int itemId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient dioClient;

  CartRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CarritoModel> getCarrito() async {
    try {
      final response = await dioClient.dio.get('/api/usuario/carrito');
      return CarritoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CarritoModel> agregarItem(AgregarItemRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/usuario/carrito/agregar',
        data: request.toJson(),
      );
      return CarritoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CarritoModel> eliminarItem(int itemId) async {
    try {
      final response = await dioClient.dio.delete('/api/usuario/carrito/items/$itemId');
      return CarritoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> limpiarCarrito() async {
    try {
      await dioClient.dio.delete('/api/usuario/carrito/limpiar');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('No autenticado');
    } else if (e.response?.statusCode == 404) {
      return Exception('Carrito no encontrado');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
