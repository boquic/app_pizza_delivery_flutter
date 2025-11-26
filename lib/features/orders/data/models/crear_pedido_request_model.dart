import 'package:freezed_annotation/freezed_annotation.dart';

part 'crear_pedido_request_model.freezed.dart';
part 'crear_pedido_request_model.g.dart';

@freezed
class CrearPedidoItemModel with _$CrearPedidoItemModel {
  const factory CrearPedidoItemModel({
    int? pizzaId,
    int? comboId,
    required int cantidad,
    String? notas,
    List<int>? ingredientesPersonalizadosIds,
  }) = _CrearPedidoItemModel;

  factory CrearPedidoItemModel.fromJson(Map<String, dynamic> json) =>
      _$CrearPedidoItemModelFromJson(json);
}

@freezed
class CrearPedidoRequestModel with _$CrearPedidoRequestModel {
  const factory CrearPedidoRequestModel({
    required String direccionEntrega,
    required String telefonoContacto,
    String? notas,
    required List<CrearPedidoItemModel> items,
  }) = _CrearPedidoRequestModel;

  factory CrearPedidoRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CrearPedidoRequestModelFromJson(json);
}
