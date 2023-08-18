import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_concept_app/lib.dart';

enum PostVisibility {
  public,
  followers,
  private,
}

abstract class PostService {
  static Future<void> createPost(
      {required String? accountRef,
      required String content,
      Uint8List? image,
      required PostVisibility visibility}) async {
    assert(accountRef != null);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final imagePath = image != null
          ? await FirebaseStorageService.uploadFile(
              path: "posts/$accountRef/",
              fileName: DateTime.now().millisecondsSinceEpoch.toString(),
              fileExtension: "jpg",
              fileData: base64.encode(image),
              format: PutStringFormat.base64,
              metadata: SettableMetadata(
                contentType: "image/jpeg",
              ),
            )
          : null;
      await FirebaseFirestore.instance.collection('posts').add({
        'accountRef': accountRef,
        'visibility': visibility.index,
        'content': content,
        'image': imagePath,
        'createdAt': FieldValue.serverTimestamp(),
        'deletedAt': null,
        "type": "post"
      });
    });
  }

  static Future<void> deletePost(String postId) async {
    return FirebaseFirestore.instance.doc(postId).update({
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<int> getAccountPostsCount(String? accountRef) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where("deletedAt", isNull: true)
        .where('accountRef', isEqualTo: accountRef)
        .snapshots()
        .map((event) => event.docs.length);
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getAccountPosts(
    String accountRef,
  ) {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((e) {
      final docs = e.docs
          .where((element) =>
              element['deletedAt'] == null &&
              element['accountRef'] == accountRef)
          .toList();
      return docs;
    });
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getAccountFollowingPost(String accountRef) async* {
    final following = await FirebaseFirestore.instance
        .collection("follows")
        .where("followerRef", isEqualTo: accountRef)
        .get();

    final followingRefs = following.docs.map<String>((e) => e['followingRef']);

    yield* FirebaseFirestore.instance
        .collection('posts')
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((e) {
      final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      for (final ref in followingRefs) {
        docs.addAll(e.docs.where((element) =>
            element['accountRef'] == ref &&
            element['deletedAt'] == null &&
            element['visibility'] != PostVisibility.private.index));
      }
      return docs;
    });
  }
}