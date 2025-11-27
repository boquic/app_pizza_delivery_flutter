import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/storage/auth_storage.dart';
import 'features/catalog/data/datasources/pizza_api_datasource.dart';
import 'features/catalog/data/repositories/pizza_repository_impl.dart';
import 'features/catalog/domain/repositories/pizza_repository.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/cart/data/datasources/cart_remote_datasource.dart';
import 'features/orders/data/datasources/orders_remote_datasource.dart';
import 'features/admin/data/datasources/admin_pizzas_datasource.dart';
import 'features/admin/data/datasources/admin_orders_datasource.dart';

final getIt = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación
Future<void> initDependencies() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Storage
  getIt.registerLazySingleton<AuthStorage>(
    () => AuthStorage(getIt<SharedPreferences>()),
  );

  // Network
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(authStorage: getIt<AuthStorage>()),
  );

  // DataSources - Catalog
  getIt.registerLazySingleton<PizzaApiDataSource>(
    () => PizzaApiDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // DataSources - Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // DataSources - Cart
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // DataSources - Orders
  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // DataSources - Admin
  getIt.registerLazySingleton<AdminPizzasDataSource>(
    () => AdminPizzasDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AdminOrdersDataSource>(
    () => AdminOrdersDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<PizzaRepository>(
    () => PizzaRepositoryImpl(getIt<PizzaApiDataSource>()),
  );
}
