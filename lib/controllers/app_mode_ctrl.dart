import 'package:get/get.dart';

class AppModeCtrl extends GetxController {
  final RxBool _isNormalMode = RxBool(true);

  bool get isNormalMode => _isNormalMode.value;

  void toggleMode() {
    _isNormalMode.value = !_isNormalMode.value;
  }
}
