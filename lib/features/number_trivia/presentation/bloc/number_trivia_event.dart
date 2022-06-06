import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([String? numberString]);
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumberEvent(this.numberString) : super(numberString);

  @override
  List<Object?> get props => [numberString];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}

class GetTriviaForRandomYearEvent extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}
