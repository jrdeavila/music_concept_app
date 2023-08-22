import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:music_concept_app/lib.dart';

class Coordinates {
  final double latitude;
  final double longitude;
  const Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      latitude: map["latitude"],
      longitude: map["longitude"],
    );
  }
}

abstract class BusinessService {
  Future<List<FdSnapshot>> searchBusinessNearly({
    required Coordinates coordinates,
    required double radius,
  });

  Future<void> createBusinessVisit({
    required String accountRef,
    required String businessRef,
  });
}

class MainBusinessService implements BusinessService {
  @override
  Future<List<FdSnapshot>> searchBusinessNearly(
      {required Coordinates coordinates, required double radius}) async {
    final query = await FirebaseFirestore.instance
        .collection("users")
        .where(
          "type",
          isEqualTo: UserAccountType.business.index,
        )
        .get();

    return query.docs.where((element) {
      var point = element.data()['location'] as GeoPoint?;
      if (point == null) {
        return false;
      }
      return Geolocator.distanceBetween(
            point.latitude,
            point.longitude,
            coordinates.latitude,
            coordinates.longitude,
          ) <
          radius;
    }).toList();
  }

  @override
  Future<void> createBusinessVisit({
    required String accountRef,
    required String businessRef,
  }) async {
    var query = await FirebaseFirestore.instance
        .collection("business_visits")
        .where("accountRef", isEqualTo: accountRef)
        .where("businessRef", isEqualTo: businessRef)
        .get();
    var haveToDay = query.docs.any((element) {
      var createdAt = (element["createdAt"] as Timestamp).toDate();
      var diff = createdAt.difference(DateTime.now()).inDays;
      return diff == 0;
    });
    if (!haveToDay) {
      await FirebaseFirestore.instance.collection("business_visits").add({
        "accountRef": accountRef,
        "businessRef": businessRef,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }
}
