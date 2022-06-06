import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required String text, required int number, int? year})
      : super(text: text, number: number, year: year);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
      year: json['year'] != null ? (json['year'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
      'year': year,
    };
  }
}
