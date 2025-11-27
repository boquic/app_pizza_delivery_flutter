import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/pizza.dart';
import '../../domain/entities/pizza_category.dart';
import '../../domain/repositories/pizza_repository.dart';

part 'pizza_providers.g.dart';

/// Provider del repositorio de pizzas
@riverpod
PizzaRepository pizzaRepository(PizzaRepositoryRef ref) {
  return getIt<PizzaRepository>();
}

/// Provider para obtener categorías (mock temporal)
@riverpod
Future<List<PizzaCategory>> pizzaCategories(PizzaCategoriesRef ref) async {
  // Retornar lista vacía temporalmente hasta implementar categorías
  return [];
}

/// Estado del catálogo de pizzas
class PizzaCatalogState {
  final List<Pizza> pizzas;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? selectedCategory;
  final String? error;

  PizzaCatalogState({
    this.pizzas = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.selectedCategory,
    this.error,
  });

  PizzaCatalogState copyWith({
    List<Pizza>? pizzas,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? selectedCategory,
    String? error,
  }) {
    return PizzaCatalogState(
      pizzas: pizzas ?? this.pizzas,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }
}

/// Notifier para el catálogo de pizzas con paginación
@riverpod
class PizzaCatalog extends _$PizzaCatalog {
  static const int _pageSize = 20;

  @override
  PizzaCatalogState build() {
    loadPizzas();
    return PizzaCatalogState();
  }

  /// Carga pizzas (sin paginación por ahora)
  Future<void> loadPizzas() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(pizzaRepositoryProvider);
      final allPizzas = await repository.getPizzas(
        page: 1,
        limit: 100,
        category: state.selectedCategory,
      );

      state = state.copyWith(
        pizzas: allPizzas,
        isLoading: false,
        hasMore: false,
        currentPage: 1,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Filtra por categoría
  void filterByCategory(String? category) {
    state = PizzaCatalogState(
      selectedCategory: category,
      currentPage: 1,
      hasMore: true,
    );
    loadPizzas();
  }

  /// Recarga el catálogo
  void refresh() {
    state = PizzaCatalogState(
      selectedCategory: state.selectedCategory,
      currentPage: 1,
      hasMore: true,
    );
    loadPizzas();
  }
}

/// Provider para obtener una pizza por ID
@riverpod
Future<Pizza> pizzaDetail(PizzaDetailRef ref, String pizzaId) async {
  final repository = ref.watch(pizzaRepositoryProvider);
  return repository.getPizzaById(pizzaId);
}
