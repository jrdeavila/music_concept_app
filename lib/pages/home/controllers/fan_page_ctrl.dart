import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class FanPageCtrl extends GetxController {
  final PageController pageCtrl = PageController();

  final RxString _searchText = RxString('');
  final RxBool _isSearching = RxBool(false);
  final RxInt _currentPage = RxInt(0);

  final Rx<DocumentReference<Map<String, dynamic>>?> _currentAccount =
      Rx<DocumentReference<Map<String, dynamic>>?>(null);

  RxList<DocumentSnapshot<Map<String, dynamic>>> searchResult =
      RxList<DocumentSnapshot<Map<String, dynamic>>>();

  int get currentPage => _currentPage.value;
  String get searchText => _searchText.value;
  bool get isSearching => _isSearching.value;
  DocumentReference<Map<String, dynamic>>? get currentAccount =>
      _currentAccount.value;

  void setSearchText(String value) => _searchText.value = value;
  void setSearching(bool value) => _isSearching.value = value;

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.userChanges().listen((user) {
      _currentAccount.value =
          user != null ? UserAccountService.getUserAccountRef(user.uid) : null;
    });
    ever(_searchText, _onSearch);
    ever(_currentPage, _onPageChange);
  }

  void _onPageChange(int page) {
    pageCtrl.animateToPage(
      page,
      duration: 500.milliseconds,
      curve: Curves.easeInOut,
    );
  }

  void _onSearch(String value) async {
    var result = await UserAccountService.searchAccounts(searchText);
    searchResult.value = result.docs;
  }

  void goToProfile() {
    _currentPage.value = 1;
  }

  void goToReed() {
    _currentPage.value = 0;
  }

  void goToGuestProfile(DocumentSnapshot<Map<String, dynamic>> guest) {
    if (guest.reference.path != currentAccount?.path) {
      Get.toNamed(AppRoutes.guestProfile, arguments: guest);
    } else {
      goToProfile();
    }
  }
}
