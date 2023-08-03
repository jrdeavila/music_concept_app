import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class RegisterBussinessCtrl extends GetxController {
  final RxString _email = RxString("");
  final RxString _password = RxString("");
  final RxString _name = RxString("");
  final RxString _address = RxString("");
  final RxString _category = RxString("");
  final Rx<Uint8List?> _image = Rx<Uint8List?>(null);

  final RxList<String> categories = RxList<String>([]);

  @override
  void onReady() {
    super.onReady();
    AppConfigService.bussinessCategories.listen((event) {
      categories.value = event;
    });
  }

  void setEmail(String value) => _email.value = value;
  void setPassword(String value) => _password.value = value;
  void setName(String value) => _name.value = value;
  void setImage(Uint8List? value) => _image.value = value;
  void setAddress(String value) => _address.value = value;
  void setCategory(String value) => _category.value = value;

  void submit() {
    UserAccountService.createAccount(
      email: _email.value.trim(),
      password: _password.value.trim(),
      name: _name.value.trim(),
      address: _address.value.trim(),
      category: _category.value.trim(),
      image: _image.value,
      type: UserAccountType.bussiness,
    );
  }
}
