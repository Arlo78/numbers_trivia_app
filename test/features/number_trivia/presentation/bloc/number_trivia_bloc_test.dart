import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/util/input_converter.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  test('initialState should be Empty', () {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );

    expect(numberTriviaBloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
    const numberString = '1';
    const numberParse = 1;
    const numberTrivia = NumberTrivia(text: 'test', number: 1);
  });
}
