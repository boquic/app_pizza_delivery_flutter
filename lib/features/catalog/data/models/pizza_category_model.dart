import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/pizza_category.dart';

part 'pizza_category_model.freezed.dart';
part 'pizza_category_model.g.dart';

/// Modelo de datos para categoría de pizza
@freezed
class PizzaCategoryModel with _$PizzaCategoryModel {
  const PizzaCategoryModel._();

  const factory PizzaCategoryModel({
    required String id,
    required String name,
    required String icon,
    @JsonKey(name: 'pizza_count') @Default(0) int pizzaCount,
  }) = _PizzaCategoryModel;

  factory PizzaCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$PizzaCategoryModelFromJson(json);

  /// Convierte el modelo a entidad de dominio
  PizzaCategory toEntity() {
    return PizzaCategory(
      id: id,
      name: name,
      icon: icon,
      pizzaCount: pizzaCount,
    );
  }
}
