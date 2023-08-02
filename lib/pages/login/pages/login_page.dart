import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const LoginHeader(title: "Iniciar sesión"),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginRoundedTextField(
                  label: "Correo electronico",
                  icon: MdiIcons.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {},
                ),
                LoginRoundedTextField(
                  label: "Contraseña",
                  icon: MdiIcons.lock,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  onChanged: (value) {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.resetPassword);
                      },
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: RoundedButton(
                    label: 'Entrar',
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.register);
                  },
                  child: const Text('¿No tienes una cuenta? Registrate'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: OutlinedRoundedButton(
                    label: 'Modo de establecimientos',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
