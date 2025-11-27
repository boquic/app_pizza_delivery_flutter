import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/catalog/presentation/pages/pizza_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/orders/presentation/pages/checkout_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/order_history_page.dart';
import '../../features/orders/presentation/pages/order_tracking_page.dart';

/// Notifier para escuchar cambios en la autenticación y notificar al router
class RouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  RouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _authNotifier.state;
    final isAuthenticated = authState.isAuthenticated;
    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';
    final isSplash = state.matchedLocation == '/';
    final isCatalog = state.matchedLocation.startsWith('/catalog');

    // Rutas públicas: login, register, splash, catalog (y sus subrutas)
    if (isLoggingIn || isRegistering || isSplash || isCatalog) {
      // Si está autenticado y trata de ir a login/register/splash, ir a catalog
      if (isAuthenticated && (isLoggingIn || isRegistering || isSplash)) {
        return '/catalog';
      }
      return null;
    }

    // Rutas protegidas: cart, orders, profile, checkout, admin
    if (!isAuthenticated) {
      return '/login';
    }

    return null;
  }
}

/// Provider para el router de la aplicación
final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  final routerNotifier = RouterNotifier(authNotifier);

  return GoRouter(
    initialLocation: '/catalog',
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main App Routes (Protected)
      GoRoute(
        path: '/catalog',
        name: 'catalog',
        builder: (context, state) => const CatalogPage(),
        routes: [
          // Pizza Detail
          GoRoute(
            path: 'pizza/:id',
            name: 'pizza-detail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return PizzaDetailPage(pizzaId: id);
            },
          ),
        ],
      ),

      // Cart
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),

      // Checkout
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),

      // Orders
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrderHistoryPage(),
        routes: [
          // Order Detail
          GoRoute(
            path: ':id',
            name: 'order-detail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return OrderDetailPage(orderId: id);
            },
            routes: [
              // Order Tracking
              GoRoute(
                path: 'tracking',
                name: 'order-tracking',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return OrderTrackingPage(orderId: id);
                },
              ),
            ],
          ),
        ],
      ),

      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // Admin Routes (Protected - Admin only)
      GoRoute(
        path: '/admin',
        name: 'admin',
        redirect: (context, state) {
          final user = ref.read(authProvider).user;
          if (user?.rol != 'ADMIN') {
            return '/catalog';
          }
          return null;
        },
        builder: (context, state) => const Placeholder(), // TODO: Implement AdminDashboardPage
        routes: [
          // Admin Pizzas
          GoRoute(
            path: 'pizzas',
            name: 'admin-pizzas',
            builder: (context, state) => const Placeholder(), // TODO: Implement AdminPizzasPage
            routes: [
              // Create/Edit Pizza
              GoRoute(
                path: 'form',
                name: 'admin-pizza-form',
                builder: (context, state) {
                  final pizzaId = state.uri.queryParameters['id'];
                  return Placeholder(); // TODO: Implement AdminPizzaFormPage
                },
              ),
            ],
          ),
          // Admin Orders
          GoRoute(
            path: 'orders',
            name: 'admin-orders',
            builder: (context, state) => const Placeholder(), // TODO: Implement AdminOrdersPage
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/catalog'),
              child: const Text('Ir al Catálogo'),
            ),
          ],
        ),
      ),
    ),
  );
});
