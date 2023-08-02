import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';

class LoginRoundedTextField extends StatefulWidget {
  const LoginRoundedTextField({
    super.key,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.isPassword = false,
    this.helpText,
  });

  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final bool isPassword;
  final String? helpText;

  @override
  State<LoginRoundedTextField> createState() => _LoginRoundedTextFieldState();
}

class _LoginRoundedTextFieldState extends State<LoginRoundedTextField> {
  late bool _visible;
  @override
  void initState() {
    super.initState();
    _visible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextField(
        obscureText: _visible,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isPassword ? _toggleVisibilityWidget() : null,
          hintText: widget.label,
          helperText: widget.helpText,
          helperMaxLines: 3,
          fillColor: Get.theme.colorScheme.onBackground,
          filled: true,
          border: OutlineInputBorder(
            gapPadding: 12,
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _toggleVisibilityWidget() => GestureDetector(
        onTap: () => setState(() => _visible = !_visible),
        child: Icon(_visible ? MdiIcons.eye : MdiIcons.eyeOff),
      );
}
