import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_concept_app/lib.dart';

abstract class UserAccountService {
  static Future<void> createUserAccount({
    required String email,
    required String password,
    required String name,
    required Uint8List? image,
  }) async {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user!;
      user.sendEmailVerification();
      final id = user.uid;

      final imagePath = image != null
          ? await FirebaseStorageService.uploadFile(
              path: "users",
              fileName: "avatar",
              fileExtension: "jpg",
              fileData: base64.encode(image),
              format: PutStringFormat.base64,
              metadata: SettableMetadata(
                contentType: "image/jpeg",
              ),
            )
          : null;

      transaction.set(FirebaseFirestore.instance.collection("users").doc(id), {
        "name": name,
        "email": email,
        "image": imagePath,
      });
    });
  }

  static DocumentReference<Map<String, dynamic>> getUserAccountRef(String? id) {
    return FirebaseFirestore.instance.collection("users").doc(id);
  }
}
