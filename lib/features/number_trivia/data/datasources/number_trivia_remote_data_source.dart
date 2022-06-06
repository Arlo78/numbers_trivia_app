import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:numbers_trivia_app/core/error/exceptions.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
  Future<NumberTriviaModel> getRandomYearTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  @override
  Future<NumberTriviaModel> getRandomYearTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random/year');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await httpClient.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
