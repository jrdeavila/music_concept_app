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
    _pageCtrl.addListener(() {
      setState(() {
        _selectedPage = _pageCtrl.page?.round() ?? 0;
      });
    });
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
      child: Scaffold(
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(MdiIcons.plus),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: ClipPath(
            clipper: _RoundedBottomAppBarClipper(),
            child: BottomAppBar(
              color: Get.theme.primaryColor,
              shape: const CircularNotchedRectangle(),
              height: 80.0,
              child: Row(children: [
                const SizedBox(width: 16.0),
                HomeAppBarAction(
                  selected: _selectedPage == 0,
                  icon: MdiIcons.home,
                  onTap: () {
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
          )),
    );
  }
}

class _RoundedBottomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final x = size.width;
    final y = size.height;
    const r = 20.0;
    const p = 8.0;

    final path = Path()
      ..moveTo(0, p + r)
      ..quadraticBezierTo(0, p, r, p)
      ..lineTo(x / 2, 0)
      ..lineTo(x - r, p)
      ..quadraticBezierTo(x, p, x, p + r)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class PageChangeNotification extends Notification {
  final int page;

  PageChangeNotification(this.page);
}
