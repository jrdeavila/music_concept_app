import 'package:music_concept_app/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReedView extends StatelessWidget {
  const ReedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var posts = Get.find<PostCtrl>().posts;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          posts.isEmpty
              ? SliverList(
                  delegate: SliverChildListDelegate([
                    ...List.generate(
                      4,
                      (index) => const PostSkeleton(),
                    ),
                  ]),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var post = Get.find<PostCtrl>().posts[index];
                      return PostItem(
                        snapshot: post,
                        isReed: true,
                      );
                    },
                    childCount: posts.length,
                    addAutomaticKeepAlives: false,
                  ),
                ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100.0,
            ),
          ),
        ]),
      );
    });
  }
}
