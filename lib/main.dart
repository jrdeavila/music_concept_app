import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_concept_app/lib.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('es', timeago.EsMessages());
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  Get.put(AuthenticationCtrl());
  Get.put(ConnectionCtrl());
  Get.put(AppModeCtrl());
  Get.put(NotificationCtrl());
  Get.lazyPut(() => LoginCtrl());
  Get.lazyPut(() => RegisterCtrl());
  Get.lazyPut(() => ResetPasswordCtrl());
  Get.lazyPut(() => RegisterBussinessCtrl());
  Get.lazyPut(() => FanPageCtrl());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppDefaults.titleName,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initialRoute,
      theme: ColorPalete.themeData,
    );
  }
}
