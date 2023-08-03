import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppModeCtrl extends GetxController {
  final RxBool _isNormalMode = RxBool(true);

  bool get isNormalMode => _isNormalMode.value;

  @override
  void onReady() {
    super.onReady();
    _isNormalMode.value = GetStorage().read("isNormalMode") ?? true;
    _isNormalMode.listen((event) {
      GetStorage().write("isNormalMode", event);
    });
  }

  void toggleMode() {
    _isNormalMode.value = !_isNormalMode.value;
  }
}
