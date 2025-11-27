import '../models/pizza_model.dart';
import 'pizza_api_datasource.dart';

/// Fuente de datos mock para desarrollo sin API
class PizzaMockDataSource implements PizzaApiDataSource {
  /// Simula delay de red
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<PizzaModel>> getPizzas() async {
    await _simulateNetworkDelay();
    return _mockPizzas;
  }

  @override
  Future<PizzaModel> getPizzaById(int id) async {
    await _simulateNetworkDelay();
    return _mockPizzas.firstWhere(
      (pizza) => pizza.id == id,
      orElse: () => throw Exception('Pizza no encontrada'),
    );
  }

  // Datos mock
  static final List<PizzaModel> _mockPizzas = [
    // Pizzas clásicas
    const PizzaModel(
      id: 1,
      nombre: 'Margarita',
      descripcion: 'Salsa de tomate, mozzarella fresca y albahaca',
      precioBase: 12.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 2,
      nombre: 'Pepperoni',
      descripcion: 'Salsa de tomate, mozzarella y pepperoni premium',
      precioBase: 14.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 3,
      nombre: 'Hawaiana',
      descripcion: 'Jamón, piña, mozzarella y salsa especial',
      precioBase: 13.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 4,
      nombre: 'Cuatro Quesos',
      descripcion: 'Mozzarella, parmesano, gorgonzola y provolone',
      precioBase: 15.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 5,
      nombre: 'Napolitana',
      descripcion: 'Tomate, mozzarella, anchoas y orégano',
      precioBase: 13.49,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 6,
      nombre: 'BBQ Chicken',
      descripcion: 'Pollo, salsa BBQ, cebolla morada y cilantro',
      precioBase: 16.99,
      tamanio: 'GRANDE',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 7,
      nombre: 'Mexicana',
      descripcion: 'Carne molida, jalapeños, pimientos y especias',
      precioBase: 15.49,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 8,
      nombre: 'Mediterránea',
      descripcion: 'Aceitunas, tomates cherry, feta y rúcula',
      precioBase: 14.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1595854341625-f33ee10dbf94?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 9,
      nombre: 'Vegetariana Supreme',
      descripcion: 'Pimientos, champiñones, cebolla, aceitunas y tomate',
      precioBase: 13.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 10,
      nombre: 'Caprese',
      descripcion: 'Tomate, mozzarella de búfala, albahaca y aceite de oliva',
      precioBase: 14.49,
      tamanio: 'PEQUEÑA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 11,
      nombre: 'Trufa Negra',
      descripcion: 'Mozzarella, trufa negra, champiñones portobello y parmesano',
      precioBase: 24.99,
      tamanio: 'GRANDE',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 12,
      nombre: 'Langosta y Camarones',
      descripcion: 'Langosta, camarones, ajo, mantequilla y hierbas',
      precioBase: 28.99,
      tamanio: 'GRANDE',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 13,
      nombre: 'Prosciutto e Rúcula',
      descripcion: 'Prosciutto di Parma, rúcula, parmesano y aceite de trufa',
      precioBase: 22.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 14,
      nombre: 'Carbonara',
      descripcion: 'Crema, bacon, huevo, parmesano y pimienta negra',
      precioBase: 15.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 15,
      nombre: 'Funghi',
      descripcion: 'Champiñones variados, ajo, perejil y mozzarella',
      precioBase: 13.49,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 16,
      nombre: 'Diavola',
      descripcion: 'Salami picante, jalapeños, mozzarella y aceite de chile',
      precioBase: 14.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 17,
      nombre: 'Calzone Especial',
      descripcion: 'Pizza cerrada con jamón, champiñones y mozzarella',
      precioBase: 13.99,
      tamanio: 'INDIVIDUAL',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 18,
      nombre: 'Pesto Genovese',
      descripcion: 'Pesto de albahaca, tomates cherry, mozzarella y piñones',
      precioBase: 16.49,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1595854341625-f33ee10dbf94?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 19,
      nombre: 'Carne Lovers',
      descripcion: 'Pepperoni, salchicha, bacon, jamón y carne molida',
      precioBase: 17.99,
      tamanio: 'FAMILIAR',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
    const PizzaModel(
      id: 20,
      nombre: 'Salmón Ahumado',
      descripcion: 'Salmón ahumado, crema agria, alcaparras y eneldo',
      precioBase: 21.99,
      tamanio: 'MEDIANA',
      disponible: true,
      imagenUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      esPersonalizada: false,
      ingredientes: [],
    ),
  ];
}
