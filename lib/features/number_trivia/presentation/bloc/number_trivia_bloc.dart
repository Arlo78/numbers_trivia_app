import 'package:bloc/bloc.dart';
import 'package:numbers_trivia_app/core/util/input_converter.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {});
  }

  NumberTriviaState get initialState => Empty();
}
