import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/usuario_model.dart';
import '../../../../injection_container.dart';
import '../../../../core/storage/auth_storage.dart';
import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/models/agregar_item_request_model.dart';
import '../../data/models/carrito_model.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// Estado del carrito
class CartState {
  final CarritoModel? cart;
  final bool isLoading;
  final String? error;

  CartState({
    this.cart,
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    CarritoModel? cart,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get itemCount => cart?.items.length ?? 0;
  double get total => cart?.total ?? 0.0;
}

/// Notifier para gestionar el estado del carrito
class CartNotifier extends StateNotifier<CartState> {
  final CartRemoteDataSource _cartDataSource;
  final AuthStorage _authStorage;

  CartNotifier(this._cartDataSource, this._authStorage) : super(CartState()) {
    loadCart();
  }

  /// Cargar el carrito del usuario
  Future<void> loadCart() async {
    if (!_authStorage.hasToken()) {
      if (mounted) state = state.copyWith(cart: null, isLoading: false);
      return;
    }

    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await _cartDataSource.getCarrito();
      if (mounted) state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// Agregar item al carrito
  Future<void> addItem({
    required int pizzaId,
    required int cantidad,
    List<int>? ingredientesPersonalizadosIds,
    String? notas,
  }) async {
    if (!_authStorage.hasToken()) {
      if (mounted) state = state.copyWith(error: 'Debes iniciar sesión para agregar al carrito');
      return;
    }

    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      final request = AgregarItemRequestModel(
        pizzaId: pizzaId,
        cantidad: cantidad,
        ingredientesPersonalizadosIds: ingredientesPersonalizadosIds,
        notas: notas,
      );

      final updatedCart = await _cartDataSource.agregarItem(request);
      if (mounted) state = state.copyWith(cart: updatedCart, isLoading: false);
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

  /// Eliminar item del carrito
  Future<void> removeItem(int itemId) async {
    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedCart = await _cartDataSource.eliminarItem(itemId);
      if (mounted) state = state.copyWith(cart: updatedCart, isLoading: false);
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

  /// Limpiar el carrito
  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cartDataSource.limpiarCarrito();
      state = state.copyWith(
        cart: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Refrescar el carrito
  Future<void> refresh() => loadCart();
}

/// Provider del carrito
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  // Observar cambios en la autenticación para recargar el carrito al iniciar sesión
  ref.watch(authProvider);
  
  return CartNotifier(
    getIt<CartRemoteDataSource>(),
    getIt<AuthStorage>(),
  );
});
