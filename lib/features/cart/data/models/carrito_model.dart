import 'package:freezed_annotation/freezed_annotation.dart';
import 'carrito_item_model.dart';

part 'carrito_model.freezed.dart';
part 'carrito_model.g.dart';

@freezed
class CarritoModel with _$CarritoModel {
  const factory CarritoModel({
    required int id,
    required int usuarioId,
    @Default([]) List<CarritoItemModel> items,
    required double total,
  }) = _CarritoModel;

  factory CarritoModel.fromJson(Map<String, dynamic> json) =>
      _$CarritoModelFromJson(json);
}
