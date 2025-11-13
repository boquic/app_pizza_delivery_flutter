import '../../domain/entities/pizza.dart';
import '../../domain/entities/pizza_category.dart';
import '../../domain/repositories/pizza_repository.dart';
import '../datasources/pizza_remote_datasource.dart';

/// Implementación del repositorio de pizzas
class PizzaRepositoryImpl implements PizzaRepository {
  final PizzaRemoteDataSource _remoteDataSource;

  PizzaRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Pizza>> getPizzas({
    required int page,
    required int limit,
    String? category,
  }) async {
    final models = await _remoteDataSource.getPizzas(
      page: page,
      limit: limit,
      category: category,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<PizzaCategory>> getCategories() async {
    final models = await _remoteDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Pizza> getPizzaById(String id) async {
    final model = await _remoteDataSource.getPizzaById(id);
    return model.toEntity();
  }
}
