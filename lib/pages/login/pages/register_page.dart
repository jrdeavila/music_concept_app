import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<RegisterCtrl>();
    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 200,
                child: LoginHeader(
                  title: "Registrate",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ProfileTabBar(children: [
                  ProfileTabBarItem(
                    label: "Credenciales",
                    icon: MdiIcons.accountLock,
                    selected: ctrl.page == 0,
                    onTap: () {
                      ctrl.previousPage();
                    },
                  ),
                  ProfileTabBarItem(
                    label: "Datos personales",
                    icon: MdiIcons.account,
                    selected: ctrl.page == 1,
                    onTap: () {
                      ctrl.nextPage();
                    },
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child:
                    ctrl.page == 0 ? _credentialsForm() : _personalInfoForm(),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Center(
          child: TextButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.login);
            },
            child: const Text('¿Ya tienes una cuenta? Inicia sesion'),
          ),
        ),
      ),
    );
  }

  Widget _personalInfoForm() {
    final ctrl = Get.find<RegisterCtrl>();
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 150,
            height: 150,
            child: ImagePicker(
              onImageSelected: ctrl.setImage,
            ),
          ),
        ),
        LoginRoundedTextField(
          label: "Nombre",
          icon: MdiIcons.account,
          keyboardType: TextInputType.name,
          onChanged: ctrl.setName,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            onTap: () {
              ctrl.submit();
            },
            label: "Continuar",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            padding: EdgeInsets.zero,
            onTap: () {
              ctrl.goToBussiness();
            },
            label: "Continuar como negocio",
            isBordered: true,
          ),
        ),
      ],
    );
  }

  Widget _credentialsForm() {
    var ctrl = Get.find<RegisterCtrl>();
    return Column(
      children: [
        LoginRoundedTextField(
          label: "Correo electronico",
          icon: MdiIcons.email,
          keyboardType: TextInputType.emailAddress,
          onChanged: ctrl.setEmail,
        ),
        LoginRoundedTextField(
          label: "Contraseña",
          icon: MdiIcons.lock,
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
          onChanged: ctrl.setPassword,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedButton(
            onTap: () {
              ctrl.nextPage();
            },
            label: "Continuar",
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
