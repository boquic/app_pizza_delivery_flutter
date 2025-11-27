import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/orders_provider.dart';
import '../../data/models/pedido_model.dart';

/// Pantalla de detalle de un pedido específico
class OrderDetailPage extends ConsumerWidget {
  final int orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersProvider);
    final theme = Theme.of(context);

    // Cargar detalle del pedido
    ref.listen(ordersProvider, (previous, next) {
      if (next.currentOrder == null && !next.isLoading) {
        ref.read(ordersProvider.notifier).loadOrderDetail(orderId);
      }
    });

    if (ordersState.isLoading && ordersState.currentOrder == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del Pedido')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final order = ordersState.currentOrder;
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle del Pedido')),
        body: const Center(child: Text('Pedido no encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Estado del pedido
            _buildStatusCard(order, theme),
            const SizedBox(height: 16),

            // Información del pedido
            _buildInfoCard(order, theme),
            const SizedBox(height: 16),

            // Items del pedido
            _buildItemsCard(order, theme),
            const SizedBox(height: 16),

            // Resumen de precios
            _buildPriceSummaryCard(order, theme),
            const SizedBox(height: 16),

            // Botón de tracking si está en camino
            if (order.estadoNombre.toUpperCase() == 'EN_CAMINO')
              FilledButton.icon(
                onPressed: () => context.push('/orders/$orderId/tracking'),
                icon: const Icon(Icons.location_on),
                label: const Text('Ver en Mapa'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(PedidoModel order, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado del Pedido',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(order.estadoNombre),
                    size: 64,
                    color: _getStatusColor(order.estadoNombre),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    order.estadoNombre.replaceAll('_', ' '),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(order.estadoNombre),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(PedidoModel order, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de Entrega',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de Pedido',
              _formatDate(order.fechaPedido),
              theme,
            ),
            const SizedBox(height: 12),
              _buildInfoRow(
              Icons.access_time,
              'Entrega Estimada',
              order.fechaEntregaEstimada != null 
                  ? _formatDate(order.fechaEntregaEstimada!)
                  : 'Pendiente',
              theme,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              'Dirección',
              order.direccionEntrega,
              theme,
            ),
            if (order.repartidorNombre != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.delivery_dining,
                'Repartidor',
                order.repartidorNombre!,
                theme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(PedidoModel order, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items del Pedido',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...order.detalles.map((detalle) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_pizza,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detalle.pizzaNombre ?? 'Pizza',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cantidad: ${detalle.cantidad}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Precio: \$${detalle.precioUnitario.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${detalle.subtotal.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummaryCard(PedidoModel order, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Pago',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildPriceRow('Subtotal', order.total, theme), // Assuming subtotal = total for now
            const SizedBox(height: 8),
            _buildPriceRow('Envío', 0.0, theme), // Assuming free shipping or included
            const Divider(height: 24),
            _buildPriceRow('Total', order.total, theme, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, ThemeData theme,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : theme.textTheme.bodyMedium,
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE':
        return Icons.schedule;
      case 'CONFIRMADO':
        return Icons.check_circle_outline;
      case 'EN_PREPARACION':
        return Icons.restaurant;
      case 'LISTO':
        return Icons.done_all;
      case 'EN_CAMINO':
        return Icons.delivery_dining;
      case 'ENTREGADO':
        return Icons.check_circle;
      case 'CANCELADO':
        return Icons.cancel;
      default:
        return Icons.info;
      }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'CONFIRMADO':
        return Colors.blue;
      case 'EN_PREPARACION':
        return Colors.purple;
      case 'LISTO':
        return Colors.teal;
      case 'EN_CAMINO':
        return Colors.indigo;
      case 'ENTREGADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
