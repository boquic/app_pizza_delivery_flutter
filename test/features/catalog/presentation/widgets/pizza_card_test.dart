import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzas_reyna_flutter/features/catalog/domain/entities/pizza.dart';
import 'package:pizzas_reyna_flutter/features/catalog/presentation/widgets/pizza_card.dart';

void main() {
  group('PizzaCard Widget Tests', () {
    final testPizza = Pizza(
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

    testWidgets('should display pizza information correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PizzaCard(
              pizza: testPizza,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Pizza Margarita'), findsOneWidget);
      expect(find.text('Deliciosa pizza con tomate y queso'), findsOneWidget);
      expect(find.text('\$12.99'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text('120 reseñas'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PizzaCard(
              pizza: testPizza,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('should show unavailable overlay when pizza is not available',
        (WidgetTester tester) async {
      final unavailablePizza = Pizza(
        id: '2',
        name: 'Pizza Hawaiana',
        description: 'Pizza con piña',
        basePrice: 14.99,
        imageUrl: 'https://example.com/pizza2.jpg',
        rating: 4.0,
        reviewCount: 80,
        category: 'especiales',
        availableSizes: ['mediana', 'grande'],
        isAvailable: false,
        tags: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PizzaCard(
              pizza: unavailablePizza,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('No disponible'), findsOneWidget);
    });
  });
}
