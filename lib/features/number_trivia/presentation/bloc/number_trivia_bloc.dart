import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String kServerFailureMessage = 'Server Failure';
const String kCacheFailureMessage = 'Cache Failure';
const String kInvalidFailureMessage =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaEmpty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      emit(NumberTriviaLoading());
      final inputEither = inputConverter.stringToUnsignedInteger(event.number);
      await inputEither.fold(
        (failure) async {
          if (failure is InvalidInputFailure) {
            emit(const NumberTriviaError(message: kInvalidFailureMessage));
          }
        },
        (number) async => await _fetchNumberTrivia(
          () => getConcreteNumberTrivia(Params(number: number)),
          emit,
        ),
      );
    });
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(NumberTriviaLoading());
      await _fetchNumberTrivia(
        () async => getRandomNumberTrivia(),
        emit,
      );
    });
  }
  Future<void> _fetchNumberTrivia(
    Future<Either<Failure, NumberTrivia>> Function() onFetch,
    Emitter<NumberTriviaState> emit,
  ) async {
    final result = await onFetch();

    emit(result.fold(
      (failure) => NumberTriviaError(message: _mapFailureToMessage(failure)),
      (numberTrivia) => NumberTriviaLoaded(numberTrivia: numberTrivia),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return kServerFailureMessage;
      case CacheFailure:
        return kCacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
