import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';

class PostSkeleton extends StatefulWidget {
  const PostSkeleton({super.key});

  @override
  State<PostSkeleton> createState() => _PostSkeletonState();
}

class _PostSkeletonState extends State<PostSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 360,
          height: 400,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Get.theme.colorScheme.onBackground,
          ),
          child: Column(
            children: [
              _skeleton(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                width: double.infinity,
                height: 150,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  _skeleton(
                    width: 50,
                    height: 50,
                    shape: BoxShape.circle,
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _skeleton(
                        width: 150,
                        height: 15,
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          _skeleton(
                            width: 100,
                            height: 8,
                          ),
                          const SizedBox(width: 10.0),
                          _skeleton(
                            width: 15,
                            height: 15,
                            shape: BoxShape.circle,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _skeleton(
                        width: double.infinity,
                        height: 20,
                      ),
                      const SizedBox(height: 10.0),
                      _skeleton(
                        width: 250,
                        height: 20,
                      ),
                      const SizedBox(height: 10.0),
                      _skeleton(
                        width: 300,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.heart,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          MdiIcons.comment,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Container _skeleton(
      {required double width,
      required double height,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: shape,
          color: Color.lerp(
            Colors.grey[600],
            Colors.grey[300],
            _controller.value,
          )),
    );
  }
}
