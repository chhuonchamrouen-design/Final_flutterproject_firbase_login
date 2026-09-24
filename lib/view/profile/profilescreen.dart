import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  final String userName;
  final String email;
  const ProfileScreen({
    super.key,
    this.userName = 'User Name',
    this.email = 'username@mail.com',
  });
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  // ---------- palette (matches the rest of the app) ----------
  static const Color pageBackground = Color(0xFFF4F4F6);
  static const Color avatarTan = Color(0xFFE6BF97);
  static const Color greenAccent = Color(0xFF3ECD5E);
  bool _darkMode = false;
  String _language = 'English';
  static const List<String> _languages = ['English', 'ភាសាខ្មែរ'];

  void _soon(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(label)));
  }
  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Language',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ..._languages.map(
                (l) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l),
                  trailing: Icon(
                    l == _language
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: l == _language ? greenAccent : Colors.black38,
                  ),
                  onTap: () {
                    setState(() => _language = l);
                    Navigator.pop(sheetContext);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Header (white) ----------
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black54),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            size: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  // avatar
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: avatarTan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.email,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),

            // ---------- Sections ----------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                children: [
                  _sectionLabel('Account'),
                  _card([
                    _tile(
                      Icons.account_circle_outlined,
                      'Manage Profile',
                      onTap: () => _soon('Manage Profile'),
                    ),
                    _tile(
                      Icons.lock_outline,
                      'Security & Privacy',
                      onTap: () => _soon('Security & Privacy'),
                    ),
                  ]),
                  _sectionLabel('Preferences'),
                  _card([
                    _tile(
                      Icons.notifications_none_rounded,
                      'Notifications',
                      onTap: () => _soon('Notifications'),
                    ),
                    _tile(
                      Icons.dark_mode_outlined,
                      'Dark Mode',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _darkMode ? 'Dark' : 'Light',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.75,
                            child: Switch(
                              value: _darkMode,
                              activeColor: greenAccent,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              // NOTE: this only flips the switch. To change the
                              // real app theme, lift this value into your bloc
                              // or a ThemeMode notifier above MaterialApp.
                              onChanged: (v) => setState(() => _darkMode = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _tile(
                      Icons.translate,
                      'Language',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _language,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      onTap: _pickLanguage,
                    ),
                  ]),
                  _sectionLabel('Support'),
                  _card([
                    _tile(
                      Icons.help_outline,
                      'Help Center',
                      onTap: () => _soon('Help Center'),
                    ),
                    _tile(
                      Icons.menu_book_outlined,
                      'Terms & Policies',
                      onTap: () => _soon('Terms & Policies'),
                    ),
                    _tile(
                      Icons.info_outline,
                      'About Us',
                      onTap: () => _soon('About Us'),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Widgets ----------
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.black45),
      ),
    );
  }

  // White rounded card with indented dividers between rows
  Widget _card(List<Widget> rows) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i != rows.length - 1) {
        children.add(
          const Divider(
            height: 1,
            thickness: 1,
            indent: 46,
            endIndent: 14,
            color: Color(0xFFEDEDED),
          ),
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _tile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right, size: 20, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}