import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageCtrl = PageController();
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserCtrl());

    Get.lazyPut(() => PostCtrl());
    _pageCtrl.addListener(() {
      setState(() {
        _selectedPage = _pageCtrl.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<PageChangeNotification>(
      onNotification: (notification) {
        _pageCtrl.animateToPage(notification.page,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        return true;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            endDrawer: const HomeDrawer(),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _pageCtrl,
              children: const [
                FanPageView(), // Home View

                ProfileView(), // Profile View
              ],
            ),
            extendBody: true,
            // resizeToAvoidBottomInset: false,

            bottomNavigationBar: Obx(() {
              if (Get.find<FanPageCtrl>().isSearching) {
                return const SizedBox.shrink();
              }
              if (Get.find<FanPageCtrl>().selectedAccount != null) {
                return const SizedBox.shrink();
              }
              return _bottomBar();
            }),
          ),
          Align(
            alignment: const FractionalOffset(0.5, 0.925),
            child: SizedBox(
              width: 134.0,
              child: Obx(() {
                if (Get.find<FanPageCtrl>().isSearching) {
                  return const SizedBox.shrink();
                }
                if (Get.find<FanPageCtrl>().selectedAccount != null) {
                  return const SizedBox.shrink();
                }

                return _floatingButton();
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _floatingButton() {
    return Obx(() {
      final dataRef =
          Get.find<FanPageCtrl>().selectedAccount ?? Get.find<UserCtrl>().user;

      return StreamBuilder(
          stream: dataRef?.snapshots(),
          builder: (context, snapshot) {
            final isBussiness = snapshot.data?.data()?["type"] ==
                accountTypeIndex(UserAccountType.bussiness);

            return FloatingActionButton.extended(
              onPressed: () {
                if (isBussiness) {
                  dialogBuilder<bool>(
                    context,
                    Offset(
                      Get.width / 2,
                      Get.height / 2,
                    ),
                    const MenuSelectPostOrSurvey(),
                  ).then((bool? value) {
                    if (value == null) return;
                    if (value) {
                      Get.toNamed(AppRoutes.createSurvey);
                    } else {
                      _showPostDialog(context);
                    }
                  });
                } else {
                  _showPostDialog(context);
                }
              },
              icon: const Icon(MdiIcons.plus),
              label: const Text('Publicar'),
            );
          });
    });
  }

  Future<dynamic> _showPostDialog(BuildContext context) {
    return dialogKeyboardBuilder(
      context,
      Offset(
        Get.width / 2,
        Get.height / 2,
      ),
      const PostDialogContent(),
    );
  }

  ClipPath _bottomBar() {
    return ClipPath(
      clipper: _RoundedBottomAppBarClipper(),
      child: BottomAppBar(
        color: Get.theme.primaryColor,
        height: 80.0,
        child: Row(children: [
          const SizedBox(width: 16.0),
          HomeAppBarAction(
            selected: _selectedPage == 0,
            icon: MdiIcons.home,
            onTap: () {
              Get.find<PostCtrl>().reset();
              _pageCtrl.animateToPage(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ),
          const Spacer(),
          HomeAppBarAction(
            icon: MdiIcons.account,
            selected: _selectedPage == 1,
            onTap: () {
              Get.find<PostCtrl>().reset();
              _pageCtrl.animateToPage(
                1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          const SizedBox(width: 16.0),
        ]),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Get.theme.colorScheme.background,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Get.theme.colorScheme.onBackground,
                  width: double.infinity,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          AppDefaults.titleName,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Opciones de configuracion",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[300],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ...accountOptions.keys.map(
                  (e) => ListTile(
                    onTap: () {
                      (accountOptions[e]!['onTap'] as VoidCallback)();
                    },
                    leading: Icon(
                      accountOptions[e]!["icon"] as IconData,
                      size: 30,
                    ),
                    title: Text(
                      accountOptions[e]!["label"] as String,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Get.find<AuthenticationCtrl>().logout();
            },
            leading: const Icon(
              MdiIcons.logout,
              size: 30,
            ),
            title: const Text(
              "Cerrar Sesión",
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuSelectPostOrSurvey extends StatelessWidget {
  const MenuSelectPostOrSurvey({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Material(
            color: Get.theme.colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "¿Que deseas publicar?",
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _listItem(
                          icon: MdiIcons.newspaperVariantMultipleOutline,
                          label: 'Publicacion',
                          onTap: () {
                            Get.back(result: false);
                          },
                        ),
                        const SizedBox(width: 20.0),
                        _listItem(
                          icon: MdiIcons.poll,
                          label: 'Encuesta',
                          onTap: () {
                            Get.back(result: true);
                          },
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.onBackground,
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Get.theme.colorScheme.primary,
              size: 70,
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundedBottomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final x = size.width;
    final y = size.height;
    const r = 20.0;
    const r2 = 35.0;
    const p = 8.0;
    const n = 70.0;
    const b = 28.0;

    final path = Path()
      ..moveTo(0, p + r)
      ..quadraticBezierTo(0, p, r, p)
      ..lineTo((x / 2) - n, 0)
      ..quadraticBezierTo(
        (x / 2) - n,
        b,
        (x / 2) + r2 - n,
        b,
      )
      ..lineTo((x / 2) + n - r2, b)
      ..quadraticBezierTo(
        (x / 2) + n,
        b,
        (x / 2) + n,
        0,
      )
      ..lineTo(x - r, p)
      ..quadraticBezierTo(x, p, x, p + r)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class PageChangeNotification extends Notification {
  final int page;

  PageChangeNotification(this.page);
}
