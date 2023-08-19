import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class NotificationCtrl extends GetxController {
  final RxInt _notificationCount = RxInt(0);
  final RxList<RemoteMessage> _notifications = RxList<RemoteMessage>([]);
  int get notificationCount => _notificationCount.value;

  @override
  void onReady() {
    super.onReady();
    FirebaseMessaging.onMessage.listen((event) {
      _notificationCount.value++;
      _notifications.add(event);
      SnackbarUtils.showBanner(
        title: event.notification?.title ?? "",
        message: event.notification?.body ?? "",
        label: "OK",
      );
    });
  }
}
