import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class HomeCtrl extends GetxController {
  final PageController pageCtrl = PageController(initialPage: 1);

  final RxInt _currentPage = RxInt(1);

  int get currentPage => _currentPage.value;

  @override
  void onInit() {
    super.onInit();
    Get.put(FanPageCtrl());
    Get.put(SearchCtrl());
  }

  @override
  void onClose() {
    super.onClose();
    pageCtrl.dispose();
    Get.delete<FanPageCtrl>();
    Get.delete<SearchCtrl>();
  }

  @override
  void onReady() {
    super.onReady();

    ever(_currentPage, _onPageChange);
  }

  void _onPageChange(int page) {
    pageCtrl.animateToPage(
      page,
      duration: 500.milliseconds,
      curve: Curves.easeInOut,
    );
  }

  void goToProfile() {
    _currentPage.value = 2;
  }

  void goToReed() {
    _currentPage.value = 1;
  }

  void goToSearch() {
    _currentPage.value = 0;
  }
}

class SearchCtrl extends GetxController {
  final RxString _searchText = RxString('');
  final Rx<String?> _selectedCategory = Rx(null);
  final RxBool _isMapSearching = RxBool(false);

  RxList<DocumentSnapshot<Map<String, dynamic>>> searchResult =
      RxList<DocumentSnapshot<Map<String, dynamic>>>();
  final RxList<String> categories = RxList<String>();

  String? get currentCategory => _selectedCategory.value;

  String get searchText => _searchText.value;
  bool get isMapSearching => _isMapSearching.value;

  void setSearchText(String value) => _searchText.value = value;
  void setSelectedCategory(String? value) => _selectedCategory.value = value;
  void setMapSearching(bool value) => _isMapSearching.value = value;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? _future;

  @override
  void onReady() {
    super.onReady();
    ever(_searchText, _onSearch);
    ever(_selectedCategory, _onSearchCategory);

    categories.bindStream(AppConfigService.bussinessCategories);
  }

  void _onSearch(String value) async {
    _future?.ignore();
    _future = UserAccountService.searchAccounts(
      value,
      category: _selectedCategory.value,
    );
    var result = await _future!;
    searchResult.value = result;
  }

  void _onSearchCategory(String? value) async {
    _future?.ignore();
    _future = UserAccountService.searchAccounts(
      searchText,
      category: value,
    );
    var result = await _future!;
    searchResult.value = result;
  }

  void clearResults() {
    _searchText.value = "";
    searchResult.value = [];
  }
}

class FanPageCtrl extends GetxController {
  final Rx<DocumentReference<Map<String, dynamic>>?> _currentAccount =
      Rx<DocumentReference<Map<String, dynamic>>?>(null);

  DocumentReference<Map<String, dynamic>>? get currentAccount =>
      _currentAccount.value;

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.userChanges().listen((user) {
      _currentAccount.value =
          user != null ? UserAccountService.getUserAccountRef(user.uid) : null;
    });
  }

  void goToGuestProfile(DocumentSnapshot<Map<String, dynamic>> guest) {
    if (guest.reference.path != currentAccount?.path) {
      Get.toNamed(AppRoutes.guestProfile, arguments: guest);
    } else {
      Get.find<HomeCtrl>().goToProfile();
    }
  }
}
