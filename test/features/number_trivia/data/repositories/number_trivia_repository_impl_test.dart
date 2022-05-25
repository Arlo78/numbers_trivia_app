import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/error/exceptions.dart';
import 'package:numbers_trivia_app/core/error/failures.dart';
import 'package:numbers_trivia_app/core/platform/network_info.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  group('getConcreteNumberTrivia', () {
    const number = 1;
    const numberTriviaModel = NumberTriviaModel(number: number, text: 'test trivia');
    const NumberTrivia numberTrivia = numberTriviaModel;

    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(number))
              .thenAnswer((_) async => numberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel))
              .thenAnswer((_) async {});

          final result = await repository.getConcreteNumberTrivia(number);

          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(() => mockNetworkInfo.isConnected);
          expect(result, equals(const Right(numberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(number))
              .thenAnswer((_) async => numberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel))
              .thenAnswer((_) async {});

          await repository.getConcreteNumberTrivia(number);

          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(number))
              .thenThrow(ServerException());

          final result = await repository.getConcreteNumberTrivia(number);

          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number));
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);

          final result = await repository.getConcreteNumberTrivia(number);

          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(numberTrivia)));
        },
      );

      test(
        'should return cache failure when there is no cached data present',
        () async {
          when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          final result = await repository.getConcreteNumberTrivia(number);

          verifyNever(() => mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const numberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    const NumberTrivia numberTrivia = numberTriviaModel;

    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel))
              .thenAnswer((_) async {});

          final result = await repository.getRandomNumberTrivia();

          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(() => mockNetworkInfo.isConnected);
          expect(result, equals(const Right(numberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel))
              .thenAnswer((_) async {});

          await repository.getRandomNumberTrivia();

          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

          final result = await repository.getRandomNumberTrivia();

          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyNever(() => mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(() => mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);

          final result = await repository.getRandomNumberTrivia();

          verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(const Right(numberTrivia)));
        },
      );

      test(
        'should return cache failure when there is no cached data present',
        () async {
          when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          final result = await repository.getRandomNumberTrivia();

          verifyNever(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
