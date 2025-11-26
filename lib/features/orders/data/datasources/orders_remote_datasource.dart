import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/pedido_model.dart';
import '../models/crear_pedido_request_model.dart';

abstract class OrdersRemoteDataSource {
  Future<PedidoModel> crearPedido(CrearPedidoRequestModel request);
  Future<List<PedidoModel>> getHistorialPedidos();
  Future<PedidoModel> getPedidoById(int id);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final DioClient dioClient;

  OrdersRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<PedidoModel> crearPedido(CrearPedidoRequestModel request) async {
    try {
      final response = await dioClient.dio.post(
        '/api/usuario/pedidos',
        data: request.toJson(),
      );
      return PedidoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<PedidoModel>> getHistorialPedidos() async {
    try {
      final response = await dioClient.dio.get('/api/usuario/pedidos');
      final List<dynamic> data = response.data;
      return data.map((json) => PedidoModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PedidoModel> getPedidoById(int id) async {
    try {
      final response = await dioClient.dio.get('/api/usuario/pedidos/$id');
      return PedidoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('No autenticado');
    } else if (e.response?.statusCode == 404) {
      return Exception('Pedido no encontrado');
    } else if (e.response?.statusCode == 400) {
      return Exception('Datos inválidos');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
