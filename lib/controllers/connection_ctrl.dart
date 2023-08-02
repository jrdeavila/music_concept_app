import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionCtrl extends GetxController {
  final _connectivity = Connectivity();
  final Rx<ConnectivityResult?> _connectivityResult = Rx(null);

  @override
  void onReady() {
    super.onReady();
    _checkConnection();
    _connectivityResult.bindStream(_connectivity.onConnectivityChanged);
  }

  void _checkConnection() {
    _connectivityResult.listen((p0) {
      if (p0 == ConnectivityResult.none) {
        Get.offAndToNamed("/not-wifi");
      } else {
        Get.offNamed("/");
      }
    });
  }
}
