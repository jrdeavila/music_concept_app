import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBarAction extends StatelessWidget {
  const HomeAppBarAction({
    super.key,
    required this.icon,
    this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool selected;

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
              color: selected ? Get.theme.colorScheme.onBackground : null,
            ),
            child: Center(child: Icon(icon)),
          ),
        ),
      ),
    );
  }
}
