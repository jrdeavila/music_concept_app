import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileCtrl extends GetxController {
  final RxList<String> wallpapers = RxList();

  final Rx<String?> _selectedWallpaper = Rx<String?>(null);

  String? get selectedWallpaper => _selectedWallpaper.value;

  @override
  void onReady() {
    super.onReady();
    _loadWallpapers();
    _selectedWallpaper.value = GetStorage().read('wallpaper');
    _selectedWallpaper.listen((value) {
      GetStorage().write('wallpaper', value);
    });
  }

  void selectWallpaper(String? wallpaper) {
    _selectedWallpaper.value = wallpaper;
  }

  void _loadWallpapers() async {
    try {
      // Lee el contenido de la carpeta "assets/images"
      String manifestContent =
          await rootBundle.loadString('AssetManifest.json');
      Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Recorre el mapa para obtener la lista de imágenes
      for (String key in manifestMap.keys) {
        if (key.contains('assets/wallpapers')) {
          wallpapers.add(key);
        }
      }
    } catch (e) {}
  }
}
