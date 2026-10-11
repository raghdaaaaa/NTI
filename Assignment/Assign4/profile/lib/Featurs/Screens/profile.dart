import 'package:flutter/material.dart';
import 'package:sone/Core/icons.dart';
import 'package:sone/Featurs/Widgets/profile_item.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.arrow_back_ios_new, size: 26),
                  Text(
                    'My Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.settings_outlined, size: 30),
                ],
              ),

              const SizedBox(height: 35),

              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: const AssetImage(
                          AppAssets.profileImage,
                        ),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Raghdaa Emad',
                          style: TextStyle(fontSize: 26),
                        ),
                        const Text(
                          'Ra4hdaa@gmail.com',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const ProfileItem(icon: AppAssets.fav, title: 'Favourites'),
              const ProfileItem(icon: AppAssets.download, title: 'Downloads'),

              const Divider(height: 30, color: Colors.black),

              const ProfileItem(icon: AppAssets.lang, title: 'Languages'),
              const ProfileItem(icon: AppAssets.loc, title: 'Location'),
              const ProfileItem(icon: AppAssets.subs, title: 'Subscription'),
              const ProfileItem(icon: AppAssets.display, title: 'Display'),

              const Divider(height: 30, color: Colors.black),

              const ProfileItem(icon: AppAssets.remove, title: 'Clear Cache'),
              const ProfileItem(icon: AppAssets.clock, title: 'Clear History'),
              const ProfileItem(icon: AppAssets.logout, title: 'Log Out'),

              const Divider(height: 30, color: Colors.black),

              const Text(
                'App Version 2.3',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
