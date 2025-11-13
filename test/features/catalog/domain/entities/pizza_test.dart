import 'package:flutter_test/flutter_test.dart';
import 'package:pizzas_reyna_flutter/features/catalog/domain/entities/pizza.dart';

void main() {
  group('Pizza Entity Tests', () {
    test('should create a Pizza instance with all required fields', () {
      final pizza = Pizza(
        id: '1',
        name: 'Pizza Margarita',
        description: 'Deliciosa pizza con tomate y queso',
        basePrice: 12.99,
        imageUrl: 'https://example.com/pizza.jpg',
        rating: 4.5,
        reviewCount: 120,
        category: 'clasicas',
        availableSizes: ['pequeña', 'mediana', 'grande'],
        isAvailable: true,
        tags: ['vegetariana'],
      );

      expect(pizza.id, '1');
      expect(pizza.name, 'Pizza Margarita');
      expect(pizza.basePrice, 12.99);
      expect(pizza.rating, 4.5);
      expect(pizza.isAvailable, true);
      expect(pizza.tags, ['vegetariana']);
    });

    test('should create a Pizza with empty tags by default', () {
      final pizza = Pizza(
        id: '1',
        name: 'Pizza Margarita',
        description: 'Deliciosa pizza',
        basePrice: 12.99,
        imageUrl: 'https://example.com/pizza.jpg',
        rating: 4.5,
        reviewCount: 120,
        category: 'clasicas',
        availableSizes: ['mediana'],
        isAvailable: true,
      );

      expect(pizza.tags, isEmpty);
    });

    test('should support equality comparison', () {
      final pizza1 = Pizza(
        id: '1',
        name: 'Pizza Margarita',
        description: 'Deliciosa pizza',
        basePrice: 12.99,
        imageUrl: 'https://example.com/pizza.jpg',
        rating: 4.5,
        reviewCount: 120,
        category: 'clasicas',
        availableSizes: ['mediana'],
        isAvailable: true,
      );

      final pizza2 = Pizza(
        id: '1',
        name: 'Pizza Margarita',
        description: 'Deliciosa pizza',
        basePrice: 12.99,
        imageUrl: 'https://example.com/pizza.jpg',
        rating: 4.5,
        reviewCount: 120,
        category: 'clasicas',
        availableSizes: ['mediana'],
        isAvailable: true,
      );

      expect(pizza1, equals(pizza2));
    });
  });
}
