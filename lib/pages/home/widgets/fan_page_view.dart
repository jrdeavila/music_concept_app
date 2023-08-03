import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class FanPageView extends StatelessWidget {
  const FanPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(
            title: const Text(AppDefaults.titleName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                )),
            actions: [
              HomeAppBarAction(
                selected: true,
                icon: MdiIcons.bell,
                onTap: () {},
              ),
              const SizedBox(width: 10.0),
              HomeAppBarAction(
                selected: true,
                icon: MdiIcons.message,
                onTap: () {},
              ),
              const SizedBox(width: 16.0),
            ],
          )
        ],
      ),
    );
  }
}
