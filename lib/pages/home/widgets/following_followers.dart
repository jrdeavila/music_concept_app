import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class AccountFollowFollowers extends StatelessWidget {
  const AccountFollowFollowers({
    super.key,
    this.withFollowButton = false,
  });

  final bool withFollowButton;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileCtrl>();
    final fanPageCtrl = Get.find<FanPageCtrl>();

    return Obx(() {
      final currentRef = fanPageCtrl.currentAccount?.path;
      final accountRef = fanPageCtrl.selectedAccount?.path;
      final options = {
        'unfollow': {
          "label": "Dejar de seguir",
          "icon": MdiIcons.accountMinus,
          "onTap": () {
            ctrl.unfollow(
              followerRef: currentRef!,
              followingRef: accountRef!,
            );
          },
        },
        'block': {
          "label": "Bloquear",
          "icon": MdiIcons.blockHelper,
          "onTap": () {},
        },
      };
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (withFollowButton) ...[
            const SizedBox(height: 20.0),
            StreamBuilder<bool>(
                stream: ctrl.isFollowing(
                  followerRef: currentRef!,
                  followingRef: accountRef!,
                ),
                builder: (context, snapshot) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FollowButton(
                        isFollowing: snapshot.data ?? false,
                        onTap: () {
                          ctrl.follows(
                            followerRef: currentRef,
                            followingRef: accountRef,
                          );
                        },
                      ),
                      const SizedBox(width: 10.0),
                      if (snapshot.data == true)
                        PopupMenuProfile(
                          options: options,
                          icon: MdiIcons.dotsVertical,
                          positionY: 60,
                        ),
                    ],
                  );
                }),
          ],
          const SizedBox(height: 20.0),
          Row(
            children: [
              StreamBuilder<int>(
                  stream: ctrl.getFollowersCount(accountRef ?? currentRef),
                  builder: (context, snapshot) {
                    return _item(
                      label: "Seguidores",
                      value: snapshot.data?.toString() ?? "0",
                    );
                  }),
              StreamBuilder<int>(
                  stream: ctrl.getFollowingCount(accountRef ?? currentRef),
                  builder: (context, snapshot) {
                    return _item(
                      label: "Siguiendo",
                      value: snapshot.data?.toString() ?? "0",
                    );
                  }),
              StreamBuilder<int>(
                  stream: ctrl.getPostsCount(accountRef ?? currentRef),
                  builder: (context, snapshot) {
                    return _item(
                      label: "Publicaciones",
                      value: snapshot.data?.toString() ?? "0",
                    );
                  }),
            ],
          ),
        ],
      );
    });
  }

  Widget _item({
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 27.0,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Get.theme.colorScheme.onPrimary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    this.isFollowing = false,
    this.onTap,
  });

  final bool isFollowing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: !isFollowing
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.onBackground,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Center(
          child: isFollowing
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(MdiIcons.check),
                    SizedBox(width: 5.0),
                    Text(
                      "Siguiendo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const Text(
                  "Seguir",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
