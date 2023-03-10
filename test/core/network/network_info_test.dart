import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/network/network_info.mocks.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test('should forward the call to Connectivity', () async {
      final connectionResult = Future.value(ConnectivityResult.mobile);
      final tHasConnectionFuture = await connectionResult != ConnectivityResult.none;
      // arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) => connectionResult);

      // act
      final result = await networkInfo.isConnected;

      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, tHasConnectionFuture);
    });
  });
}
