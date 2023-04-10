import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:insplash/feature/presentation/bloc/photos_bloc/photos_list_bloc.dart';
import 'package:insplash/feature/presentation/bloc/photos_search_bloc/photos_search_bloc.dart';

import 'core/platform/network_info.dart';
import 'feature/data/datasources/photos_remote_data_source.dart';
import 'feature/data/repositories/photos_repository_impl.dart';
import 'feature/domain/repositories/photos_repository.dart';
import 'feature/domain/usecases/get_all_photos.dart';
import 'feature/domain/usecases/search_photos.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => PhotosListBloc(getAllPhotos: sl()));
  sl.registerFactory(() => PhotosSearchBloc(searchPhotos: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllPhotos(sl()));
  sl.registerLazySingleton(() => SearchPhotos(sl()));

  // Repository
  sl.registerLazySingleton<PhotosRepository>(
    () => PhotosRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PhotosRemoteDataSource>(
    () => PhotosRemoteDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(sl()),
  );

  // External
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
