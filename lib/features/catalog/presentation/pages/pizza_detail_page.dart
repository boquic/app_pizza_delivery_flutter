import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/price_indicator.dart';
import '../../../../core/widgets/success_dialog.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/entities/pizza.dart';
import '../providers/pizza_providers.dart';

/// Página de detalle de una pizza
class PizzaDetailPage extends ConsumerStatefulWidget {
  final int pizzaId;

  const PizzaDetailPage({
    super.key,
    required this.pizzaId,
  });

  @override
  ConsumerState<PizzaDetailPage> createState() => _PizzaDetailPageState();
}

class _PizzaDetailPageState extends ConsumerState<PizzaDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final pizzaAsync = ref.watch(pizzaDetailProvider(widget.pizzaId.toString()));
    final authState = ref.watch(authProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: pizzaAsync.when(
        data: (pizza) => _buildContent(pizza, authState, cartState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Pizza pizza, AuthState authState, CartState cartState) {
    return CustomScrollView(
      slivers: [
        // App Bar con imagen
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: pizza.imagenUrl != null
                ? CachedNetworkImage(
                    imageUrl: pizza.imagenUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.local_pizza, size: 100),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.local_pizza, size: 100),
                  ),
          ),
        ),

        // Contenido
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y disponibilidad
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pizza.nombre,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    if (!pizza.disponible)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'No disponible',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tamaño
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tamaño: ${pizza.tamanio}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Descripción
                Text(
                  pizza.descripcion,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // Ingredientes
                if (pizza.ingredientes.isNotEmpty) ...[
                  Text(
                    'Ingredientes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pizza.ingredientes.map((ing) {
                      return Chip(
                        label: Text(ing.nombre),
                        avatar: ing.imagenUrl != null
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(ing.imagenUrl!),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.restaurant, size: 16),
                              ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Precio y cantidad
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Precio',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            PriceIndicator(
                              price: pizza.precioBase,
                              isLarge: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantidad',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(
                                  '$_quantity',
                                  style:
                                      Theme.of(context).textTheme.titleLarge,
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _quantity++),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            PriceIndicator(
                              price: pizza.precioBase * _quantity,
                              isLarge: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botón agregar al carrito
                if (pizza.disponible)
                  CustomButton(
                    text: authState.isAuthenticated
                        ? 'Agregar al carrito'
                        : 'Inicia sesión para ordenar',
                    onPressed: authState.isAuthenticated
                        ? () => _addToCart(pizza)
                        : () => _showLoginDialog(),
                    isLoading: cartState.isLoading,
                    icon: authState.isAuthenticated
                        ? Icons.shopping_cart
                        : Icons.login,
                  )
                else
                  CustomButton(
                    text: 'No disponible',
                    onPressed: null,
                    backgroundColor: AppColors.textSecondary,
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addToCart(Pizza pizza) async {
    final success = await ref.read(cartProvider.notifier).addItem(
          pizzaId: pizza.id,
          cantidad: _quantity,
        );

    if (!mounted) return;

    if (success) {
      // Mostrar popup de éxito
      await SuccessDialog.show(
        context,
        title: '¡Agregado al Carrito!',
        message: '${pizza.nombre} se agregó correctamente a tu carrito',
        icon: Icons.shopping_cart_outlined,
      );
    } else {
      final cartState = ref.read(cartProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cartState.error ?? 'Error al agregar al carrito',
          ),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Cerrar',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inicia sesión'),
        content: const Text(
          'Necesitas iniciar sesión para agregar productos al carrito.',
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
