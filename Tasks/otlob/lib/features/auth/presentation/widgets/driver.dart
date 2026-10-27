import 'package:flutter/material.dart';

class Driver extends StatelessWidget {
  const Driver({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black26, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or With',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black26, thickness: 1)),
      ],
    );
  }
}
