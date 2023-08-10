import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LikesCommentsService {
  static Stream<QuerySnapshot<Map<String, dynamic>>> getComments({
    required String postRef,
  }) {
    return FirebaseFirestore.instance
        .doc(postRef)
        .collection("comments")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  static Future<void> commentCommentable({
    required String accountRef,
    required String commentableRef,
    required String content,
  }) {
    return FirebaseFirestore.instance
        .doc(commentableRef)
        .collection("comments")
        .add({
      "accountRef": accountRef,
      "content": content,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteComment({
    required String postRef,
    required String commentRef,
  }) {
    return FirebaseFirestore.instance
        .doc(postRef)
        .collection("comments")
        .doc(commentRef)
        .delete();
  }

  static Stream<int> countComments({
    required String commentableRef,
  }) {
    return FirebaseFirestore.instance
        .doc(commentableRef)
        .collection("comments")
        .snapshots()
        .map(
          (event) => event.docs.length,
        );
  }

  static Future<void> likeLikeable({
    required String accountRef,
    required String likeableRef,
  }) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      FirebaseFirestore.instance
          .doc(likeableRef)
          .collection("likes")
          .doc(accountRef)
          .set({
        "accountRef": accountRef,
        "createdAt": FieldValue.serverTimestamp(),
      });
    });
  }

  static Future<void> dislikeLikeable({
    required String accountRef,
    required String likeableRef,
  }) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      FirebaseFirestore.instance
          .doc(likeableRef)
          .collection("likes")
          .doc(accountRef)
          .delete();
    });
  }

  static Stream<int> countLikes({
    required String likeableRef,
  }) {
    return FirebaseFirestore.instance
        .doc(likeableRef)
        .collection("likes")
        .snapshots()
        .map(
          (event) => event.docs.length,
        );
  }

  static Stream<bool> isLiked({
    required String accountRef,
    required String likeableRef,
  }) {
    return FirebaseFirestore.instance
        .doc(likeableRef)
        .collection("likes")
        .where("accountRef", isEqualTo: accountRef)
        .snapshots()
        .map((event) => event.docs.isNotEmpty);
  }
}
