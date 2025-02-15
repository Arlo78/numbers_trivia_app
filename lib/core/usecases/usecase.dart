import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:numbers_trivia_app/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
