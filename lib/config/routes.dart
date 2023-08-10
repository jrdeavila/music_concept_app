import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

abstract class AppRoutes {
  // Rutas del cliente
  static const String login = "/login";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";

  // Rutas del negocio
  static const String businessRegister = "/business-register";
  static const String createSurvey = "/create-survey";

  static const String home = "/home";
  static const String notWifi = "/not-wifi";
  static const String root = "/";
  static const String postDetails = "/post-details";

  static const String initialRoute = "/";
  static final Map<String, Widget Function(BuildContext context)> routes = {
    root: (context) => const WelcomePage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    businessRegister: (context) => const RegisterBussinessPage(),
    createSurvey: (context) => const CreateSurvePage(),
    postDetails: (context) => ShowPostDetailsPage(post: Get.arguments),
    resetPassword: (context) => const ResetPasswordPage(),
    home: (context) => const HomePage(),
    notWifi: (context) => const NoWifiCoonnectionPage(),
  };
}
