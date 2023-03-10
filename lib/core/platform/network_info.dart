import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
