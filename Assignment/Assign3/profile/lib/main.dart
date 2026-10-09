import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
       appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.brown.shade100,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/icons/profile.jpg'),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person, color: Colors.brown.shade600),
                title: const Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Raghdaa Emad'),
              ),
              ListTile(
                leading: Icon(Icons.work, color: Colors.brown.shade600),
                title: const Text('Job Title', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Flutter Developer'),
              ),
              ListTile(
                leading: Icon(Icons.cake, color: Colors.brown.shade600),
                title: const Text('Age', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('22'),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.brown.shade600),
                title: const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Mansoura, Egypt'),
              ),
              ListTile(
                leading: Icon(Icons.school, color: Colors.brown.shade600),
                title: const Text('Graduated', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Last year'),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.brown.shade600),
                title: const Text('Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Ra4hdaa@gmail.com'),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.brown.shade600),
                title: const Text('Phone Number', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('+201146972964'),
              ),
              ListTile(
                leading: Icon(Icons.link, color: Colors.brown.shade600),
                title: const Text('LinkedIn', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Raghdaa-Emad'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('Open'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}