import 'package:flutter/material.dart';

class Forms extends StatelessWidget {
  const Forms({
    super.key,
    required this.label,
    required this.hint,
    required this.textController,
    this.icon,
    this.isPassword = false,
  });

  final String label;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFFF5C39)),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white24,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black26, width: 1),
        ),
      ),
    );
  }
}
