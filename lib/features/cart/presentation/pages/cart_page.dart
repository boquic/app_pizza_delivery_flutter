import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';

/// Pantalla del carrito de compras
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        actions: [
          if (cartState.cart != null && cartState.cart!.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Limpiar carrito',
              onPressed: () => _showClearCartDialog(context, ref),
            ),
        ],
      ),
      body: _buildBody(context, ref, cartState),
      bottomNavigationBar: cartState.cart != null &&
              cartState.cart!.items.isNotEmpty
          ? _buildCheckoutBar(context, ref, cartState)
          : null,
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
  ) {
    if (cartState.isLoading && cartState.cart == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartState.error != null) {
      return ErrorView(
        message: cartState.error!,
        onRetry: () => ref.read(cartProvider.notifier).loadCart(),
      );
    }

    if (cartState.cart == null || cartState.cart!.items.isEmpty) {
      return EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Carrito vacío',
        message: 'Agrega pizzas deliciosas a tu carrito',
        action: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ver Catálogo'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(cartProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cartState.cart!.items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = cartState.cart!.items[index];
          return CartItemWidget(
            item: item,
            onRemove: () => _showRemoveItemDialog(context, ref, item),
          );
        },
      ),
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
  ) {
    final theme = Theme.of(context);
    final cart = cartState.cart!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Resumen de precios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Envío',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Gratis',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${cart.total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botón de checkout
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función de pago en desarrollo'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'Proceder al Pago',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveItemDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic item,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Item'),
        content: Text(
          '¿Deseas eliminar "${item.pizzaNombre ?? item.comboNombre ?? 'este item'}" del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(cartProvider.notifier).removeItem(item.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item eliminado del carrito'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar: ${e.toString().replaceAll('Exception: ', '')}'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Carrito'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos los items del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(cartProvider.notifier).clearCart();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Carrito limpiado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}
