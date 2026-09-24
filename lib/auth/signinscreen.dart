import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Colors matching the design
  static const Color headerGreen = Color(0xFF34C759);
  static const Color cardColor = Color(0x1A000000); // black 10%
  static const Color avatarBlue = Color(0xFF0B6BE6);
  static const Color linkRed = Color(0xFFE5484D);
  static const Color textDark = Color(0xFF1C1C1C);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Curved green header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: headerGreen,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(width / 2, 90),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Title (white, above avatar)
                  const Text(
                    'Sing in',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Avatar
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: avatarBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Translucent gray card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: const Icon(Icons.mail_outline,
                                color: Colors.black, size: 28),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Paasword',
                            icon: _lockInCircle(),
                            obscureText: true,
                          ),
                          const SizedBox(height: 6),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'For password?',
                                style: TextStyle(color: textDark, fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign in button (white)
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Divider
                          Row(
                            children: const [
                              Expanded(
                                child: Divider(color: textDark, thickness: 0.8),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  'or contiue with',
                                  style: TextStyle(
                                    color: textDark,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: textDark, thickness: 0.8),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Social icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(30),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.facebook,
                                    color: Color(0xFF1877F2),
                                    size: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 28),
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: _googleG(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Sign up prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: textDark, fontSize: 12),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Sigup',
                                  style: TextStyle(
                                    color: linkRed,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Widget icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(color: textDark, fontSize: 16),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: icon,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// Lock icon inside a circle outline.
  Widget _lockInCircle() {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.6),
      ),
      child: const Icon(Icons.lock_outline, size: 15, color: Colors.black),
    );
  }

  /// Multicolor "G". For the exact Google logo, use an asset image instead
  /// (e.g. Image.asset('assets/google.png', width: 28)).
  Widget _googleG() {
    return ShaderMask(
      shaderCallback: (bounds) => const SweepGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
          Color(0xFF4285F4),
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(bounds),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.1,
        ),
      ),
    );
  }
}