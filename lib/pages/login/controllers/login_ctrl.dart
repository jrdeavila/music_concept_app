import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class LoginCtrl extends GetxController {
  final RxString _email = RxString("");
  final RxString _password = RxString("");

  void setEmail(String value) => _email.value = value;
  void setPassword(String value) => _password.value = value;

  void submit() {
    Get.find<AuthenticationCtrl>().login(
      email: _email.value.trim(),
      password: _password.value.trim(),
    );
  }
}

class RegisterCtrl extends GetxController {
  final RxString _email = RxString("");
  final RxString _password = RxString("");
  final RxString _name = RxString("");
  final Rx<Uint8List?> _image = Rx<Uint8List?>(null);

  void setEmail(String value) => _email.value = value;
  void setPassword(String value) => _password.value = value;
  void setName(String value) => _name.value = value;
  void setImage(Uint8List? value) => _image.value = value;

  void submit() {
    UserAccountService.createAccount(
      email: _email.value.trim(),
      password: _password.value.trim(),
      name: _name.value.trim(),
      image: _image.value,
    );
  }
}

class ResetPasswordCtrl extends GetxController {
  final RxString _email = RxString("");

  void setEmail(String value) => _email.value = value;

  void submit() {
    Get.find<AuthenticationCtrl>().resetPassword(
      email: _email.value.trim(),
    );
    Get.back();
  }
}
