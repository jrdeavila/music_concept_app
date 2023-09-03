import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ProfileCtrl extends GetxController {
  final RxList<String> wallpapers = RxList();
  final Rx<String?> _selectedWallpaper = Rx<String?>(null);

  String? get selectedWallpaper => _selectedWallpaper.value;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAccountStream(
      [String? accountRef]) {
    return UserAccountService.getUserAccountDoc(
      accountRef ?? "users/${FirebaseAuth.instance.currentUser?.uid}",
    ).snapshots();
  }

  Stream<List<String>> getFollowingInCurrentVisit({
    required String? accountRef,
  }) =>
      BusinessService.getFollingInCurrentVisit(
        accountRef:
            accountRef ?? "users/${FirebaseAuth.instance.currentUser!.uid}",
      );

  Stream<List<FdSnapshot>> getBusinessVisits({
    required String? accountRef,
  }) =>
      BusinessService.getBusinessVisits(
        accountRef:
            accountRef ?? "users/${FirebaseAuth.instance.currentUser!.uid}",
      );

  Stream<bool> isAFriend({
    required String accountRef,
  }) {
    return FollowingFollowersServices.accountIsFriend(
        accountRef: accountRef,
        userRef: "users/${FirebaseAuth.instance.currentUser!.uid}");
  }

  @override
  void onReady() {
    super.onReady();
    _loadWallpapers();
    _selectedWallpaper.listen((value) {
      BackgroundService.setBackground(
        "users/${FirebaseAuth.instance.currentUser?.uid}",
        value,
      );
    });
  }

  Stream<int> getFollowersCount(String? accountRef) {
    return FollowingFollowersServices.getFollowersCount(accountRef);
  }

  Stream<int> getFollowingCount(String? accountRef) {
    return FollowingFollowersServices.getFollowingCount(accountRef);
  }

  Stream<int> getPostsCount(String? accountRef) {
    return PostService.getAccountPostsCount(accountRef);
  }

  Stream<bool> isFollowing({
    required String followerRef,
    required String followingRef,
  }) {
    return FollowingFollowersServices.isFollowing(
      followerRef: followerRef,
      followingRef: followingRef,
    );
  }

  void follows({
    required String followerRef,
    required String followingRef,
  }) {
    FollowingFollowersServices.followAccount(
      followerRef: followerRef,
      followingRef: followingRef,
    );
  }

  void unfollow({
    required String followerRef,
    required String followingRef,
  }) {
    FollowingFollowersServices.unfollowAccount(
      followerRef: followerRef,
      followingRef: followingRef,
    );
  }

  void selectWallpaper(String? wallpaper) {
    _selectedWallpaper.value = wallpaper;
  }

  void _loadWallpapers() async {
    // Lee el contenido de la carpeta "assets/images"
    String manifestContent = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Recorre el mapa para obtener la lista de imágenes
    for (String key in manifestMap.keys) {
      if (key.contains('assets/wallpapers')) {
        wallpapers.add(key);
      }
    }
  }
}

final accountOptions = {
  'settings-profile': {
    "label": "Configuración de la cuenta",
    "icon": MdiIcons.accountCog,
    "onTap": () {},
  },
  'settings-app': {
    "label": "Configuración de la aplicación",
    "icon": MdiIcons.cog,
    "onTap": () {
      Get.toNamed(AppRoutes.settings);
    },
  },
};

int accountTypeIndex(UserAccountType type) {
  return UserAccountType.values.indexOf(type);
}
