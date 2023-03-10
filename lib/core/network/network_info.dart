import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);
  @override
  Future<bool> get isConnected async {
    final connectResult = await connectivity.checkConnectivity();
    if (connectResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}
