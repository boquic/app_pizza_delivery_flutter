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
  Future<bool> addItem({
    required int pizzaId,
    required int cantidad,
    List<int>? ingredientesPersonalizadosIds,
    String? notas,
  }) async {
    if (!_authStorage.hasToken()) {
      if (mounted) {
        state = state.copyWith(
          error: 'Debes iniciar sesión para agregar al carrito',
        );
      }
      return false;
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
      if (mounted) {
        state = state.copyWith(cart: updatedCart, isLoading: false);
      }
      return true;
    } catch (e) {
      String errorMessage = 'Error al agregar al carrito';
      
      if (e.toString().contains('403')) {
        errorMessage = 'Error de autenticación. Por favor, vuelve a iniciar sesión.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Error del servidor. Intenta nuevamente más tarde.';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Pizza no encontrada.';
      }
      
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );
      }
      return false;
    }
  }

  /// Eliminar item del carrito
  Future<void> removeItem(int itemId) async {
    if (!_authStorage.hasToken()) {
      throw Exception('Debes iniciar sesión');
    }

    // Guardar el estado actual del carrito antes de eliminar
    final currentCart = state.cart;
    
    if (currentCart == null) {
      throw Exception('No hay carrito para eliminar items');
    }
    
    // Actualización optimista: eliminar el item de la UI inmediatamente
    final optimisticItems = currentCart.items.where((item) => item.id != itemId).toList();
    final optimisticTotal = optimisticItems.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );
    
    final optimisticCart = currentCart.copyWith(
      items: optimisticItems,
      total: optimisticTotal,
    );
    
    if (mounted) {
      state = state.copyWith(
        cart: optimisticCart,
        isLoading: false,
        error: null,
      );
    }
    
    print('🗑️ Eliminando item con ID: $itemId (optimistic update aplicado)');

    try {
      // Llamar al backend para eliminar el item
      final updatedCart = await _cartDataSource.eliminarItem(itemId);
      
      print('✅ Item eliminado en backend. Items restantes: ${updatedCart.items.length}');
      
      // Actualizar el estado con la respuesta real del backend
      if (mounted) {
        state = state.copyWith(
          cart: updatedCart,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      print('❌ Error al eliminar item: $e');
      
      // Revertir el cambio optimista en caso de error
      if (mounted && currentCart != null) {
        state = state.copyWith(
          cart: currentCart,
          isLoading: false,
          error: null,
        );
      }
      
      String errorMessage = 'Error al eliminar item';
      
      if (e.toString().contains('404') || e.toString().contains('no encontrado')) {
        errorMessage = 'Item no encontrado';
        // Intentar recargar el carrito para sincronizar
        try {
          await loadCart();
          return; // No lanzar excepción si logramos recargar
        } catch (_) {}
      } else if (e.toString().contains('401') || e.toString().contains('autenticado')) {
        errorMessage = 'Sesión expirada. Por favor, vuelve a iniciar sesión.';
      }
      
      throw Exception(errorMessage);
    }
  }

  /// Limpiar el carrito
  Future<void> clearCart() async {
    if (mounted) state = state.copyWith(isLoading: true, error: null);

    try {
      await _cartDataSource.limpiarCarrito();
      // Recargar el carrito para obtener el estado actualizado del backend
      await loadCart();
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
