import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

ScrollController profileScrollCtrl = ScrollController();

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentTab = 1;
  double _backgroundOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ProfileCtrl());

    profileScrollCtrl = ScrollController();

    profileScrollCtrl.addListener(() {
      // Ocultar cuando supere 50 px de scroll y mostrar cuando sea menor a 50 px (0.0 - 1.0) calcular
      _backgroundOpacity = 1 - (profileScrollCtrl.offset / 50).clamp(0, 1);
      setState(() {});
    });
  }

  @override
  void dispose() {
    profileScrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();
    final postCtrl = Get.find<PostCtrl>();
    return Obx(() {
      final dataRef =
          Get.find<FanPageCtrl>().selectedAccount ?? Get.find<UserCtrl>().user;

      return StreamBuilder(
          stream: dataRef?.snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            var isBussiness =
                data?["type"] == accountTypeIndex(UserAccountType.bussiness);
            return Stack(
              fit: StackFit.expand,
              children: [
                Obx(() {
                  return Opacity(
                    opacity: _backgroundOpacity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: kToolbarHeight - 20,
                      ),
                      decoration: BoxDecoration(
                        image: ctrl.selectedWallpaper != null ||
                                data?['background'] != null
                            ? DecorationImage(
                                image: AssetImage(data?['background'] ??
                                    ctrl.selectedWallpaper),
                                fit: BoxFit.cover,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  );
                }),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Get.theme.colorScheme.background,
                          Get.theme.colorScheme.background.withOpacity(0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [
                          0.6,
                          1.0,
                        ]),
                  ),
                ),
                CustomScrollView(
                  controller: profileScrollCtrl,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      leadingWidth: 76,
                      toolbarHeight: kToolbarHeight + 50,
                      leading: HomeAppBarAction(
                        selected: true,
                        icon: MdiIcons.arrowLeft,
                        onTap: () {
                          Get.find<PostCtrl>().setSelectedAccount(null);
                          Get.find<FanPageCtrl>().setSelectedAccount(null);
                          PageChangeNotification(0).dispatch(context);
                        },
                      ),
                      actions: [
                        const SizedBox(width: 10.0),
                        PopupMenuProfile(
                            options: accountOptions,
                            icon: MdiIcons.dotsHorizontal),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: _accountDetails(data),
                    ),
                    SliverToBoxAdapter(
                      child: AccountFollowFollowers(
                        withFollowButton:
                            Get.find<FanPageCtrl>().selectedAccount != null,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20.0),
                    ),
                    SliverToBoxAdapter(
                      child: ProfileTabBar(
                        children: [
                          ProfileTabBarItem(
                              label: 'Fondos',
                              icon: MdiIcons.wallpaper,
                              selected: _currentTab == 0,
                              onTap: () {
                                setState(() {
                                  _currentTab = 0;
                                });
                              }),
                          if (isBussiness)
                            ProfileTabBarItem(
                                label: 'Encuestas',
                                icon: MdiIcons.music,
                                selected: _currentTab == 1,
                                onTap: () {
                                  setState(() {
                                    _currentTab = 1;
                                  });
                                }),
                          ProfileTabBarItem(
                              label: 'Posts',
                              icon: MdiIcons.post,
                              selected: _currentTab == (isBussiness ? 2 : 1),
                              onTap: () {
                                setState(() {
                                  _currentTab = (isBussiness ? 2 : 1);
                                });
                              }),
                        ],
                      ),
                    ),
                    if (_currentTab == 0)
                      const SliverFillRemaining(
                        child: WallpaperTabView(),
                      ),
                    if (_currentTab == 1 && isBussiness)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Center(
                              child: PostItem(
                                snapshot: postCtrl.profileSurveys[index],
                              ),
                            );
                          },
                          childCount: postCtrl.profileSurveys.length,
                        ),
                      ),
                    if ((_currentTab == 2 && isBussiness) ||
                        (_currentTab == 1 && !isBussiness))
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Center(
                              child: PostItem(
                                snapshot: postCtrl.profilePosts[index],
                              ),
                            );
                          },
                          childCount: postCtrl.profilePosts.length,
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100.0),
                    )
                  ],
                ),
              ],
            );
          });
    });
  }

  Column _accountDetails(Map? data) {
    var hasImage = data?['image'] != null;
    var hasAddress = data?['address'] != null;
    var hasCategory = data?['category'] != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 130,
          height: 130,
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.theme.colorScheme.onBackground,
            border: Border.all(
              color: Get.theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachingImage(
                    url: data?['image'],
                    fit: BoxFit.cover,
                  ),
                )
              : const Center(child: Icon(MdiIcons.account)),
        ),
        const SizedBox(height: 20.0),
        Text(
          data?['name'] ?? '',
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasCategory)
          Text(
            '"${data?['category']}"',
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        if (hasAddress)
          Text(
            data?['address'] ?? '',
            style:
                TextStyle(fontSize: 15.0, color: Get.theme.colorScheme.primary),
          ),
      ],
    );
  }
}
