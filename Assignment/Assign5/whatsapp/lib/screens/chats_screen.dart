import 'package:flutter/material.dart';

import '../models/chat_item.dart';
import '../widgets/chat_tile.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  static const List<ChatItem> dummyChats = [
    ChatItem(
      name: 'Roqia',
      message: 'You reacted 😂 to "That\'s good advice, Marty."',
      time: '16:51',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse3.mm.bing.net%2Fth%2Fid%2FOIP.BKiOD3vxgkLZMCyGcqckcQHaHa%3Fr%3D0%26pid%3DApi&sp=1792147935Te7f16d0c258248c45904b8ba8b4c2b52ee857e55b0db433fddfca5c9f1061a3e',
      avatarColor: Color(0xFFE91E63),
    ),
    ChatItem(
      name: 'Shika',
      message: 'Match on 7:00 PM!',
      time: '16:45',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.b_qFu8cuHcA8STIdN1_RiAAAAA%3Fr%3D0%26pid%3DApi&sp=1792147647T139921823086e14300755673c174a3cc95b1e20fe890b3a70437b57e35b8f2fe',
      avatarColor: Color.fromARGB(255, 193, 55, 43),
      isTyping: true,
      unreadCount: 1,
      isOnline: true,
    ),
    ChatItem(
      name: 'Shika',
      message: 'Match on 7:00 PM!',
      time: '16:45',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.b_qFu8cuHcA8STIdN1_RiAAAAA%3Fr%3D0%26pid%3DApi&sp=1792147647T139921823086e14300755673c174a3cc95b1e20fe890b3a70437b57e35b8f2fe',
      avatarColor: Color.fromARGB(255, 193, 55, 43),
      isTyping: true,
      unreadCount: 1,
      isOnline: true,
    ),
    ChatItem(
      name: 'Shika',
      message: 'Match on 7:00 PM!',
      time: '16:45',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.b_qFu8cuHcA8STIdN1_RiAAAAA%3Fr%3D0%26pid%3DApi&sp=1792147647T139921823086e14300755673c174a3cc95b1e20fe890b3a70437b57e35b8f2fe',
      avatarColor: Color.fromARGB(255, 193, 55, 43),
      isTyping: true,
      unreadCount: 1,
      isOnline: true,
    ),
    ChatItem(
      name: 'Ahmed',
      message: 'Location',
      time: '08:34',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse3.mm.bing.net%2Fth%2Fid%2FOIP.fdVXZ6K1AUUltPZnegHSKQAAAA%3Fr%3D0%26pid%3DApi&sp=1792148057T4148358f2952b4e2fee5f33b770eb5fdaac7e5c533bd1ce1057ac41b7e724c6d',
      avatarColor: Color(0xFF3F51B5),
      isLocation: true,
    ),
    ChatItem(
      name: 'Omar',
      message: 'Thanks bro!',
      time: '08:01',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse3.mm.bing.net%2Fth%2Fid%2FOIP.1t6byxV2SaLaSZxg92SONAHaFD%3Fr%3D0%26pid%3DApi&sp=1792148013T9f55dd423809b5c6298429b054bdbdc87a5f71e47671ea2d9b2fb22d0557466a',
      avatarColor: Color(0xFF4CAF50),
    ),
    ChatItem(
      name: 'Abdallah',
      message: 'Ok!',
      time: 'Yesterday',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.a4vbWBZYpOeTJBeKUQzsHwHaEL%3Fr%3D0%26pid%3DApi&sp=1792147964T954aa6ccb7ea16c46da1a2999b5e9ec1ad306fcc68b406e28c9e9d0d111b9788',
      avatarColor: Color(0xFFE91E63),
      isRead: true,
    ),
    ChatItem(
      name: 'Abdallah',
      message: 'Ok!',
      time: 'Yesterday',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.a4vbWBZYpOeTJBeKUQzsHwHaEL%3Fr%3D0%26pid%3DApi&sp=1792147964T954aa6ccb7ea16c46da1a2999b5e9ec1ad306fcc68b406e28c9e9d0d111b9788',
      avatarColor: Color(0xFFE91E63),
      isRead: true,
    ),
    ChatItem(
      name: 'Abdallah',
      message: 'Ok!',
      time: 'Yesterday',
      avatarUrl: 'https://www.startpage.com/av/proxy-image?piurl=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.a4vbWBZYpOeTJBeKUQzsHwHaEL%3Fr%3D0%26pid%3DApi&sp=1792147964T954aa6ccb7ea16c46da1a2999b5e9ec1ad306fcc68b406e28c9e9d0d111b9788',
      avatarColor: Color(0xFFE91E63),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TopStatusBar(),
            const _ChatsHeader(),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: dummyChats.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 0.6,
                    indent: 82,
                    color: Color(0xFFE5E5EA),
                  );
                },
                itemBuilder: (context, index) {
                  return ChatTile(chat: dummyChats[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStatusBar extends StatelessWidget {
  const _TopStatusBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '23:59',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.signal_cellular_alt,
                size: 18,
                color: Colors.black,
              ),
              const SizedBox(width: 4),
              const Text(
                '5G',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 22,
                height: 12,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(3.5),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatsHeader extends StatelessWidget {
  const _ChatsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black87,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Chats',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
