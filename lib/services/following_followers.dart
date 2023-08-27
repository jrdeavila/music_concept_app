import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FollowingFollowersServices {
  static Future<void> followAccount({
    required String followerRef,
    required String followingRef,
  }) async {
    final isFollowing = await FirebaseFirestore.instance
        .collection("follows")
        .where("followingRef", isEqualTo: followingRef)
        .where("followerRef", isEqualTo: followerRef)
        .get();
    if (isFollowing.docs.isNotEmpty) return;

    await FirebaseFirestore.instance.collection("follows").add({
      "followingRef": followingRef,
      "followerRef": followerRef,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> unfollowAccount({
    required String followerRef,
    required String followingRef,
  }) async {
    var query = await FirebaseFirestore.instance
        .collection("follows")
        .where("followingRef", isEqualTo: followingRef)
        .where("followerRef", isEqualTo: followerRef)
        .get();
    query.docs.first.reference.delete();
  }

  static Stream<int> getFollowersCount(String? accountRef) {
    return FirebaseFirestore.instance
        .collection("follows")
        .where("followingRef", isEqualTo: accountRef)
        .snapshots()
        .map((event) => event.docs.length);
  }

  static Stream<int> getFollowingCount(String? accountRef) {
    return FirebaseFirestore.instance
        .collection("follows")
        .where("followerRef", isEqualTo: accountRef)
        .snapshots()
        .map((event) => event.docs.length);
  }

  static Stream<bool> isFollowing({
    required String followerRef,
    required String followingRef,
  }) {
    return FirebaseFirestore.instance
        .collection("follows")
        .where("followingRef", isEqualTo: followingRef)
        .where("followerRef", isEqualTo: followerRef)
        .snapshots()
        .map((event) => event.docs.isNotEmpty);
  }

  static Future<List<String>> getFollowersRefsFuture(String accountRef) {
    return FirebaseFirestore.instance
        .collection("follows")
        .where("followingRef", isEqualTo: accountRef)
        .get()
        .then((value) => value.docs
            .map(
              (e) => e["followerRef"] as String,
            )
            .toList());
  }
}
