import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.onTap,
    this.label,
    this.child,
    this.radius,
  }) : assert(label != null || child != null);

  final VoidCallback? onTap;
  final String? label;
  final Widget? child;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Ink(
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 25),
          color: Get.theme.colorScheme.primary,
        ),
        child: child ??
            Text(
              label!,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}

class OutlinedRoundedButton extends StatelessWidget {
  const OutlinedRoundedButton({
    super.key,
    required this.onTap,
    required this.label,
  });

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Get.theme.colorScheme.background,
            border: Border.all(
              color: Get.theme.colorScheme.primary,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Get.theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
