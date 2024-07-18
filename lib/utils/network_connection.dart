import 'dart:io';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnection {
  NetworkConnection._();

  static final instance = NetworkConnection._();
  final Connectivity _connectivity = Connectivity();

  final _controller = StreamController.broadcast();

  Stream get myStream => _controller.stream;

  void initialize() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }

    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
