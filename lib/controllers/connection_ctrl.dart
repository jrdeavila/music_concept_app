import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ConnectionCtrl extends GetxController {
  final _connectivity = Connectivity();
  final Rx<ConnectivityResult?> _connectivityResult = Rx(null);

  @override
  void onReady() {
    super.onReady();
    _connectivityResult.bindStream(_connectivity.onConnectivityChanged);
    _checkConnection();
  }

  void _checkConnection() {
    _connectivityResult.listen((p0) {
      if (p0 == ConnectivityResult.none) {
        Get.delete<AuthenticationCtrl>();
        Get.offAndToNamed("/not-wifi");
      } else {
        Get.put(AuthenticationCtrl());
        Get.put(AppModeCtrl());
        Get.put(NotificationCtrl());
        Get.lazyPut(() => LoginCtrl());
        Get.lazyPut(() => RegisterCtrl());
        Get.lazyPut(() => ResetPasswordCtrl());
        Get.lazyPut(() => RegisterBussinessCtrl());
        Get.lazyPut(() => FanPageCtrl());
        Get.offAllNamed("/");
      }
    });
  }
}
