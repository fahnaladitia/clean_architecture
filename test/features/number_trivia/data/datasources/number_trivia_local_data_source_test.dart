import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/database/shared_preferences.mocks.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTrivialModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences
          .getString(NumberTriviaLocalDataSourceImpl.kTriviaCachedNumberTrivia));
      expect(result, equals(tNumberTrivialModel));
    });

    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = dataSource.getLastNumberTrivia;
      // assert

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    const tNumberTrivialModel = NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cached the data', () async {
      // act
      dataSource.cacheNumberTrivia(tNumberTrivialModel);

      // assert
      final expectedJsonString = json.encode(tNumberTrivialModel.toJson());
      verify(
        mockSharedPreferences.setString(
          NumberTriviaLocalDataSourceImpl.kTriviaCachedNumberTrivia,
          expectedJsonString,
        ),
      );
    });
  });
}
