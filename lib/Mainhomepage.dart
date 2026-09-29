import 'package:flutter/material.dart';
import 'package:shop/mod/appcolor.dart';
import 'package:shop/view/History/OrderHistorScreen.dart';
import 'package:shop/view/favarite/favaritescreen.dart';
import 'package:shop/view/home/homescreen.dart';
import 'package:shop/view/profile/profilescreen.dart';

class Mainhomepage extends StatefulWidget {
  const Mainhomepage({super.key});

  @override
  State<Mainhomepage> createState() => _MainhomepageState();
}

class _MainhomepageState extends State<Mainhomepage> {
  int _currentIndex = 0;

  /// Switch the bottom nav to the Home tab (index 0)
  void _goHomeTab() {
    setState(() => _currentIndex = 0);
  }

  late final List<Widget> _pages = [
    // 0 — Home
    const Homescreen(),

    // 1 — Favorites
    Favaritescreen(onBack: _goHomeTab),

    // 2 — Order History
    OrderHistoryScreen(onBack: _goHomeTab),

    // 3 — Profile  ← the fix
    ProfileScreen(onBack: _goHomeTab),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appPageBg,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.appSurface,
        selectedItemColor: const Color(0xFF3ECD5E),
        unselectedItemColor: context.appMuted,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}