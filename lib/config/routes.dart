import 'package:flutter/material.dart';
import 'package:music_concept_app/lib.dart';

abstract class AppRoutes {
  static const String initialRoute = "/";
  static final Map<String, Widget Function(BuildContext context)> routes = {
    "/": (context) => const WelcomePage(),
    "/login": (context) => const LoginPage(),
    "/home": (context) => const HomePage(),
    "/not-wifi": (context) => const NoWifiCoonnectionPage(),
  };
}
