import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var ctrl = Get.find<RegisterCtrl>();
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
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 130,
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
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                        label: 'Como usuario',
                        onTap: ctrl.submit,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RoundedButton(
                        isBordered: true,
                        label: 'Como negocio',
                        onTap: ctrl.goToBussiness,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
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
