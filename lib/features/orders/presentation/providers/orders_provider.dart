import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../data/datasources/orders_remote_datasource.dart';
import '../../data/models/crear_pedido_request_model.dart';
import '../../data/models/pedido_model.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// Estado de los pedidos
class OrdersState {
  final List<PedidoModel>? orders;
  final PedidoModel? currentOrder;
  final bool isLoading;
  final String? error;

  OrdersState({
    this.orders,
    this.currentOrder,
    this.isLoading = false,
    this.error,
  });

  OrdersState copyWith({
    List<PedidoModel>? orders,
    PedidoModel? currentOrder,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      currentOrder: currentOrder ?? this.currentOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier para gestionar pedidos
class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrdersRemoteDataSource _ordersDataSource;
  final AuthStorage _authStorage;

  OrdersNotifier(this._ordersDataSource, this._authStorage) : super(OrdersState());

  /// Crear un nuevo pedido
  Future<PedidoModel> createOrder({
    required String direccionEntrega,
    String? notas,
  }) async {
    if (!_authStorage.hasToken()) {
      throw Exception('Debes iniciar sesión para crear un pedido');
    }

    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      final request = CrearPedidoRequestModel(
        direccionEntrega: direccionEntrega,
        telefonoContacto: '000000000', // TODO: Obtener del perfil
        notas: notas,
        items: [], // TODO: Mapear items del carrito si es necesario
      );

      final order = await _ordersDataSource.crearPedido(request);
      
      if (mounted) {
        state = state.copyWith(
          currentOrder: order,
          isLoading: false,
        );
      }

      // Recargar historial
      await loadOrders();

      return order;
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
      rethrow;
    }
  }

  /// Cargar historial de pedidos
  Future<void> loadOrders() async {
    if (!_authStorage.hasToken()) {
      if (mounted) state = state.copyWith(orders: [], isLoading: false);
      return;
    }

    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await _ordersDataSource.getHistorialPedidos();
      if (mounted) {
        state = state.copyWith(
          orders: orders,
          isLoading: false,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// Obtener detalle de un pedido específico
  Future<void> loadOrderDetail(int orderId) async {
    if (!_authStorage.hasToken()) {
      if (mounted) state = state.copyWith(error: 'Debes iniciar sesión para ver el detalle');
      return;
    }

    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _ordersDataSource.getPedidoById(orderId);
      if (mounted) {
        state = state.copyWith(
          currentOrder: order,
          isLoading: false,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// Refrescar datos
  Future<void> refresh() => loadOrders();
}

/// Provider de pedidos
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  // Observar cambios en la autenticación
  ref.watch(authProvider);

  return OrdersNotifier(
    getIt<OrdersRemoteDataSource>(),
    getIt<AuthStorage>(),
  );
});
