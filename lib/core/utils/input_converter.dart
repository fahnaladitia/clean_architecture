import 'package:clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<InputConverter>()])
class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer.isNegative) throw const FormatException();
      return Right(integer);
    } catch (e) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
