import 'package:flutter/material.dart';

class Remember extends StatefulWidget {
  const Remember({super.key});

  @override
  State<Remember> createState() => _RememberState();
}

class _RememberState extends State<Remember> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: isChecked,
              activeColor: const Color(0xFFFF5C39),
              onChanged: (value) {
                setState(() => isChecked = value ?? false);
              },
            ),
            Text(
              "Remember me",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        const Text(
          "Forgot password?",
          style: TextStyle(
            color: Color(0xFFFF5C39),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
