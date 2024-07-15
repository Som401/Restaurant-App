import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkStatusService {
  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  NetworkStatusService() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _networkStatusController.add(_getNetworkStatus(result));
      print('Connectivity changed: $result');
    });
  }

  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;

  NetworkStatus _getNetworkStatus(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.none)
        ? NetworkStatus.offline
        : NetworkStatus.online;
  }

  void dispose() {
    _networkStatusController.close();
  }
}
