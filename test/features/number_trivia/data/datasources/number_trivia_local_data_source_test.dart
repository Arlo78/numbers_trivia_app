import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/error/exceptions.dart';
import 'package:numbers_trivia_app/core/util/constants.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  group('getLastNumberTrivia', () {
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );

    test('should return NumberTrivia from shared preferences when there is one cached', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(fixture('trivia_cached.json'));

      final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

      verify(() => mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, numberTriviaModel);
    });

    test('should throw CacheException when there is not a cached value', () async {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      expect(
        () => numberTriviaLocalDataSourceImpl.getLastNumberTrivia(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cacheNumberTrivia', () {
    const numberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );

    test(
      'should call SharedPreferences to cache the data',
      () async {
        final expectedJsonString = json.encode(numberTriviaModel.toJson());
        when(() => mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString))
            .thenAnswer((_) => Future.value(true));

        numberTriviaLocalDataSourceImpl.cacheNumberTrivia(numberTriviaModel);

        verify(() => mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString));
      },
    );
  });
}
