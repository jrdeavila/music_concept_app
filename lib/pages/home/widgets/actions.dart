import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBarAction extends StatelessWidget {
  const HomeAppBarAction({
    super.key,
    this.icon,
    this.onTap,
    this.selected = false,
    this.child,
    this.light = false,
  }) : assert(icon != null || child != null);

  final IconData? icon;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? child;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          onTap: onTap,
          child: Ink(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? light
                      ? Get.theme.colorScheme.onPrimary
                      : Get.theme.colorScheme.onBackground
                  : null,
            ),
            child: child ??
                Center(
                    child: Icon(
                  icon,
                  color: light ? Get.theme.colorScheme.primary : null,
                )),
          ),
        ),
      ),
    );
  }
}
