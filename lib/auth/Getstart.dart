import 'package:flutter/material.dart';

class Reload extends StatefulWidget {
  const Reload({super.key}); // was `new` — must match the class name
  @override
  State<Reload> createState() => _ReloadState();
}
class _ReloadState extends State<Reload> {
  static const Color buttonGreen = Color(0xFF34C759);
  static const Color shopOrange = Color(0xFFF26A21);
  static const Color logoGray = Color(0xFF4A4A4A);
  static const Color bagPink = Color(0xFFEC1E79);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
          child: Column(
            children: [
              // Logo, vertically centered in the space above the button
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/image/getstart.jpg', // put your logo here and add it to pubspec.yaml
                    width: 260,
                    errorBuilder: (context, error, stackTrace) => _fallbackLogo(),
                  ),
                ),
              ),
              // Get started button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Getsart',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// Simple stand-in logo, shown only if assets/logo.png is missing.
  Widget _fallbackLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: const [
            Icon(Icons.shopping_cart_outlined, size: 130, color: logoGray),
            Positioned(
              top: 0,
              child: Icon(Icons.shopping_bag_outlined, size: 70, color: bagPink),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 46, fontWeight: FontWeight.w500),
            children: [
              TextSpan(text: 'Online', style: TextStyle(color: logoGray)),
              TextSpan(text: 'Shop', style: TextStyle(color: shopOrange)),
            ],
          ),
        ),
        const Text(
          'Write Your Tagline Here',
          style: TextStyle(fontSize: 12, letterSpacing: 3, color: logoGray),
        ),
      ],
    );
  }
}