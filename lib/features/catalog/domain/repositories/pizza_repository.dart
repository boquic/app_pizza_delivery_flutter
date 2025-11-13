import '../entities/pizza.dart';
import '../entities/pizza_category.dart';

/// Repositorio de pizzas
abstract class PizzaRepository {
  Future<List<Pizza>> getPizzas({
    required int page,
    required int limit,
    String? category,
  });
  
  Future<List<PizzaCategory>> getCategories();
  
  Future<Pizza> getPizzaById(String id);
}
