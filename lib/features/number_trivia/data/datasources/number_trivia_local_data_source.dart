import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const kTriviaCachedNumberTrivia = "CACHED_NUMBER_TRIVIA";

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async =>
      sharedPreferences.setString(kTriviaCachedNumberTrivia, json.encode(triviaToCache.toJson()));

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(kTriviaCachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(
        NumberTriviaModel.fromJson(json.decode(jsonString) as Map<String, dynamic>),
      );
    }
    throw CacheException();
  }
}
