import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:numbers_trivia_app/core/error/failures.dart';
import 'package:numbers_trivia_app/core/usecases/usecase.dart';
import 'package:numbers_trivia_app/core/util/constants.dart';
import 'package:numbers_trivia_app/core/util/input_converter.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_date_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_year_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final GetRandomYearTrivia year;
  final GetRandomDateTrivia date;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.year,
    required this.date,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumberEvent>(_getConcreteNumberTrivia);
    on<GetTriviaForRandomNumberEvent>(_getRandomNumberTrivia);
    on<GetTriviaForRandomYearEvent>(_getRandomYearTrivia);
    on<GetTriviaForRandomDateEvent>(_getRandomDateTrivia);
  }

  NumberTriviaState get initialState => Empty();

  Future<void> _getConcreteNumberTrivia(
    GetTriviaForConcreteNumberEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
    await inputEither.fold(
      (failure) async => emit(const Error(message: invalidInputFailureMessage)),
      (integer) async {
        emit(Loading());
        final failureOrTrivia = await concrete(Params(number: integer));
        _getFailureOrTrivia(failureOrTrivia, emit);
      },
    );
  }

  Future<void> _getRandomNumberTrivia(
    GetTriviaForRandomNumberEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final failureOrTrivia = await random(const NoParams());
    _getFailureOrTrivia(failureOrTrivia, emit);
  }

  Future<void> _getRandomYearTrivia(
    GetTriviaForRandomYearEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final failureOrTrivia = await year(const NoParams());
    _getFailureOrTrivia(failureOrTrivia, emit);
  }

  Future<void> _getRandomDateTrivia(
    GetTriviaForRandomDateEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final failureOrTrivia = await date(const NoParams());
    _getFailureOrTrivia(failureOrTrivia, emit);
  }

  void _getFailureOrTrivia(
      Either<Failure, NumberTrivia> failureOrTrivia, Emitter<NumberTriviaState> emit) {
    return failureOrTrivia.fold(
      (failure) async => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) async => emit(Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return "Unexpected Error";
    }
  }
}
