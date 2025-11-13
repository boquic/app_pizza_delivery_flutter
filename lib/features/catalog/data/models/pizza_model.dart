import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/pizza.dart';

part 'pizza_model.freezed.dart';
part 'pizza_model.g.dart';

/// Modelo de datos para Pizza
@freezed
class PizzaModel with _$PizzaModel {
  const PizzaModel._();

  const factory PizzaModel({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'base_price') required double basePrice,
    @JsonKey(name: 'image_url') required String imageUrl,
    required double rating,
    @JsonKey(name: 'review_count') required int reviewCount,
    required String category,
    @JsonKey(name: 'available_sizes') required List<String> availableSizes,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @Default([]) List<String> tags,
  }) = _PizzaModel;

  factory PizzaModel.fromJson(Map<String, dynamic> json) =>
      _$PizzaModelFromJson(json);

  /// Convierte el modelo a entidad de dominio
  Pizza toEntity() {
    return Pizza(
      id: id,
      name: name,
      description: description,
      basePrice: basePrice,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      category: category,
      availableSizes: availableSizes,
      isAvailable: isAvailable,
      tags: tags,
    );
  }

  /// Crea un modelo desde una entidad de dominio
  factory PizzaModel.fromEntity(Pizza pizza) {
    return PizzaModel(
      id: pizza.id,
      name: pizza.name,
      description: pizza.description,
      basePrice: pizza.basePrice,
      imageUrl: pizza.imageUrl,
      rating: pizza.rating,
      reviewCount: pizza.reviewCount,
      category: pizza.category,
      availableSizes: pizza.availableSizes,
      isAvailable: pizza.isAvailable,
      tags: pizza.tags,
    );
  }
}
