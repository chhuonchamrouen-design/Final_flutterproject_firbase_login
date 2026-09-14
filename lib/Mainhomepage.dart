import 'package:flutter/material.dart';
import 'package:shop/view/cart/cartscreen.dart';
import 'package:shop/view/favarite/favaritescreen.dart';
import 'package:shop/view/home/homescreen.dart';
import 'package:shop/view/profile/profilescreen.dart';
import 'package:shop/view/search/searchscreen.dart';

class Mainhomepage extends StatefulWidget {
  const Mainhomepage({super.key});
  @override
  State<Mainhomepage> createState() => _MainhomepageState();
}
class _MainhomepageState extends State<Mainhomepage> {
  int currentpage = 0;
  final List<Widget> pages = const [
    Homescreen(),
    Searchscreen(),
    Favaritescreen(),
    CartScreen(),
    Profilescreen(),
  ];
  static const Color _activeColor = Color(0xFF34C759); // green
  static const Color _inactiveColor = Colors.black45;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentpage],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(icon: Icons.home_outlined, label: 'Home', index: 0),
                  _navItem(icon: Icons.search, label: 'Search', index: 1),
                  _navItem(
                    icon: Icons.favorite_border,
                    label: 'Saved',
                    index: 2,
                  ),
                  _navItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Cart',
                    index: 3,
                  ),
                  _navItem(
                    icon: Icons.person_outline,
                    label: 'Account',
                    index: 4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ---- iOS-style home indicator bar ----
              Container(
                width: 120,
                height: 4,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentpage == index;
    final Color color = isSelected ? _activeColor : _inactiveColor;

    return GestureDetector(
      onTap: () => setState(() => currentpage = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
