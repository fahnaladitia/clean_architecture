import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
