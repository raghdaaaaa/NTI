import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileItem extends StatelessWidget {
  final String icon;
  final String title;
  final double? iconSize;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: iconSize ?? 22, height: iconSize ?? 22),
          const SizedBox(width: 30),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
