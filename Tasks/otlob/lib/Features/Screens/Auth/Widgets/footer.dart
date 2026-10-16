import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
    required this.text,
    required this.actionText,
    required this.actionTap,
  });
  final String text;
  final String actionText;
  final VoidCallback actionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          actionText,
          style: TextStyle(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
