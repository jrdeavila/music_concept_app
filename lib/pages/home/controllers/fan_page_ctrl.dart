import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class FanPageCtrl extends GetxController {
  final RxString _searchText = RxString('');
  final RxBool _isSearching = RxBool(false);
  final Rx<DocumentReference<Map<String, dynamic>>?> _selectedAccount =
      Rx<DocumentReference<Map<String, dynamic>>?>(null);
  final Rx<DocumentReference<Map<String, dynamic>>?> _currentAccount =
      Rx<DocumentReference<Map<String, dynamic>>?>(null);

  RxList<DocumentSnapshot<Map<String, dynamic>>> searchResult =
      RxList<DocumentSnapshot<Map<String, dynamic>>>();

  String get searchText => _searchText.value;
  bool get isSearching => _isSearching.value;
  DocumentReference<Map<String, dynamic>>? get selectedAccount =>
      _selectedAccount.value;
  DocumentReference<Map<String, dynamic>>? get currentAccount =>
      _currentAccount.value;

  void setSearchText(String value) => _searchText.value = value;
  void setSearching(bool value) => _isSearching.value = value;

  void setSelectedAccount(DocumentReference<Map<String, dynamic>>? value) =>
      _selectedAccount.value = value;

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.userChanges().listen((user) {
      _currentAccount.value =
          user != null ? UserAccountService.getUserAccountRef(user.uid) : null;
    });
    ever(_searchText, _onSearch);
    ever(_selectedAccount, _onSelectAccount);
  }

  _onSelectAccount(value) {
    if (_currentAccount.value?.id == value?.id) {
      _selectedAccount.value = null;
    }
  }

  void _onSearch(String value) async {
    var result = await UserAccountService.searchAccounts(searchText);
    searchResult.value = result.docs;
  }
}
