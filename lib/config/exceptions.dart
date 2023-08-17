import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HandlerException {
  static void handler(Object e, StackTrace? stackTrace) {
    if (e is FirebaseException) {
      SnackbarUtils.onFirebaseException(e.code);
    }

    if (e is MessageException) {
      SnackbarUtils.onException(e.message);
    }
    if (e is DioException && e.type == DioExceptionType.cancel) {
      // No hacer nada
    } else {
      SnackbarUtils.onException(e.toString());
    }
  }
}

class MessageException implements Exception {
  final String message;

  MessageException(this.message);

  @override
  String toString() {
    return message;
  }
}

const firebaseMessages = {
  "invalid-email": "Email inválido",
  "user-disabled": "Usuário desabilitado",
  "user-not-found": "Usuário no encontrado",
  "wrong-password": "Contraseña incorrecta",
  "email-already-in-use": "Email ya en uso",
  "operation-not-allowed": "Operación no permitida",
  "weak-password": "Contraseña débil",
  "unknown": "Error desconocido",
  "failed-precondition": "Precondición fallida",
};

abstract class SnackbarUtils {
  static void showSnackbar({
    required String message,
    required String label,
    void Function()? onPressed,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }

  static void onException(String message) {
    showSnackbar(
      message: message,
      label: "OK",
    );
  }

  static void onFirebaseException(String code) {
    showSnackbar(
      message: firebaseMessages[code] ?? code,
      label: "OK",
    );
  }
}
