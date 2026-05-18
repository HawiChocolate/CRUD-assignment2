import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../features/food/data/datasources/food_remote_datasource.dart';
import '../features/food/data/repositories/food_repository_impl.dart';
import '../features/food/domain/repositories/food_repository.dart';
import '../features/food/presentation/bloc/food_bloc.dart';
import 'dio_client.dart';

final sl = GetIt.instance;

void setupDI() {
  // Dio
  sl.registerSingleton<Dio>(DioClient.createDio());

  // Datasource
  sl.registerSingleton<FoodRemoteDatasource>(
    FoodRemoteDatasourceImpl(dio: sl()),
  );

  // Repository
  sl.registerSingleton<FoodRepository>(
    FoodRepositoryImpl(datasource: sl()),
  );

  // BLoC — factory so each page gets a fresh instance
  sl.registerFactory<FoodBloc>(
    () => FoodBloc(repository: sl()),
  );
}
