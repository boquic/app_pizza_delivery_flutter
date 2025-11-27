import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/storage/auth_storage.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/cart/data/datasources/cart_remote_datasource.dart';
import 'features/catalog/data/datasources/pizza_api_datasource.dart';
import 'features/catalog/data/datasources/pizza_mock_datasource.dart';
import 'features/catalog/data/repositories/pizza_repository_impl.dart';
import 'features/catalog/domain/repositories/pizza_repository.dart';

final getIt = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación
///
/// [useMockData] - Si es true, usa datos mock en lugar de la API real.
/// Útil para desarrollo sin backend.
Future<void> initDependencies({bool useMockData = true}) async {
  // SharedPreferences (necesario para AuthStorage)
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Storage
  getIt.registerLazySingleton<AuthStorage>(
    () => AuthStorage(getIt<SharedPreferences>()),
  );

  // Core - DioClient con AuthStorage
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(authStorage: getIt<AuthStorage>()),
  );

  // Auth DataSource (necesario para authProvider)
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  // Cart DataSource (necesario para cartProvider)
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  if (useMockData) {
    // 🎭 Modo MOCK - Usar datos mock para desarrollo
    getIt
      ..registerLazySingleton(PizzaMockDataSource.new)
      ..registerLazySingleton<PizzaApiDataSource>(
        () => getIt<PizzaMockDataSource>(),
      )
      ..registerLazySingleton<PizzaRepository>(
        () => PizzaRepositoryImpl(getIt<PizzaApiDataSource>()),
      );
  } else {
    // 🌐 Modo API REAL - Usar API backend
    getIt
      ..registerLazySingleton<PizzaApiDataSource>(
        () => PizzaApiDataSourceImpl(dioClient: getIt<DioClient>()),
      )
      ..registerLazySingleton<PizzaRepository>(
        () => PizzaRepositoryImpl(getIt<PizzaApiDataSource>()),
      );
  }
}
