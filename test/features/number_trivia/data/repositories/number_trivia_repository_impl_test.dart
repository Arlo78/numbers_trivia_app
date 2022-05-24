import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
  NumberTriviaRepositoryImpl repositoryImpl;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  group('device is online', () {
    const number = 1;
    const numberTriviaModel = NumberTriviaModel(number: number, text: 'test');
    const NumberTrivia numberTrivia = numberTriviaModel;

    test('should return remote data when the call to the remote data source is successful',
        () async {
      mockNetworkInfo = MockNetworkInfo();
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(number))
          .thenAnswer((_) async => numberTriviaModel);

      final result = await repositoryImpl.getConcreteNumberTrivia(number);

      expect(result, const Right(numberTrivia));
      verify(() => mockRemoteDataSource.getConcreteNumberTrivia(number));
      verify(() => mockNetworkInfo.isConnected);
    });
  });

  //TODO
  group('device is offline', () {
    mockNetworkInfo = MockNetworkInfo();

    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  });
}
