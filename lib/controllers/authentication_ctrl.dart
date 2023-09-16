import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class AuthenticationCtrl extends GetxController {
  final Rx<User?> _firebaseUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    _firebaseUser.listen((p0) {
      if (p0 != null) {
        Get.put(NotificationCtrl());
        Get.put(BusinessNearlyCtrl());
        Get.lazyPut(() => HomeCtrl());
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.delete<NotificationCtrl>();
        Get.delete<BusinessNearlyCtrl>();
        Get.delete<HomeCtrl>();
        Get.offAllNamed(AppRoutes.login);
      }
    });
    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  void login({
    required String email,
    required String password,
  }) {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  void resetPassword({
    required String email,
  }) {
    FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  }

  void logout() {
    UserAccountService.saveActiveStatus(
      _firebaseUser.value!.uid,
      active: false,
    );
    BusinessService.setCurrentVisit(
      accountRef: "users/${_firebaseUser.value!.uid}",
      businessRef: null,
    );
    FirebaseAuth.instance.signOut();
  }
}
