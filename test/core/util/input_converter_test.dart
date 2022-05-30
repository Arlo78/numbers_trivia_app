import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia_app/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  group('stringToUnsignedInteger', () {
    inputConverter = InputConverter();

    test('should return an integer when the string represents an unsigned integer', () async {
      const numberString = '123';

      final result = inputConverter.stringToUnsignedInteger(numberString);

      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an integer', () async {
      const numberString = 'abc';

      final result = inputConverter.stringToUnsignedInteger(numberString);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is a negative integer', () async {
      const numberString = '-123';

      final result = inputConverter.stringToUnsignedInteger(numberString);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
