import 'package:freezed_annotation/freezed_annotation.dart';

part 'pizza.freezed.dart';

/// Entidad de Pizza
@freezed
class Pizza with _$Pizza {
  const factory Pizza({
    required String id,
    required String name,
    required String description,
    required double basePrice,
    required String imageUrl,
    required double rating,
    required int reviewCount,
    required String category,
    required List<String> availableSizes,
    required bool isAvailable,
    @Default([]) List<String> tags,
  }) = _Pizza;
}
