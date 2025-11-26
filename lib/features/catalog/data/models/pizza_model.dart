import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/models/ingrediente_model.dart';

part 'pizza_model.freezed.dart';
part 'pizza_model.g.dart';

/// Modelo de datos para Pizza según API backend
@freezed
class PizzaModel with _$PizzaModel {
  const factory PizzaModel({
    required int id,
    required String nombre,
    required String descripcion,
    required double precioBase,
    required String tamanio,
    required bool disponible,
    String? imagenUrl,
    required bool esPersonalizada,
    @Default([]) List<IngredienteModel> ingredientes,
  }) = _PizzaModel;

  factory PizzaModel.fromJson(Map<String, dynamic> json) =>
      _$PizzaModelFromJson(json);
}
