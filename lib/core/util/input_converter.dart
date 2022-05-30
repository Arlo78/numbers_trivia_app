import 'package:dartz/dartz.dart';
import 'package:numbers_trivia_app/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String string) {
    try {
      final integer = int.parse(string);

      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
