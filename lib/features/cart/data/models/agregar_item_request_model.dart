import 'package:freezed_annotation/freezed_annotation.dart';

part 'agregar_item_request_model.freezed.dart';
part 'agregar_item_request_model.g.dart';

@freezed
class AgregarItemRequestModel with _$AgregarItemRequestModel {
  const factory AgregarItemRequestModel({
    int? pizzaId,
    int? comboId,
    required int cantidad,
    String? notas,
    List<int>? ingredientesPersonalizadosIds,
  }) = _AgregarItemRequestModel;

  factory AgregarItemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AgregarItemRequestModelFromJson(json);
}
