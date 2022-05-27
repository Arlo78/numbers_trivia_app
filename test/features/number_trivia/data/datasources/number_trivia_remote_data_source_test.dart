import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/error/exceptions.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint '
      'and with application/json header',
      () async {
        mockHttpClient = MockHttpClient();
        dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

        dataSource.getConcreteNumberTrivia(tNumber);

        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {
                'Content-Type': 'application/json',
              },
            ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200',
      () async {
        mockHttpClient = MockHttpClient();
        dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        mockHttpClient = MockHttpClient();
        dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response('Something went wrong', 404));

        final call = dataSource.getConcreteNumberTrivia;

        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should perform a GET request on a URL with number being the endpoint '
      'and with application/json header',
      () async {
        mockHttpClient = MockHttpClient();
        dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

        dataSource.getRandomNumberTrivia();

        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/random'),
              headers: {
                'Content-Type': 'application/json',
              },
            ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200',
      () async {
        mockHttpClient = MockHttpClient();
        dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

        final result = await dataSource.getRandomNumberTrivia();

        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        mockHttpClient = MockHttpClient();
        dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer((_) async => http.Response('Something went wrong', 404));

        final call = dataSource.getRandomNumberTrivia;

        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
