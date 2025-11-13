import 'package:freezed_annotation/freezed_annotation.dart';

part 'pizza_category.freezed.dart';

/// Categoría de pizzas
@freezed
class PizzaCategory with _$PizzaCategory {
  const factory PizzaCategory({
    required String id,
    required String name,
    required String icon,
    @Default(0) int pizzaCount,
  }) = _PizzaCategory;
}
