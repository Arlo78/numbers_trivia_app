import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(number: 1, text: 'test');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, numberTriviaModel);
    });
  });
}
