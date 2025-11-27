import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/pizza_providers.dart';
import '../widgets/category_filter.dart';
import '../widgets/pizza_card.dart';
import '../widgets/pizza_grid_shimmer.dart';
import 'pizza_detail_page.dart';

/// Página principal del catálogo de pizzas
class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(pizzaCatalogProvider.notifier).loadPizzas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(pizzaCatalogProvider);
    final categoriesAsync = ref.watch(pizzaCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizzas Reyna'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Búsqueda próximamente')),
              );
            },
          ),
          _buildAuthButton(),
          _buildCartButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filtro de categorías
          categoriesAsync.when(
            data: (categories) => CategoryFilter(
              categories: categories,
              selectedCategory: catalogState.selectedCategory,
              onCategorySelected: (category) {
                ref.read(pizzaCatalogProvider.notifier).filterByCategory(category);
              },
            ),
            loading: () => const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => const SizedBox.shrink(),
          ),
          const Divider(height: 1),
          
          // Grid de pizzas
          Expanded(
            child: catalogState.pizzas.isEmpty && catalogState.isLoading
                ? const PizzaGridShimmer()
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.read(pizzaCatalogProvider.notifier).refresh();
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: catalogState.pizzas.length +
                          (catalogState.isLoading ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= catalogState.pizzas.length) {
                          return const Card(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final pizza = catalogState.pizzas[index];
                        return PizzaCard(
                          pizza: pizza,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PizzaDetailPage(
                                  pizzaId: pizza.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
          
          // Error message
          if (catalogState.error != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.error.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      catalogState.error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(pizzaCatalogProvider.notifier).loadPizzas();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }

  Widget _buildAuthButton() {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated) {
      // Usuario autenticado - Mostrar botón de perfil
      return IconButton(
        icon: const Icon(Icons.person),
        tooltip: 'Perfil',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
        },
      );
    } else {
      // Usuario no autenticado - Mostrar botón de login
      return TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
        icon: const Icon(Icons.login, size: 20),
        label: const Text('Ingresar'),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }
  }

  Widget _buildCartButton() {
    final authState = ref.watch(authProvider);
    final cartState = ref.watch(cartProvider);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => _handleCartNavigation(authState),
        ),
        if (authState.isAuthenticated && cartState.itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '${cartState.itemCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _handleCartNavigation(AuthState authState) {
    if (!authState.isAuthenticated) {
      _showLoginRequiredDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CartPage(),
        ),
      );
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inicia sesión'),
        content: const Text(
          'Necesitas iniciar sesión para ver tu carrito y realizar pedidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
