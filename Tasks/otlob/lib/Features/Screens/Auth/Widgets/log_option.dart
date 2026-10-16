import 'package:flutter/material.dart';

class LogOption extends StatelessWidget {
  const LogOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final Icon icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [icon, SizedBox(width: 10), Text(text)],
            ),
          ),
        ),
      ],
    );
  }
}
