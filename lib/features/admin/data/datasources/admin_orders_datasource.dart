import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../orders/data/models/pedido_model.dart';

abstract class AdminOrdersDataSource {
  Future<List<PedidoModel>> getAllPedidos();
  Future<PedidoModel> actualizarEstado(int pedidoId, String estado);
  Future<PedidoModel> asignarRepartidor(int pedidoId, int repartidorId);
}

class AdminOrdersDataSourceImpl implements AdminOrdersDataSource {
  final DioClient dioClient;

  AdminOrdersDataSourceImpl({required this.dioClient});

  @override
  Future<List<PedidoModel>> getAllPedidos() async {
    try {
      final response = await dioClient.dio.get('/api/admin/pedidos');
      final List<dynamic> data = response.data;
      return data.map((json) => PedidoModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PedidoModel> actualizarEstado(int pedidoId, String estado) async {
    try {
      final response = await dioClient.dio.put(
        '/api/admin/pedidos/$pedidoId/estado',
        queryParameters: {'estado': estado},
      );
      return PedidoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PedidoModel> asignarRepartidor(int pedidoId, int repartidorId) async {
    try {
      final response = await dioClient.dio.put(
        '/api/admin/pedidos/$pedidoId/repartidor',
        queryParameters: {'repartidorId': repartidorId},
      );
      return PedidoModel.fromJson(response.data);
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
      return Exception('Pedido no encontrado');
    }
    return Exception('Error de conexión: ${e.message}');
  }
}
