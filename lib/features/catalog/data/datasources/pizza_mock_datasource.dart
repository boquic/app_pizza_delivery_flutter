import '../models/pizza_category_model.dart';
import '../models/pizza_model.dart';

/// Fuente de datos mock para desarrollo sin API
class PizzaMockDataSource {
  /// Simula delay de red
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Obtiene pizzas mock
  Future<List<PizzaModel>> getPizzas({
    required int page,
    required int limit,
    String? category,
  }) async {
    await _simulateNetworkDelay();

    final allPizzas = _mockPizzas;
    
    // Filtrar por categoría si se especifica
    final filteredPizzas = category != null && category.isNotEmpty
        ? allPizzas.where((p) => p.category == category).toList()
        : allPizzas;

    // Simular paginación
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= filteredPizzas.length) {
      return [];
    }

    return filteredPizzas.sublist(
      startIndex,
      endIndex > filteredPizzas.length ? filteredPizzas.length : endIndex,
    );
  }

  /// Obtiene categorías mock
  Future<List<PizzaCategoryModel>> getCategories() async {
    await _simulateNetworkDelay();
    return _mockCategories;
  }

  /// Obtiene una pizza por ID
  Future<PizzaModel> getPizzaById(String id) async {
    await _simulateNetworkDelay();
    return _mockPizzas.firstWhere(
      (pizza) => pizza.id == id,
      orElse: () => throw Exception('Pizza no encontrada'),
    );
  }

  // Datos mock
  static final List<PizzaCategoryModel> _mockCategories = [
    const PizzaCategoryModel(
      id: 'clasicas',
      name: 'Clásicas',
      icon: '🍕',
      pizzaCount: 8,
    ),
    const PizzaCategoryModel(
      id: 'especiales',
      name: 'Especiales',
      icon: '⭐',
      pizzaCount: 6,
    ),
    const PizzaCategoryModel(
      id: 'vegetarianas',
      name: 'Vegetarianas',
      icon: '🥗',
      pizzaCount: 4,
    ),
    const PizzaCategoryModel(
      id: 'premium',
      name: 'Premium',
      icon: '👑',
      pizzaCount: 5,
    ),
  ];

  static final List<PizzaModel> _mockPizzas = [
    // Clásicas
    const PizzaModel(
      id: '1',
      name: 'Margarita',
      description: 'Salsa de tomate, mozzarella fresca y albahaca',
      basePrice: 12.99,
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
      rating: 4.5,
      reviewCount: 120,
      category: 'clasicas',
      availableSizes: ['pequeña', 'mediana', 'grande'],
      isAvailable: true,
      tags: ['vegetariana', 'popular'],
    ),
    const PizzaModel(
      id: '2',
      name: 'Pepperoni',
      description: 'Salsa de tomate, mozzarella y pepperoni premium',
      basePrice: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
      rating: 4.8,
      reviewCount: 250,
      category: 'clasicas',
      availableSizes: ['pequeña', 'mediana', 'grande', 'familiar'],
      isAvailable: true,
      tags: ['popular', 'favorita'],
    ),
    const PizzaModel(
      id: '3',
      name: 'Hawaiana',
      description: 'Jamón, piña, mozzarella y salsa especial',
      basePrice: 13.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      rating: 4.2,
      reviewCount: 89,
      category: 'clasicas',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['dulce'],
    ),
    const PizzaModel(
      id: '4',
      name: 'Cuatro Quesos',
      description: 'Mozzarella, parmesano, gorgonzola y provolone',
      basePrice: 15.99,
      imageUrl: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      rating: 4.7,
      reviewCount: 156,
      category: 'clasicas',
      availableSizes: ['pequeña', 'mediana', 'grande'],
      isAvailable: true,
      tags: ['vegetariana', 'queso'],
    ),
    const PizzaModel(
      id: '5',
      name: 'Napolitana',
      description: 'Tomate, mozzarella, anchoas y orégano',
      basePrice: 13.49,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      rating: 4.4,
      reviewCount: 98,
      category: 'clasicas',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['tradicional'],
    ),

    // Especiales
    const PizzaModel(
      id: '6',
      name: 'BBQ Chicken',
      description: 'Pollo, salsa BBQ, cebolla morada y cilantro',
      basePrice: 16.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400',
      rating: 4.6,
      reviewCount: 134,
      category: 'especiales',
      availableSizes: ['mediana', 'grande', 'familiar'],
      isAvailable: true,
      tags: ['pollo', 'popular'],
    ),
    const PizzaModel(
      id: '7',
      name: 'Mexicana',
      description: 'Carne molida, jalapeños, pimientos y especias',
      basePrice: 15.49,
      imageUrl: 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400',
      rating: 4.5,
      reviewCount: 112,
      category: 'especiales',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['picante', 'carne'],
    ),
    const PizzaModel(
      id: '8',
      name: 'Mediterránea',
      description: 'Aceitunas, tomates cherry, feta y rúcula',
      basePrice: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1595854341625-f33ee10dbf94?w=400',
      rating: 4.3,
      reviewCount: 87,
      category: 'especiales',
      availableSizes: ['pequeña', 'mediana', 'grande'],
      isAvailable: true,
      tags: ['vegetariana', 'saludable'],
    ),

    // Vegetarianas
    const PizzaModel(
      id: '9',
      name: 'Vegetariana Supreme',
      description: 'Pimientos, champiñones, cebolla, aceitunas y tomate',
      basePrice: 13.99,
      imageUrl: 'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?w=400',
      rating: 4.4,
      reviewCount: 76,
      category: 'vegetarianas',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['vegetariana', 'saludable'],
    ),
    const PizzaModel(
      id: '10',
      name: 'Caprese',
      description: 'Tomate, mozzarella de búfala, albahaca y aceite de oliva',
      basePrice: 14.49,
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
      rating: 4.6,
      reviewCount: 92,
      category: 'vegetarianas',
      availableSizes: ['pequeña', 'mediana'],
      isAvailable: true,
      tags: ['vegetariana', 'fresca'],
    ),

    // Premium
    const PizzaModel(
      id: '11',
      name: 'Trufa Negra',
      description: 'Mozzarella, trufa negra, champiñones portobello y parmesano',
      basePrice: 24.99,
      imageUrl: 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=400',
      rating: 4.9,
      reviewCount: 45,
      category: 'premium',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['premium', 'gourmet'],
    ),
    const PizzaModel(
      id: '12',
      name: 'Langosta y Camarones',
      description: 'Langosta, camarones, ajo, mantequilla y hierbas',
      basePrice: 28.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      rating: 4.8,
      reviewCount: 38,
      category: 'premium',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['premium', 'mariscos'],
    ),
    const PizzaModel(
      id: '13',
      name: 'Prosciutto e Rúcula',
      description: 'Prosciutto di Parma, rúcula, parmesano y aceite de trufa',
      basePrice: 22.99,
      imageUrl: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      rating: 4.7,
      reviewCount: 67,
      category: 'premium',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['premium', 'italiana'],
    ),

    // Más pizzas para paginación
    const PizzaModel(
      id: '14',
      name: 'Carbonara',
      description: 'Crema, bacon, huevo, parmesano y pimienta negra',
      basePrice: 15.99,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      rating: 4.5,
      reviewCount: 103,
      category: 'especiales',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['cremosa', 'bacon'],
    ),
    const PizzaModel(
      id: '15',
      name: 'Funghi',
      description: 'Champiñones variados, ajo, perejil y mozzarella',
      basePrice: 13.49,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      rating: 4.3,
      reviewCount: 71,
      category: 'vegetarianas',
      availableSizes: ['pequeña', 'mediana', 'grande'],
      isAvailable: true,
      tags: ['vegetariana', 'champiñones'],
    ),
    const PizzaModel(
      id: '16',
      name: 'Diavola',
      description: 'Salami picante, jalapeños, mozzarella y aceite de chile',
      basePrice: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
      rating: 4.6,
      reviewCount: 128,
      category: 'especiales',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['picante', 'popular'],
    ),
    const PizzaModel(
      id: '17',
      name: 'Calzone Especial',
      description: 'Pizza cerrada con jamón, champiñones y mozzarella',
      basePrice: 13.99,
      imageUrl: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      rating: 4.4,
      reviewCount: 85,
      category: 'clasicas',
      availableSizes: ['individual'],
      isAvailable: true,
      tags: ['calzone'],
    ),
    const PizzaModel(
      id: '18',
      name: 'Pesto Genovese',
      description: 'Pesto de albahaca, tomates cherry, mozzarella y piñones',
      basePrice: 16.49,
      imageUrl: 'https://images.unsplash.com/photo-1595854341625-f33ee10dbf94?w=400',
      rating: 4.7,
      reviewCount: 94,
      category: 'vegetarianas',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['vegetariana', 'pesto'],
    ),
    const PizzaModel(
      id: '19',
      name: 'Carne Lovers',
      description: 'Pepperoni, salchicha, bacon, jamón y carne molida',
      basePrice: 17.99,
      imageUrl: 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400',
      rating: 4.8,
      reviewCount: 167,
      category: 'especiales',
      availableSizes: ['grande', 'familiar'],
      isAvailable: true,
      tags: ['carne', 'abundante'],
    ),
    const PizzaModel(
      id: '20',
      name: 'Salmón Ahumado',
      description: 'Salmón ahumado, crema agria, alcaparras y eneldo',
      basePrice: 21.99,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      rating: 4.6,
      reviewCount: 52,
      category: 'premium',
      availableSizes: ['mediana', 'grande'],
      isAvailable: true,
      tags: ['premium', 'pescado'],
    ),
  ];
}
