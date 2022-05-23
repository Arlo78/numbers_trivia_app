import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  test('should get trivia for the number from the repository ', () async {
    const number = 1;
    const numberTrivia = NumberTrivia(number: 1, text: 'test');
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(number))
        .thenAnswer((_) async => const Right(numberTrivia));

    final result = await usecase.execute(number: number);

    expect(result, const Right(numberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(number));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
