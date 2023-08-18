import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:music_concept_app/lib.dart';

class CreateEventCtrl extends GetxController {
  final RxString _content = "".obs;
  final Rx<DateTime> _startDate = Rx(DateTime.now());
  final Rx<LatLng?> _point = Rx(null);
  final Rx<PostVisibility> _visibility = Rx(PostVisibility.public);
  final RxBool _isUploading = false.obs;

  String get content => _content.value;
  DateTime get startDate => _startDate.value;
  LatLng? get point => _point.value;
  PostVisibility get visibility => _visibility.value;
  bool get isUploading => _isUploading.value;

  void setContent(String value) => _content.value = value;
  void setStartDate(DateTime? value) =>
      _startDate.value = value ?? DateTime.now();
  void setPoint(LatLng? value) => _point.value = value;
  void setVisibility(PostVisibility value) => _visibility.value = value;

  @override
  void onReady() {
    super.onReady();
    _point.bindStream(_getCurrentPoint());
  }

  Stream<LatLng?> _getCurrentPoint() {
    return Geolocator.getPositionStream().map(
      (event) => LatLng(
        event.latitude,
        event.longitude,
      ),
    );
  }

  void submit() async {
    _isUploading.value = true;
    EventService.createEvent(
      accountRef: "users/${FirebaseAuth.instance.currentUser!.uid}",
      content: _content.validateEmpty(),
      point: _point.validateNull(label: "Ubicacion"),
      startDate: _startDate.validateNull(
        label: "Fecha de programacion",
      ),
    );
    _isUploading.value = false;
    Get.back();
  }
}

class EventCtrl extends GetxController {
  Stream<int> getCountAssist({
    required String eventRef,
  }) =>
      EventService.countAssistOnEvent(eventRef: eventRef);

  Stream<bool> hasAssistOnEvent({
    required String eventRef,
  }) {
    return EventService.hasAssistOnEvent(
      accountRef: "users/${FirebaseAuth.instance.currentUser!.uid}",
      eventRef: eventRef,
    );
  }

  Future<void> assistEvent({
    required String eventRef,
  }) {
    return EventService.createEventAssist(
      accountRef: "users/${FirebaseAuth.instance.currentUser!.uid}",
      eventRef: eventRef,
    );
  }

  Future<void> deleteAssistEvent({
    required String eventRef,
  }) {
    return EventService.deleteEventAssist(
      accountRef: "users/${FirebaseAuth.instance.currentUser!.uid}",
      eventRef: eventRef,
    );
  }
}
