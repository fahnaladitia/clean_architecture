import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  static const baseUrl = "http://numbersapi.com";

  NumberTriviaRemoteDataSourceImpl(this.client);
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _fetchNumberTriviaFromPath('/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _fetchNumberTriviaFromPath('/random');
  }

  Future<NumberTriviaModel> _fetchNumberTriviaFromPath(String path) async {
    try {
      final response = (await client.get(
        Uri.parse("$baseUrl$path"),
        headers: {'Content-Type': 'application/json'},
      ));

      final jsonString = json.decode(response.body);
      return NumberTriviaModel.fromJson(jsonString);
    } catch (e) {
      throw ServerException();
    }
  }
}
