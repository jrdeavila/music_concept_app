import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final options = {
    'logout': {
      "label": "Cerrar Sesión",
      "icon": MdiIcons.logout,
      "onTap": () {
        Get.find<AuthenticationCtrl>().logout();
      }
    },
    'change-image': {
      "label": "Cambiar Imagen",
      "icon": MdiIcons.image,
      "onTap": () {},
    },
    'edit-profile': {
      "label": "Editar Perfil",
      "icon": MdiIcons.accountEdit,
      "onTap": () {},
    },
  };
  final _pageCtrl = PageController();
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => ProfileCtrl());

    _pageCtrl.addListener(() {
      setState(() {
        _currentTab = _pageCtrl.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();
    return Obx(() {
      final dataRef = Get.find<UserCtrl>().user;

      return StreamBuilder(
          stream: dataRef?.snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            return Stack(
              fit: StackFit.expand,
              children: [
                Obx(() {
                  return Container(
                    margin: const EdgeInsets.only(
                      top: kToolbarHeight - 20,
                    ),
                    decoration: BoxDecoration(
                      image: ctrl.selectedWallpaper != null
                          ? DecorationImage(
                              image: AssetImage(ctrl.selectedWallpaper!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(30.0),
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
                          PageChangeNotification(0).dispatch(context);
                        },
                      ),
                      actions: [
                        const SizedBox(width: 10.0),
                        _popupProfileMenu(),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: _accountDetails(data),
                    ),
                    SliverToBoxAdapter(
                      child: _tabBarProfile(),
                    ),
                    SliverFillRemaining(
                      child: _tabViewProfile(),
                    ),
                  ],
                ),
              ],
            );
          });
    });
  }

  Widget _tabViewProfile() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageCtrl,
      children: [
        const WallpaperTabView(),
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _tabBarProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 20.0,
      ),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onBackground,
        borderRadius: BorderRadius.circular(30.0),
      ),
      height: 50,
      child: LayoutBuilder(builder: (context, constriants) {
        final width = constriants.maxWidth / 3.3;
        return Row(
          children: [
            _tabItem(
                label: 'Fondos',
                icon: MdiIcons.wallpaper,
                width: width,
                selected: _currentTab == 0,
                onTap: () {
                  _animateToPage(0);
                }),
            _tabItem(
                label: 'Favoritos',
                icon: MdiIcons.heart,
                width: width,
                selected: _currentTab == 1,
                onTap: () {
                  _animateToPage(1);
                }),
            _tabItem(
                label: 'Posts',
                icon: MdiIcons.post,
                width: width,
                selected: _currentTab == 2,
                onTap: () {
                  _animateToPage(2);
                }),
          ],
        );
      }),
    );
  }

  Future<void> _animateToPage(int tab) => _pageCtrl.animateToPage(tab,
      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

  Widget _tabItem({
    required String label,
    required IconData icon,
    required double width,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: selected ? Get.theme.colorScheme.primary : null,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 5.0),
            Text(
              label,
              style: TextStyle(
                color: Get.theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _accountDetails(Map? data) {
    var hasImage = data?['image'] != null;
    var hasAddress = data?['address'] != null;
    var hasCategory = data?['category'] != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Get.theme.colorScheme.onBackground,
            image: hasImage
                ? DecorationImage(
                    image: NetworkImage(data!['image']),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: hasImage ? null : const Center(child: Icon(MdiIcons.account)),
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

  // Opciones del perfil
  Widget _popupProfileMenu() {
    return PopupMenuButton(
        offset: const Offset(0, 85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onSelected: (value) {
          (options[value]!['onTap'] as VoidCallback)();
        },
        itemBuilder: (context) {
          return options.keys
              .map((e) => PopupMenuItem(
                    value: e,
                    child: Row(
                      children: [
                        Icon(options[e]!['icon'] as IconData?),
                        const SizedBox(width: 10.0),
                        Text(options[e]!['label'] as String),
                      ],
                    ),
                  ))
              .toList();
        },
        child: const HomeAppBarAction(
          icon: MdiIcons.dotsHorizontal,
          selected: true,
        ));
  }
}

class WallpaperTabView extends StatelessWidget {
  const WallpaperTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();
    return Obx(() {
      return MasonryGridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                ctrl.selectWallpaper(ctrl.wallpapers[index]);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  ctrl.wallpapers[index],
                  height: index.isEven ? 200 : 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: ctrl.wallpapers.length,
      );
    });
  }
}
