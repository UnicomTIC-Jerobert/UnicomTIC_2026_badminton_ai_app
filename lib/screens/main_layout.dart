import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'social_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // List of screens to display based on the selected tab
  final List<Widget> _screens = const [
    HomeScreen(),
    ChatScreen(),
    SocialScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // The Mobile-First Wrapper
    return Scaffold(
      backgroundColor: Colors.grey[200], // Darker background for desktop
      body: Center(
        child: ConstrainedBox(
          // Forces the app to be a maximum of 450 pixels wide (Phone size)
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: Colors.white, // App background
            body: SafeArea(child: _screens[_currentIndex]),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Courts'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy),
                  label: 'AI Bot',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Social',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
