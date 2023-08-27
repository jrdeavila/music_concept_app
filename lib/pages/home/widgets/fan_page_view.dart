import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class FanPageView extends StatelessWidget {
  const FanPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text(AppDefaults.titleName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              )),
          actions: [
            HomeAppBarAction(
              selected: true,
              icon: MdiIcons.magnify,
              onTap: () => Get.find<HomeCtrl>().goToSearch(),
            ),
            const SizedBox(width: 10.0),
            const NotificationButton(),
            const SizedBox(width: 10.0),
            HomeAppBarAction(
              selected: true,
              icon: MdiIcons.message,
              onTap: () {},
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Expanded(
            child: PageView(
          controller: Get.find<FanPageCtrl>().pageCtrl,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ReedView(),
            NotificationView(),
          ],
        )),
      ],
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notificaciones (${Get.find<NotificationCtrl>().notificationCount})",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.grey[500],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var notification =
                        Get.find<NotificationCtrl>().notifications[index];
                    return NotificationItem(notification: notification);
                  },
                  itemCount: Get.find<NotificationCtrl>().notifications.length,
                ),
              ),
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.find<NotificationCtrl>().deleteAll();
                        },
                        child: const SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MdiIcons.deleteOutline),
                              SizedBox(width: 10.0),
                              Text("Borrar todo"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Get.find<NotificationCtrl>().markAllAsRead();
                      },
                      child: const SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.bellOffOutline),
                            SizedBox(width: 10.0),
                            Text("Marcar como leído"),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
  });

  final FdSnapshot notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.find<NotificationCtrl>().markAsRead(notification.reference.path);
        Get.toNamed(
          AppRoutes.postDetails,
          arguments: notification["arguments"]!['ref'],
        );
      },
      leading: notificationIcon[notification["type"]]!,
      minLeadingWidth: 10.0,
      minVerticalPadding: 10.0,
      title: Text(
        notification["title"],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification["body"],
            style: const TextStyle(
              fontSize: 14.0,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
          Text(
            TimeUtils.timeagoFormat(notification["createdAt"].toDate()),
            style: const TextStyle(
              fontSize: 12.0,
            ),
          )
        ],
      ),
      trailing: notification["read"] == false
          ? Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

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

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var count = Get.find<NotificationCtrl>().notificationCount;
      var selected = Get.find<FanPageCtrl>().isNotifications;
      return HomeAppBarAction(
        selected: true,
        light: selected,
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(
                  MdiIcons.bell,
                  color: selected ? Get.theme.colorScheme.primary : null,
                ),
              ),
              if (count > 0)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: selected
                          ? Get.theme.colorScheme.onPrimary
                          : Get.theme.colorScheme.onBackground,
                    ),
                  ),
                ),
              if (count > 0)
                Positioned(
                  top: 13,
                  right: 13,
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        onTap: () {
          Get.find<FanPageCtrl>().toggleNotifications();
        },
      );
    });
  }
}
