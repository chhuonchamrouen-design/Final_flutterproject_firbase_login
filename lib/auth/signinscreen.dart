import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/auth/authservice.dart';
import 'package:shop/auth/signupscreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService.instance;
  bool _loading = false;

  // Colors matching the design
  static const Color headerGreen = Color(0xFF34C759);
  static const Color cardColor = Color(0x1A000000); // black 10%
  static const Color avatarBlue = Color(0xFF0B6BE6);
  static const Color linkRed = Color(0xFFE5484D);
  static const Color textDark = Color(0xFF1C1C1C);

  // Horizontal inset of fields/buttons inside the card (as in the design)
  static const double _inset = 22;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  /// Runs an auth action with loading state + error handling.
  /// On success, the StreamBuilder in main.dart switches to the home screen.
  Future<void> _run(Future<void> Function() action) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      final msg = AuthService.errorMessage(e);
      if (msg != null) _snack(msg);
    } catch (_) {
      _snack('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _signIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _snack('Please enter your email and password.');
      return;
    }
    _run(() => _auth.signIn(email, password));
  }

  void _forgotPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _snack('Enter your email first, then tap "For password?".');
      return;
    }
    _run(() async {
      await _auth.resetPassword(email);
      _snack('Password reset email sent to $email');
    });
  }

  Widget _inset_(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: _inset),
        child: child,
      );

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
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: avatarBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 14),

                  // Translucent gray card (overlaps the green header)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 34, 0, 26),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _inset_(_buildTextField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: const Icon(Icons.mail_outline,
                                color: Colors.black, size: 30),
                            keyboardType: TextInputType.emailAddress,
                          )),
                          const SizedBox(height: 14),

                          _inset_(_buildTextField(
                            controller: _passwordController,
                            hint: 'Paasword',
                            icon: _lockInCircle(),
                            obscureText: true,
                          )),
                          const SizedBox(height: 6),

                          // Forgot password
                          _inset_(Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _loading ? null : _forgotPassword,
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
                          )),
                          const SizedBox(height: 22),

                          // Sign in button (white)
                          _inset_(SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5),
                                    )
                                  : const Text(
                                      'Sign in',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          )),
                          const SizedBox(height: 18),

                          // Divider (wider than the fields, like the design)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                      Divider(color: textDark, thickness: 0.8),
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
                                  child:
                                      Divider(color: textDark, thickness: 0.8),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Social icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: _loading
                                    ? null
                                    : () => _run(_auth.signInWithFacebook),
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
                                onTap: _loading
                                    ? null
                                    : () => _run(_auth.signInWithGoogle),
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: _googleG(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Sign up prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: textDark, fontSize: 12),
                              ),
                              GestureDetector(
                                onTap: _loading
                                    ? null
                                    : () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen(),
                                          ),
                                        ),
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
      enabled: !_loading,
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