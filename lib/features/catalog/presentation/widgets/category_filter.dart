import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/pizza_category.dart';

/// Widget para filtrar pizzas por categoría
class CategoryFilter extends StatelessWidget {
  final List<PizzaCategory> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Chip "Todas"
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Todas'),
              selected: selectedCategory == null,
              onSelected: (_) => onCategorySelected(null),
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: selectedCategory == null
                    ? Colors.white
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Chips de categorías
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.icon),
                    const SizedBox(width: 4),
                    Text(category.name),
                    const SizedBox(width: 4),
                    Text(
                      '(${category.pizzaCount})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                selected: selectedCategory == category.id,
                onSelected: (_) => onCategorySelected(category.id),
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: selectedCategory == category.id
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
