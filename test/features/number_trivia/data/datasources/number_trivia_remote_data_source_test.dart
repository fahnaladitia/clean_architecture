import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/network/http_client.mocks.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(''' should perform get requet on a URL with number 
        being the end point and with application/json header ''', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async => http.Response(fixture('trivia.json'), 200));
      // act
      await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(
        mockHttpClient.get(
          Uri.parse(
            '${NumberTriviaRemoteDataSourceImpl.baseUrl}/$tNumber',
          ),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async => http.Response(fixture('trivia.json'), 200));
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(''' should perform get requet on a URL with number 
        being the end point and with application/json header ''', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async => http.Response(fixture('trivia.json'), 200));
      // act
      await dataSource.getRandomNumberTrivia();
      // assert
      verify(
        mockHttpClient.get(
          Uri.parse(
            '${NumberTriviaRemoteDataSourceImpl.baseUrl}/random',
          ),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((realInvocation) async => http.Response(fixture('trivia.json'), 200));
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw a ServerException when the response code is 404 or other', () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
