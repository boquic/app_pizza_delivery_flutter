import '../../domain/entities/pizza.dart';
import '../../domain/entities/pizza_category.dart';
import '../../domain/repositories/pizza_repository.dart';
import '../datasources/pizza_api_datasource.dart';
import '../models/pizza_model.dart';

/// Implementación del repositorio de pizzas (actualizado para nueva API)
class PizzaRepositoryImpl implements PizzaRepository {
  final PizzaApiDataSource _apiDataSource;

  PizzaRepositoryImpl(this._apiDataSource);

  @override
  Future<List<Pizza>> getPizzas({
    required int page,
    required int limit,
    String? category,
  }) async {
    // La nueva API no usa paginación en el endpoint GET /api/pizzas
    // Retorna todas las pizzas disponibles
    final models = await _apiDataSource.getPizzas();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<PizzaCategory>> getCategories() async {
    // TODO: Implementar cuando el backend tenga endpoint de categorías
    // Por ahora retornamos lista vacía
    return [];
  }

  @override
  Future<Pizza> getPizzaById(String id) async {
    final model = await _apiDataSource.getPizzaById(int.parse(id));
    return _modelToEntity(model);
  }

  /// Convierte PizzaModel a entidad Pizza
  Pizza _modelToEntity(PizzaModel model) {
    return Pizza(
      id: model.id,
      nombre: model.nombre,
      descripcion: model.descripcion,
      precioBase: model.precioBase,
      tamanio: model.tamanio,
      disponible: model.disponible,
      imagenUrl: model.imagenUrl,
      esPersonalizada: model.esPersonalizada,
      ingredientes: model.ingredientes
          .map((ing) => Ingrediente(
                id: ing.id,
                nombre: ing.nombre,
                descripcion: ing.descripcion,
                precioAdicional: ing.precioAdicional,
                disponible: ing.disponible,
                imagenUrl: ing.imagenUrl,
              ))
          .toList(),
    );
  }
}
