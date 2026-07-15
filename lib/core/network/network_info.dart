// Network Info - Connectivity abstraction
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@injectable
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));

  Future<ConnectivityResult> get connectionType async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  bool get isWifi => connectionType.then((type) => type == ConnectivityResult.wifi) as bool;
  bool get isMobile => connectionType.then((type) => type == ConnectivityResult.mobile) as bool;
  bool get isEthernet => connectionType.then((type) => type == ConnectivityResult.ethernet) as bool;
  bool get isVpn => connectionType.then((type) => type == ConnectivityResult.vpn) as bool;
}