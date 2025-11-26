import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingrediente_model.freezed.dart';
part 'ingrediente_model.g.dart';

@freezed
class IngredienteModel with _$IngredienteModel {
  const factory IngredienteModel({
    required int id,
    required String nombre,
    required String descripcion,
    required double precioAdicional,
    required bool disponible,
    String? imagenUrl,
  }) = _IngredienteModel;

  factory IngredienteModel.fromJson(Map<String, dynamic> json) =>
      _$IngredienteModelFromJson(json);
}
