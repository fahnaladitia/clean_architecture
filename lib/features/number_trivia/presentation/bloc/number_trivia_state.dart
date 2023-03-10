part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaEmpty extends NumberTriviaState {}

class NumberTriviaError extends NumberTriviaState {
  final String message;
  const NumberTriviaError({
    required this.message,
  });

  @override
  String toString() => 'NumberTriviaError(message: $message)';
}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  const NumberTriviaLoaded({
    required this.numberTrivia,
  });

  @override
  String toString() => 'NumberTriviaLoaded(numberTrivia: $numberTrivia)';
}
