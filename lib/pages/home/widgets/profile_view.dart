import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final options = {
    'logout': {
      "label": "Cerrar Sesión",
      "icon": MdiIcons.logout,
      "onTap": () {
        Get.find<AuthenticationCtrl>().logout();
      }
    },
    'change-image': {
      "label": "Cambiar Imagen",
      "icon": MdiIcons.image,
      "onTap": () {},
    },
    'edit-profile': {
      "label": "Editar Perfil",
      "icon": MdiIcons.accountEdit,
      "onTap": () {},
    },
  };

  final userRef = Get.find<UserCtrl>().user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 76,
          leading: HomeAppBarAction(
            selected: true,
            icon: MdiIcons.arrowLeft,
            onTap: () {
              PageChangeNotification(0).dispatch(context);
            },
          ),
          actions: [
            const SizedBox(width: 10.0),
            _popupProfileMenu(),
            const SizedBox(width: 16.0),
          ],
        ),
        Expanded(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: userRef?.snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();
                var hasImage = data?['image'] != null;
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Get.theme.colorScheme.onBackground,
                              image: hasImage
                                  ? DecorationImage(
                                      image: NetworkImage(data!['image']),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: hasImage
                                ? null
                                : const Center(child: Icon(MdiIcons.account)),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            data?['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  // Opciones del perfil
  Widget _popupProfileMenu() {
    return PopupMenuButton(
        offset: const Offset(0, 85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onSelected: (value) {
          (options[value]!['onTap'] as VoidCallback)();
        },
        itemBuilder: (context) {
          return options.keys
              .map((e) => PopupMenuItem(
                    value: e,
                    child: Row(
                      children: [
                        Icon(options[e]!['icon'] as IconData?),
                        const SizedBox(width: 10.0),
                        Text(options[e]!['label'] as String),
                      ],
                    ),
                  ))
              .toList();
        },
        child: const HomeAppBarAction(
          icon: MdiIcons.dotsHorizontal,
          selected: true,
        ));
  }
}
