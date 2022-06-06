import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;
  final int? year;

  const NumberTrivia({
    required this.text,
    required this.number,
    this.year,
  });

  @override
  List<Object?> get props => [
        text,
        number,
        year,
      ];
}
