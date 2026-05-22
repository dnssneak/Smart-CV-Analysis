import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  InternetChecker._();

  static final Connectivity _connectivity = Connectivity();

  static Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}