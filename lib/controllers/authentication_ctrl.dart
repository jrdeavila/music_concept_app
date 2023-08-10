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
        _saveNotificationToken(p0.uid);
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
    _firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  void _saveNotificationToken(String uid) async {
    await NotificationService.saveNotificationToken("users/$uid");
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
    FirebaseAuth.instance.signOut();
  }
}
