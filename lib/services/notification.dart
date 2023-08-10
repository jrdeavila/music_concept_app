import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationService {
  static Future<void> sendMessage({
    required String accountRef,
    required String title,
    required String body,
  }) async {
    var token = await getNotificationToken(accountRef);
    if (token != null) {
      // ? : Esta funcionando correctamente?
      await FirebaseMessaging.instance.sendMessage(
        to: token,
        data: {
          "title": title,
          "body": body,
        },
        messageId: "1234",
      );
    }
  }

  static Future<String?> getNotificationToken(String accountRef) async {
    var query = await FirebaseFirestore.instance.doc(accountRef).get();
    return query.data()?["notificationToken"];
  }

  static Future<void> saveNotificationToken(String uid) async {
    var notificationToken = await FirebaseMessaging.instance.getToken();
    if (notificationToken == null) return;
    await FirebaseFirestore.instance
        .doc(uid)
        .update({"notificationToken": notificationToken});
  }
}
