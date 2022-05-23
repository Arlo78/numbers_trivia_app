import 'package:dartz/dartz.dart';
import 'package:numbers_trivia_app/core/error/failures.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
