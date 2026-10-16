import 'package:flutter/material.dart';
import '../models/chat_item.dart';
import 'chat_avatar.dart';

class ChatTile extends StatelessWidget {
  final ChatItem chat;

  const ChatTile({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ChatAvatar(
              avatarUrl: chat.avatarUrl,
              fallbackColor: chat.avatarColor,
              name: chat.name,
              isOnline: chat.isOnline,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _buildMessagePreview(),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                    color: chat.isTyping || chat.unreadCount > 0
                        ? const Color(0xFF25D366)
                        : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 5),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePreview() {
    if (chat.isTyping) {
      return Text(
        chat.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF25D366),
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Row(
      children: [
        if (chat.isRead) ...[
          const Icon(
            Icons.done_all,
            size: 16,
            color: Color(0xFF34B7F1),
          ),
          const SizedBox(width: 4),
        ],
        if (chat.isDeleted) ...[
          Icon(
            Icons.block,
            size: 14,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 4),
        ],
        if (chat.isLocation) ...[
          const Icon(
            Icons.location_on,
            size: 15,
            color: Colors.grey,
          ),
          const SizedBox(width: 3),
        ],
        Expanded(
          child: Text(
            chat.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: chat.isDeleted ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}
