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
    Cartscreen(),
    Favaritescreen(),
    Profilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentpage],
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // ================= DARK PILL BAR WITH NOTCH =================
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _navIcon(icon: Icons.home_outlined, index: 0),
                    _navIcon(icon: Icons.search, index: 1),
                    const SizedBox(width: 60), // space for the raised button
                    _navIcon(icon: Icons.favorite_border, index: 3),
                    _navIcon(icon: Icons.person_outline, index: 4),
                  ],
                ),
              ),
            ),
            // ================= RAISED CENTER BUTTON =================
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => setState(() => currentpage = 2),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9B6DFF), Color(0xFF6C3CE9)],
                    ),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon({required IconData icon, required int index}) {
    final isSelected = currentpage == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentpage = index),
        behavior: HitTestBehavior.opaque,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFFF7A45) : Colors.white70,
          size: 26,
        ),
      ),
    );
  }
}
