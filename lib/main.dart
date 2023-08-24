import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:music_concept_app/lib.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      WidgetsBinding.instance.addObserver(LifeCycleObserver());
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

      initializeDateFormatting('es');
      timeago.setLocaleMessages('es', timeago.EsMessages());

      // Services - SOLID
      Get.put<BusinessService>(MainBusinessService());

      Get.put(AuthenticationCtrl());
      Get.put(ConnectionCtrl());
      Get.put(AppModeCtrl());
      Get.put(LocationCtrl());
      Get.put(NotificationCtrl());
      Get.put(BusinessNearlyCtrl());
      Get.put(ActivityCtrl());
      Get.lazyPut(() => LoginCtrl());
      Get.lazyPut(() => RegisterCtrl());
      Get.lazyPut(() => ResetPasswordCtrl());
      Get.lazyPut(() => RegisterBussinessCtrl());
      Get.lazyPut(() => HomeCtrl());

      runApp(const MyApp());
    },
    HandlerException.handler,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale("es"),
      debugShowCheckedModeBanner: false,
      title: AppDefaults.titleName,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initialRoute,
      theme: ColorPalete.themeData,
    );
  }
}
