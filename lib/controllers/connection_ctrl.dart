import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ConnectionCtrl extends GetxController {
  final _connectivityResult = Rx<bool?>(null);
  final RxString _lastRoute = "/".obs;

  @override
  void onReady() {
    super.onReady();
    _checkConnection();
    _checkInternetAccess();
  }

  void _checkConnection() {
    _connectivityResult.listen((p0) {
      if (!p0!) {
        Get.delete<AuthenticationCtrl>();
        if (Get.currentRoute != "/not-wifi") {
          _lastRoute.value = Get.currentRoute;
          Get.offAndToNamed("/not-wifi");
        }
      } else {
        Get.put(AuthenticationCtrl());
        if (Get.currentRoute == "/not-wifi") {
          Get.offAllNamed(_lastRoute.value);
        }
      }
    });
  }

  void _checkInternetAccess() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final result = await Process.run('ping', ['-c', '1', 'google.com']);

        if (result.exitCode == 0) {
          // Ping exitoso, hay internet
          _connectivityResult.value = true;
        } else {
          // No hay internet
          _connectivityResult.value = false;
        }
      } catch (e) {
        // No hay internet
        _connectivityResult.value = false;
      }
    });
  }
}
