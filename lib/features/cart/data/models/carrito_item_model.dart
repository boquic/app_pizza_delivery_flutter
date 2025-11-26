import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/models/ingrediente_model.dart';

part 'carrito_item_model.freezed.dart';
part 'carrito_item_model.g.dart';

@freezed
class CarritoItemModel with _$CarritoItemModel {
  const factory CarritoItemModel({
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
  }) = _CarritoItemModel;

  factory CarritoItemModel.fromJson(Map<String, dynamic> json) =>
      _$CarritoItemModelFromJson(json);
}
