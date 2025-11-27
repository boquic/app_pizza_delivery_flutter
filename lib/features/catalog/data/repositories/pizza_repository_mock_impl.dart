import '../../domain/entities/pizza.dart';
import '../../domain/entities/pizza_category.dart';
import '../../domain/repositories/pizza_repository.dart';

/// Implementación mock del repositorio de pizzas (DEPRECADO)
/// Este repositorio usa datos mock con campos antiguos
/// Usar PizzaRepositoryImpl con PizzaApiDataSource en su lugar
class PizzaRepositoryMockImpl implements PizzaRepository {
  PizzaRepositoryMockImpl();

  @override
  Future<List<Pizza>> getPizzas({
    required int page,
    required int limit,
    String? category,
  }) async {
    // Retornar lista vacía - usar API real
    return [];
  }

  @override
  Future<List<PizzaCategory>> getCategories() async {
    // Retornar lista vacía - usar API real
    return [];
  }

  @override
  Future<Pizza> getPizzaById(String id) async {
    throw UnimplementedError('Usar PizzaRepositoryImpl con API real');
  }
}
