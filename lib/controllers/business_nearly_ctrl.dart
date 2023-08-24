import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class BusinessNearlyCtrl extends GetxController {
  final RxList<FdSnapshot> businesses = RxList();
  final Rx<Coordinates?> _coordinates = Rx(null);
  final BusinessService _service = Get.find();
  final Rx<FdSnapshot?> _onYouStay = Rx(null);
  final RxBool _isAuthenticated = false.obs;
  Timer? timer;

  final double userRadius = 100.0;
  final double businessLimit = 100.0;
  final Duration _timerDuration = 10.minutes;

  @override
  void onReady() {
    super.onReady();
    _isAuthenticated.bindStream(
        FirebaseAuth.instance.userChanges().map((event) => event != null));
    _coordinates.bindStream(
      Geolocator.getPositionStream().map(
        (event) => Coordinates.fromMap(
          event.toJson(),
        ),
      ),
    );
    ever(businesses, _onStayInBusiness);
    ever(_onYouStay, _registerYouStayOnaBsns);
    ever(businesses, _notifyNearlyBusiness);

    _searchBusiness();
    _searchBusinessPeriodic();
  }

  void _notifyNearlyBusiness(p0) {
    if (p0.isNotEmpty && Get.currentRoute != AppRoutes.mapsViewBusiness) {
      SnackbarUtils.showBanner(
        title: "Estas cerca de algunos establecimientos",
        message: "Presiona el Boton 'VER' para abrir el mapa",
        label: "VER",
        onPressed: () {
          Get.closeCurrentSnackbar();
          Get.toNamed(AppRoutes.mapsViewBusiness);
        },
      );
    }
  }

  void _searchBusinessPeriodic() async {
    Timer.periodic(_timerDuration, (timer) {
      _searchBusiness();
    });
  }

  void _searchBusiness() {
    if (_coordinates.value != null && _isAuthenticated.value) {
      _service
          .searchBusinessNearly(
        coordinates: _coordinates.value!,
        radius: userRadius,
      )
          .then((value) {
        businesses.value = value;
      });
    }
  }

  // Para encontrar el establecimiento mas cercano usando [radius] como referencia
  void _onStayInBusiness(List<FdSnapshot> businesses) async {
    for (var business in businesses) {
      var point = business.data()!["location"] as GeoPoint;
      var distance = _calcDistance(point);

      if (distance < businessLimit) {
        _onYouStay.value = business;
        return;
      }
    }
  }

  // Primera revision si esta en la zona, segunda revision registra el establecimiento visitado
  void _registerYouStayOnaBsns(FdSnapshot? snapshot) {
    _service.setCurrentVisit(
      accountRef: "users/${FirebaseAuth.instance.currentUser!.uid}",
      businessRef: snapshot?.reference.path,
    );
    if (snapshot != null) {
      _service.createBusinessVisit(
        accountRef: "users/${FirebaseAuth.instance.currentUser!.uid}",
        businessRef: snapshot.reference.path,
      );
    }
  }

  double _calcDistance(GeoPoint point) {
    var distance = Geolocator.distanceBetween(
      point.latitude,
      point.longitude,
      _coordinates.value!.latitude,
      _coordinates.value!.longitude,
    );
    return distance;
  }
}
