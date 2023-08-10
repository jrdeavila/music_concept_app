import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class PostCtrl extends GetxController {
  final Rx<String?> _selectedAccountRef = Rx<String?>("");
  final RxString _content = ''.obs;
  final Rx<Uint8List?> _image = Rx<Uint8List?>(null);
  final Rx<PostVisibility> _visibility = PostVisibility.public.obs;
  final RxBool _isUploading = false.obs;
  final RxList<DocumentSnapshot<Map<String, dynamic>>> profilePosts = RxList();
  final RxList<DocumentSnapshot<Map<String, dynamic>>> profileSurveys =
      RxList();
  final RxList<DocumentSnapshot<Map<String, dynamic>>> reedPosts = RxList();

  String get content => _content.value;
  Uint8List? get image => _image.value;
  PostVisibility get visibility => _visibility.value;
  bool get isUploading => _isUploading.value;

  void setContent(String content) {
    _content.value = content;
  }

  void setImage(Uint8List? image) {
    _image.value = image;
  }

  void setVisibility(PostVisibility visibility) {
    _visibility.value = visibility;
  }

  void setSelectedAccount(String? accountRef) {
    _selectedAccountRef.value = accountRef;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAccountRef(
      String accountRef) {
    return FirebaseFirestore.instance.doc(accountRef).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOptions(String surveyId) {
    return SurveyService.getSurveyOptions(surveyId);
  }

  Stream<int> getOptionAnswerCount({
    required String surveyRef,
    required String optionRef,
  }) {
    return SurveyService.getOptionAnswerCount(
        optionRef: optionRef, surveyRef: surveyRef);
  }

  Stream<bool> accountHasAnswerOption({
    required String optionRef,
    required String surveyRef,
  }) {
    return SurveyService.hasOptionAnswer(
      surveyRef: surveyRef,
      optionRef: optionRef,
      accountRef: "users/${FirebaseAuth.instance.currentUser?.uid}",
    );
  }

  Stream<bool> accountLikedPost({
    required String postRef,
  }) {
    return LikesCommentsService.isLiked(
      accountRef: FirebaseAuth.instance.currentUser!.uid,
      likeableRef: postRef,
    );
  }

  Stream<int> countLikesPost({
    required String postRef,
  }) {
    return LikesCommentsService.countLikes(
      likeableRef: postRef,
    );
  }

  Stream<int> getTopOption(String surveyRef) {
    return SurveyService.getTopOption(surveyRef);
  }

  Stream<int> countCommentsPost({
    required String postRef,
  }) {
    return LikesCommentsService.countComments(commentableRef: postRef);
  }

  @override
  void onReady() {
    super.onReady();

    _selectedAccountRef.listen((event) {
      profilePosts.value = [];
      if (event != null) {
        PostService.getAccountPosts(event).listen(_loadPost);
      } else {
        PostService.getAccountPosts(
          "users/${FirebaseAuth.instance.currentUser!.uid}",
        ).listen(_loadPost);
      }

      PostService.getAccountFollowingPost(
        "users/${FirebaseAuth.instance.currentUser!.uid}",
      ).listen((event) {
        reedPosts.value = event.docs;
      });
    });

    _selectedAccountRef.value = null;
  }

  void _loadPost(event) {
    profilePosts.value =
        event.docs.where((e) => e.data()['type'] != 'survey').toList();
    profileSurveys.value =
        event.docs.where((e) => e.data()['type'] == 'survey').toList();
  }

  void deletePost(String postRef) {
    PostService.deletePost(postRef);
  }

  void submit() async {
    final accountRef = "users/${FirebaseAuth.instance.currentUser!.uid}";
    _isUploading.value = true;
    await PostService.createPost(
      accountRef: accountRef,
      content: content,
      image: image,
      visibility: visibility,
    );
    _isUploading.value = false;
    Get.back();
  }

  void createSurveyAnwser({
    required String surveyRef,
    required String optionRef,
  }) {
    SurveyService.createOptionAnswer(
      surveyRef: surveyRef,
      optionRef: optionRef,
      accountRef: "users/${FirebaseAuth.instance.currentUser?.uid}",
    );
  }

  void deleteSurveyAnwser({
    required String surveyRef,
    required String optionRef,
  }) {
    SurveyService.deleteOptionAnswer(
      surveyRef: surveyRef,
      optionRef: optionRef,
      accountRef: "users/${FirebaseAuth.instance.currentUser?.uid}",
    );
  }

  void changeSurveyAnswer({
    required String surveyRef,
    required String optionRef,
  }) {
    SurveyService.changeOptionAnswer(
      surveyRef: surveyRef,
      optionRef: optionRef,
      accountRef: "users/${FirebaseAuth.instance.currentUser?.uid}",
    );
  }

  void likePost({required String postRef}) {
    LikesCommentsService.likeLikeable(
      accountRef: FirebaseAuth.instance.currentUser!.uid,
      likeableRef: postRef,
    );
  }

  void dislikePost({required String postRef}) {
    LikesCommentsService.dislikeLikeable(
      accountRef: FirebaseAuth.instance.currentUser!.uid,
      likeableRef: postRef,
    );
  }
}

final postOptions = {
  PostVisibility.public: {
    "label": "Publico",
    "icon": MdiIcons.earth,
  },
  PostVisibility.followers: {
    "label": "Seguidores",
    "icon": MdiIcons.accountMultiple,
  },
  PostVisibility.private: {
    "label": "Privado",
    "icon": MdiIcons.lock,
  }
};

IconData getVisibilityIcon(int? index) {
  switch (index) {
    case 0:
      return MdiIcons.earth;
    case 1:
      return MdiIcons.accountMultiple;
    case 2:
      return MdiIcons.lock;
    default:
      return MdiIcons.earth;
  }
}
