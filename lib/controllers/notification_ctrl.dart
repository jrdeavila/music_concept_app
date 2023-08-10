import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

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
    });
    _notifications.listen((p0) {
      print(p0.first.notification?.body);
    });
  }
}
