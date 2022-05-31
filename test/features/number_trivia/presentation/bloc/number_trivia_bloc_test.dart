import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/error/failures.dart';
import 'package:numbers_trivia_app/core/usecases/usecase.dart';
import 'package:numbers_trivia_app/core/util/input_converter.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeParams extends Fake implements Params {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUpAll(() {
    registerFallbackValue(FakeParams());
  });

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

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        build: () {
          mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
          mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
          mockInputConverter = MockInputConverter();
          numberTriviaBloc = NumberTriviaBloc(
            concrete: mockGetConcreteNumberTrivia,
            random: mockGetRandomNumberTrivia,
            inputConverter: mockInputConverter,
          );
          when(() => mockInputConverter.stringToUnsignedInteger(numberString))
              .thenReturn(const Right(numberParse));
          when(() => mockGetConcreteNumberTrivia(any()))
              .thenAnswer((_) async => const Right(numberTrivia));
          return numberTriviaBloc;
        },
        act: (bloc) => numberTriviaBloc.add(const GetTriviaForConcreteNumberEvent(numberString)),
        verify: (_) {
          verify(() => mockInputConverter.stringToUnsignedInteger(numberString)).called(1);
        });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        mockInputConverter = MockInputConverter();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockInputConverter.stringToUnsignedInteger(numberString))
            .thenReturn(Left(InvalidInputFailure()));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(const GetTriviaForConcreteNumberEvent(numberString)),
      expect: () => <NumberTriviaState>[const Error(message: invalidInputFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        mockInputConverter = MockInputConverter();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockInputConverter.stringToUnsignedInteger(numberString))
            .thenReturn(const Right(numberParse));
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(numberTrivia));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(const GetTriviaForConcreteNumberEvent(numberString)),
      verify: (_) => mockGetConcreteNumberTrivia(const Params(number: numberParse)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        mockInputConverter = MockInputConverter();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockInputConverter.stringToUnsignedInteger(numberString))
            .thenReturn(const Right(numberParse));
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(numberTrivia));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(const GetTriviaForConcreteNumberEvent(numberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        const Loaded(trivia: numberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        mockInputConverter = MockInputConverter();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockInputConverter.stringToUnsignedInteger(numberString))
            .thenReturn(const Right(numberParse));
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(const GetTriviaForConcreteNumberEvent(numberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        const Error(message: serverFailureMessage),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        mockInputConverter = MockInputConverter();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockInputConverter.stringToUnsignedInteger(numberString))
            .thenReturn(const Right(numberParse));
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(const GetTriviaForConcreteNumberEvent(numberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        const Error(message: cacheFailureMessage),
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );

    const numberTrivia = NumberTrivia(text: 'test', number: 1);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the random use case',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockGetRandomNumberTrivia(const NoParams()))
            .thenAnswer((_) async => const Right(numberTrivia));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(GetTriviaForRandomNumberEvent()),
      verify: (_) => mockGetRandomNumberTrivia(const NoParams()),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockGetRandomNumberTrivia(const NoParams()))
            .thenAnswer((_) async => const Right(numberTrivia));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(GetTriviaForRandomNumberEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        const Loaded(trivia: numberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockGetRandomNumberTrivia(const NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(GetTriviaForRandomNumberEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        const Error(message: serverFailureMessage),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
        mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
        numberTriviaBloc = NumberTriviaBloc(
          concrete: mockGetConcreteNumberTrivia,
          random: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter,
        );
        when(() => mockGetRandomNumberTrivia(const NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
        return numberTriviaBloc;
      },
      seed: () => Empty(),
      act: (bloc) => numberTriviaBloc.add(GetTriviaForRandomNumberEvent()),
      expect: () => <NumberTriviaState>[
        Loading(),
        const Error(message: cacheFailureMessage),
      ],
    );
  });
}
