import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ActivityCtrl extends GetxController {
  Timer? _timer;
  final _duration = 1.minutes;

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _sendInactivityState();
      } else {
        resetTimer();
      }
    });
  }

  void _sendInactivityState([bool status = true]) {
    UserAccountService.saveActiveStatus(
      FirebaseAuth.instance.currentUser!.uid,
      active: status,
    );
  }

  void resetTimer() {
    _sendInactivityState();
    _timer?.cancel();
    _timer = Timer(_duration, () {
      _sendInactivityState(false);
    });
  }
}
