import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

void main() {
  Get.put(ConnectionCtrl());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppDefaults.titleName,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initialRoute,
      darkTheme: ColorPalete.themeData,
      themeMode: ThemeMode.dark,
    );
  }
}
