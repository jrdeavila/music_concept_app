import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:music_concept_app/lib.dart';

abstract class SearchPlacesServices {
  static Future<List<Prediction>> searchPlaces({
    required String value,
    required CancelToken cancelToken,
  }) {
    return _dio
        .get(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      queryParameters: {
        'input': value,
        'key': AppDefaults.googleApiKeyPlaces,
      },
      cancelToken: cancelToken,
    )
        .then((value) {
      return (value.data['predictions'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList();
    });
  }

  static Future<PlaceDetails> searchPlaceDetails(String placeId) {
    final cancelToken = CancelToken();
    return _dio
        .get(
      'https://maps.googleapis.com/maps/api/place/details/json',
      queryParameters: {
        'place_id': placeId,
        'key': AppDefaults.googleApiKeyPlaces,
      },
      cancelToken: cancelToken,
    )
        .then(
      (value) {
        cancelToken.cancel();
        return PlaceDetails.fromJson(value.data);
      },
    );
  }

  static Future<List<PlaceDetails>> searchPlaceDetailsByLatLng(
      LatLng latLng) async {
    var cancelToken = CancelToken();
    var response = await _dio.get(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json',
      queryParameters: {
        'location': '${latLng.latitude},${latLng.longitude}',
        'radius': 150,
        'key': AppDefaults.googleApiKeyPlaces,
      },
      cancelToken: cancelToken,
    );

    cancelToken.cancel();

    List<PlaceDetails> details = [];
    for (var i in (response.data["results"] as List).getRange(1, 11)) {
      final placeDetails = await searchPlaceDetails(i["place_id"]);
      details.add(placeDetails);
    }
    return details;
  }

  static Polygon getRadiusAbovePoint({
    required LatLng center,
    required double radius,
    int points = 360,
  }) {
    final meters = radius / 100000;
    final List<LatLng> circlePoints = [];
    for (int i = 0; i < points; i++) {
      double angle = 2 * pi * i / points;
      double x = center.latitude + meters * cos(angle);
      double y = center.longitude + meters * sin(angle);
      circlePoints.add(LatLng(x, y));
    }

    return Polygon(
      polygonId: const PolygonId('radius'),
      points: circlePoints,
      strokeWidth: 2,
      strokeColor: Get.theme.colorScheme.primary,
      fillColor: Get.theme.colorScheme.primary.withOpacity(0.2),
    );
  }

  static String calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // Radio de la Tierra en metros

    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    double distance = earthRadius * c;

    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180);
  }
}

Dio _dio = Dio();
