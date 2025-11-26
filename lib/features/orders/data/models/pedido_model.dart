import 'package:freezed_annotation/freezed_annotation.dart';
import 'pedido_detalle_model.dart';

part 'pedido_model.freezed.dart';
part 'pedido_model.g.dart';

@freezed
class PedidoModel with _$PedidoModel {
  const factory PedidoModel({
    required int id,
    required int usuarioId,
    required String usuarioNombre,
    int? repartidorId,
    String? repartidorNombre,
    required String estadoNombre,
    required String direccionEntrega,
    required String telefonoContacto,
    required double subtotal,
    required double costoEnvio,
    required double total,
    String? notas,
    required DateTime fechaPedido,
    DateTime? fechaEntregaEstimada,
    DateTime? fechaEntregaReal,
    @Default([]) List<PedidoDetalleModel> detalles,
  }) = _PedidoModel;

  factory PedidoModel.fromJson(Map<String, dynamic> json) =>
      _$PedidoModelFromJson(json);
}
