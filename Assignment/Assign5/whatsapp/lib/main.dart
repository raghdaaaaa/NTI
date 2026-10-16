import 'package:flutter/material.dart';
import 'screens/chats_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Chats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const ChatsScreen(),
    );
  }
}
