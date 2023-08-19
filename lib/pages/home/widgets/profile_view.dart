import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    this.guest,
  });

  final DocumentSnapshot<Map<String, dynamic>>? guest;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentTab = 1;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ProfileCtrl());
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();
    final postCtrl = Get.find<PostCtrl>();
    return StreamBuilder(
        stream: ctrl.getAccountStream(widget.guest?.reference.path),
        builder: (context, snapshot) {
          final data = snapshot.data?.data();

          return Stack(
            fit: StackFit.expand,
            children: [
              BackgroundProfile(data: data, scrollCtrl: _scrollCtrl),
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
              StreamBuilder(
                  stream: postCtrl.profilePosts(
                    guestRef: widget.guest?.reference.path,
                  ),
                  builder: (context, snapshot) {
                    return CustomScrollView(
                      controller: _scrollCtrl,
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
                              if (widget.guest != null) {
                                Get.back();
                              } else {
                                Get.find<FanPageCtrl>().goToReed();
                              }
                            },
                          ),
                          actions: [
                            const SizedBox(width: 10.0),
                            if (widget.guest == null)
                              HomeAppBarAction(
                                selected: true,
                                icon: MdiIcons.dotsVertical,
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                              ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: _accountDetails(data),
                        ),
                        SliverToBoxAdapter(
                          child: AccountFollowFollowers(
                            guest: widget.guest,
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
                              ProfileTabBarItem(
                                  label: 'Posts',
                                  icon: MdiIcons.post,
                                  selected: _currentTab == 1,
                                  onTap: () {
                                    setState(() {
                                      _currentTab = 1;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        if (_currentTab == 0)
                          const SliverFillRemaining(
                            child: WallpaperTabView(),
                          ),
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.none)
                          const SliverToBoxAdapter(
                            child: LoadingPostSkeleton(),
                          ),
                        if (snapshot.connectionState ==
                                ConnectionState.active &&
                            snapshot.hasData &&
                            snapshot.data!.isNotEmpty)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Center(
                                  child: PostItem(
                                    isReed: widget.guest != null,
                                    snapshot: snapshot.data![index],
                                  ),
                                );
                              },
                              childCount: snapshot.data?.length ?? 0,
                            ),
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100.0),
                        )
                      ],
                    );
                  }),
            ],
          );
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

class BackgroundProfile extends StatefulWidget {
  const BackgroundProfile({
    super.key,
    required this.scrollCtrl,
    required this.data,
  });

  final Map<String, dynamic>? data;
  final ScrollController scrollCtrl;

  @override
  State<BackgroundProfile> createState() => _BackgroundProfileState();
}

class _BackgroundProfileState extends State<BackgroundProfile> {
  double _backgroundOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    widget.scrollCtrl.addListener(() {
      _backgroundOpacity = 1 - (widget.scrollCtrl.offset / 50).clamp(0, 1);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();

    return Obx(() {
      return Opacity(
        opacity: _backgroundOpacity,
        child: Container(
          margin: const EdgeInsets.only(
            top: kToolbarHeight - 20,
          ),
          decoration: BoxDecoration(
            image: ctrl.selectedWallpaper != null ||
                    widget.data?['background'] != null
                ? DecorationImage(
                    image: AssetImage(
                        widget.data?['background'] ?? ctrl.selectedWallpaper),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      );
    });
  }
}

class LoadingPostSkeleton extends StatelessWidget {
  const LoadingPostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PostSkeleton(),
        PostSkeleton(),
        PostSkeleton(),
      ],
    );
  }
}
