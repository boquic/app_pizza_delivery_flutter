import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/models/ingrediente_model.dart';

part 'pedido_detalle_model.freezed.dart';
part 'pedido_detalle_model.g.dart';

@freezed
class PedidoDetalleModel with _$PedidoDetalleModel {
  const factory PedidoDetalleModel({
    required int id,
    int? pizzaId,
    String? pizzaNombre,
    int? comboId,
    String? comboNombre,
    required int cantidad,
    required double precioUnitario,
    required double subtotal,
    String? notas,
    @Default([]) List<IngredienteModel> ingredientesPersonalizados,
  }) = _PedidoDetalleModel;

  factory PedidoDetalleModel.fromJson(Map<String, dynamic> json) =>
      _$PedidoDetalleModelFromJson(json);
}
