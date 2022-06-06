import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:numbers_trivia_app/core/network/network_info.dart';
import 'package:numbers_trivia_app/core/util/input_converter.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/domain/usecases/get_random_year_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //Features - Number Trivia - registered as Factory because is the only one who needs to save the state or has to do with streams
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      inputConverter: serviceLocator(),
      concrete: serviceLocator(),
      random: serviceLocator(),
      year: serviceLocator(),
    ),
  );

  //Use cases - singleton
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetRandomYearTrivia(serviceLocator()));

  //Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      httpClient: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

  //Core
  serviceLocator.registerLazySingleton(() => InputConverter());

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      serviceLocator(),
    ),
  );

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerLazySingleton(() => http.Client());

  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
