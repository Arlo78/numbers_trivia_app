import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:numbers_trivia_app/core/usecases/usecase.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/usecases/get_random_date_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetRandomDateTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  test('should get random date trivia from the repository ', () async {
    const randomDateTrivia = NumberTrivia(number: 1, text: 'test');
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomDateTrivia(mockNumberTriviaRepository);

    when(() => mockNumberTriviaRepository.getRandomDateTrivia())
        .thenAnswer((_) async => const Right(randomDateTrivia));

    final result = await usecase(const NoParams());

    expect(result, const Right(randomDateTrivia));
    verify(() => mockNumberTriviaRepository.getRandomDateTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
