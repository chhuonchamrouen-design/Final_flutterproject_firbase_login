import 'package:flutter/material.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  // Color palette matching the design
  static const Color pinkBackground = Color(0xFFF6C6D5);
  static const Color pinkField = Color(0xFFFBE0E8);
  static const Color pinkButton = Color(0xFFFBC7D9);
  static const Color pinkAccent = Color(0xFFEE5A8A);
  static const Color textDark = Color(0xFF2B2B2B);
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  const Text(
                    'Sign in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email field
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

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
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign in button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkButton,
                        foregroundColor: textDark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Divider "or continue with"
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(
                        icon: Icons.facebook,
                        color: const Color(0xFF1877F2),
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _socialButton(
                        // Using a generic "G" for Google since brand icon
                        // packages aren't guaranteed to be available;
                        // swap for a Google logo asset/icon if desired.
                        icon: Icons.g_mobiledata,
                        color: const Color(0xFFDB4437),
                        onTap: () {},
                        iconSize: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign up prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: pinkAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: pinkField,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double iconSize = 24,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}