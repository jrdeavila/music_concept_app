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
    return Column(
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
              icon: MdiIcons.magnify,
              onTap: () => Get.find<HomeCtrl>().goToSearch(),
            ),
            const SizedBox(width: 10.0),
            Obx(() {
              var count = Get.find<NotificationCtrl>().notificationCount;
              return HomeAppBarAction(
                selected: true,
                child: Center(
                  child: Stack(
                    children: [
                      const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            MdiIcons.bell,
                          )),
                      if (count > 0)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Get.theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                      if (count > 0)
                        Positioned(
                          top: 13,
                          right: 13,
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            }),
            const SizedBox(width: 10.0),
            HomeAppBarAction(
              selected: true,
              icon: MdiIcons.message,
              onTap: () {},
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder(
                  stream: Get.find<PostCtrl>().reedPost(),
                  initialData: const [],
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        ...(snapshot.data!).map((e) {
                          return PostItem(
                            snapshot: e,
                            isReed: true,
                          );
                        }).toList(),
                        const SizedBox(
                          height: 100.0,
                        )
                      ],
                    );
                  })),
        ),
      ],
    );
  }
}
