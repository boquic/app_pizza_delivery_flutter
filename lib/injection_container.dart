import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'features/catalog/data/datasources/pizza_mock_datasource.dart';
import 'features/catalog/data/datasources/pizza_remote_datasource.dart';
import 'features/catalog/data/repositories/pizza_repository_impl.dart';
import 'features/catalog/data/repositories/pizza_repository_mock_impl.dart';
import 'features/catalog/domain/repositories/pizza_repository.dart';

final getIt = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación
Future<void> initDependencies({bool useMockData = true}) async {
  // Core
  getIt.registerLazySingleton(DioClient.new);

  if (useMockData) {
    // Usar datos mock para desarrollo
    getIt
      ..registerLazySingleton(PizzaMockDataSource.new)
      ..registerLazySingleton<PizzaRepository>(
        () => PizzaRepositoryMockImpl(getIt<PizzaMockDataSource>()),
      );
  } else {
    // Usar API real
    getIt
      ..registerLazySingleton<PizzaRemoteDataSource>(
        () => PizzaRemoteDataSourceImpl(getIt<DioClient>().dio),
      )
      ..registerLazySingleton<PizzaRepository>(
        () => PizzaRepositoryImpl(getIt<PizzaRemoteDataSource>()),
      );
  }
}
