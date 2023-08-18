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
    final ctrl = Get.find<FanPageCtrl>();
    return Obx(() {
      return Stack(
        children: [
          _fanPageView(),
          if (ctrl.isSearching) _searchView(),
        ],
      );
    });
  }

  Widget _fanPageView() {
    final ctrl = Get.find<FanPageCtrl>();
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
              onTap: () => ctrl.setSearching(true),
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
                        ProfileTabBar(
                          children: [
                            ProfileTabBarItem(
                              label: 'Explorar',
                              icon: MdiIcons.compass,
                              selected: true,
                              onTap: () {},
                            ),
                            ProfileTabBarItem(
                              label: 'Descubrir',
                              icon: MdiIcons.musicNote,
                              selected: false,
                              onTap: () {},
                            ),
                          ],
                        ),
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

  Container _searchView() {
    final ctrl = Get.find<FanPageCtrl>();
    return Container(
      color: Get.theme.colorScheme.background,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            leadingWidth: 76,
            leading: HomeAppBarAction(
              selected: true,
              icon: MdiIcons.arrowLeft,
              onTap: () => ctrl.setSearching(false),
            ),
            titleSpacing: 0,
            title: LoginRoundedTextField(
              label: "Buscar ...",
              onChanged: ctrl.setSearchText,
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = ctrl.searchResult[index].data();
                  final hasAddress = data!['address'] != null;
                  return ListTile(
                    onTap: () {
                      ctrl.setSelectedAccount(
                          ctrl.searchResult[index].reference);
                      ctrl.setSearching(false);
                      PageChangeNotification(1).dispatch(context);
                      Get.find<PostCtrl>().setSelectedAccount(
                          ctrl.searchResult[index].reference.path);
                    },
                    leading: ProfileImage(
                      image: data['image'],
                      name: data['name'],
                    ),
                    title: Text(data['name']),
                    subtitle: hasAddress ? Text(data['address']) : null,
                  );
                },
                itemCount: ctrl.searchResult.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}
