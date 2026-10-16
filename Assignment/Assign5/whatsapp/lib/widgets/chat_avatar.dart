import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  final String? avatarUrl;
  final Color fallbackColor;
  final String name;
  final bool isOnline;

  const ChatAvatar({
    super.key,
    this.avatarUrl,
    required this.fallbackColor,
    required this.name,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 26;

    return Stack(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: fallbackColor.withValues(alpha: 0.2),
          child: ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackInitials();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildFallbackInitials();
                    },
                  )
                : _buildFallbackInitials(),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFallbackInitials() {
    final initials = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      color: fallbackColor,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
