import 'package:flutter/material.dart';

class ChatItem {
  final String name;
  final String message;
  final String time;
  final String? avatarUrl;
  final Color avatarColor;
  final bool isTyping;
  final int unreadCount;
  final bool isRead;
  final bool isDeleted;
  final bool isLocation;
  final bool isOnline;

  const ChatItem({
    required this.name,
    required this.message,
    required this.time,
    this.avatarUrl,
    required this.avatarColor,
    this.isTyping = false,
    this.unreadCount = 0,
    this.isRead = false,
    this.isDeleted = false,
    this.isLocation = false,
    this.isOnline = false,
  });
}
