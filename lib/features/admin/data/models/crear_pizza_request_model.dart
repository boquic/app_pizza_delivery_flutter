import 'package:freezed_annotation/freezed_annotation.dart';

part 'crear_pizza_request_model.freezed.dart';
part 'crear_pizza_request_model.g.dart';

@freezed
class CrearPizzaRequestModel with _$CrearPizzaRequestModel {
  const factory CrearPizzaRequestModel({
    required String nombre,
    required String descripcion,
    required double precioBase,
    required String tamanio,
    required bool disponible,
    String? imagenUrl,
    required bool esPersonalizada,
    @Default([]) List<int> ingredientes,
  }) = _CrearPizzaRequestModel;

  factory CrearPizzaRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CrearPizzaRequestModelFromJson(json);
}
