import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class RegisterBussinessPage extends StatelessWidget {
  const RegisterBussinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    var ctrl = Get.find<RegisterBussinessCtrl>();
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const LoginHeader(
            title: "Registrate",
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ImagePicker(
                        onImageSelected: ctrl.setImage,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LoginRoundedTextField(
                            label: "Nombre",
                            icon: MdiIcons.account,
                            keyboardType: TextInputType.name,
                            onChanged: ctrl.setName,
                          ),
                          LoginRoundedTextField(
                            label: "Direccion",
                            icon: MdiIcons.mapMarker,
                            keyboardType: TextInputType.name,
                            onChanged: ctrl.setAddress,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LoginDropDownCategories(
                  onChangeCategory: ctrl.setCategory,
                ),
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
                RoundedButton(
                  label: 'Registrar',
                  onTap: ctrl.submit,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.login);
                  },
                  child: const Text('¿Ya tienes una cuenta? Inicia sesion'),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
