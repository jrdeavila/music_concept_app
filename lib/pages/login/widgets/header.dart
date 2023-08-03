import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    var appModeCtrl = Get.find<AppModeCtrl>();
    return Obx(() {
      return Center(
        child: Container(
          height: 250,
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(100),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Get.theme.colorScheme.onPrimary,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (!appModeCtrl.isNormalMode)
                Transform.scale(
                  scale: 0.8,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(MdiIcons.music),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Establecimiento",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(MdiIcons.music),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
