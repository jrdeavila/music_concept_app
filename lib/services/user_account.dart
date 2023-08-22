import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:music_concept_app/lib.dart';

abstract class UserAccountService {
  static Future<QuerySnapshot<Map<String, dynamic>>> searchAccounts(
      String searchText) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: searchText)
        .get();
  }

  static Future<void> createAccount({
    required String email,
    required String password,
    required String name,
    required Uint8List? image,
    LatLng? location,
    String? address,
    String? category,
    UserAccountType type = UserAccountType.user,
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
        "address": address,
        "category": category,
        "type": type.index,
        "location": location != null
            ? GeoPoint(location.latitude, location.longitude)
            : null,
      });
    });
  }

  static DocumentReference<Map<String, dynamic>> getUserAccountRef(String? id) {
    return FirebaseFirestore.instance.collection("users").doc(id);
  }

  static DocumentReference<Map<String, dynamic>> getUserAccountDoc(
      String path) {
    return FirebaseFirestore.instance.doc(path);
  }
}

enum UserAccountType {
  business,
  user,
}
