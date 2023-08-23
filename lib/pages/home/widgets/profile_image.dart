import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.image,
    required this.name,
    this.fontSize = 20.0,
    this.avatarSize = 40.0,
    this.active = false,
  });

  final String? image;
  final String? name;
  final double fontSize;
  final double avatarSize;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final hasImage = image != null;
    return SizedBox(
      height: avatarSize,
      width: avatarSize,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: StatusClipper(
                active: active,
                radius: 0.1538 * avatarSize,
                dx: 0.2307 * avatarSize / 2,
              ),
              child: Builder(builder: (context) {
                if (hasImage) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(avatarSize / 2),
                    child: CachingImage(
                      url: image!,
                      fit: BoxFit.cover,
                      height: avatarSize,
                      width: avatarSize,
                    ),
                  );
                } else {
                  return Container(
                    height: avatarSize,
                    width: avatarSize,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(avatarSize / 2),
                    ),
                    child: Center(
                      child: Text(
                        name?[0].toUpperCase() ?? '',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
          if (active)
            Positioned(
              height: 0.2307 * avatarSize,
              width: 0.2307 * avatarSize,
              bottom: 0.0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                    color: Get.theme.colorScheme.onPrimary,
                    width: 1.0,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StatusClipper extends CustomClipper<Path> {
  final bool active;
  final double radius, dx;
  const StatusClipper({
    this.active = false,
    this.radius = 20.0,
    this.dx = 15.0,
  });
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..close()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width - dx, size.height - dx),
          radius: active ? radius : 0.0,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
