import '../../domain/entities/pizza.dart';
import '../../domain/entities/pizza_category.dart';
import '../../domain/repositories/pizza_repository.dart';
import '../datasources/pizza_mock_datasource.dart';

/// Implementación del repositorio de pizzas con datos mock
class PizzaRepositoryMockImpl implements PizzaRepository {
  final PizzaMockDataSource _mockDataSource;

  PizzaRepositoryMockImpl(this._mockDataSource);

  @override
  Future<List<Pizza>> getPizzas({
    required int page,
    required int limit,
    String? category,
  }) async {
    final models = await _mockDataSource.getPizzas(
      page: page,
      limit: limit,
      category: category,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<PizzaCategory>> getCategories() async {
    final models = await _mockDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Pizza> getPizzaById(String id) async {
    final model = await _mockDataSource.getPizzaById(id);
    return model.toEntity();
  }
}
