import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/mod/Them_Provider.dart';

class ProfileScreen extends StatefulWidget {
  /// Optional fallbacks, used only if Firebase has no value.
  final String userName;
  final String email;

  /// Called when the back arrow is tapped (switches Mainhomepage to Home tab)
  final VoidCallback? onBack;

  const ProfileScreen({
    super.key,
    this.userName = 'User Name',
    this.email = 'username@mail.com',
    this.onBack,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color avatarTan = Color(0xFFE6BF97);
  static const Color greenAccent = Color(0xFF3ECD5E);

  String _language = 'English';
  static const List<String> _languages = ['English', 'ភាសាខ្មែរ'];

  // ---------- Theme helpers ----------
  ColorScheme get _cs => Theme.of(context).colorScheme;
  Color get _surface => _cs.surface;
  Color get _text => _cs.onSurface;
  Color get _muted => _cs.onSurface.withAlpha(115);

  // ---------- Back handler (same as Favaritescreen) ----------
  void _goHome(BuildContext context) {
    if (widget.onBack != null) {
      widget.onBack!(); // switch Mainhomepage to Home tab
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _soon(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(label)));
  }

  String _nameOf(User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final mail = user?.email;
    if (mail != null && mail.contains('@')) return mail.split('@').first;
    return widget.userName;
  }

  String _emailOf(User? user) {
    final mail = user?.email?.trim();
    if (mail != null && mail.isNotEmpty) return mail;
    return widget.email;
  }

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
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
              Text(
                'Language',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: _text,
                ),
              ),
              const SizedBox(height: 8),
              ..._languages.map(
                (l) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l, style: TextStyle(color: _text)),
                  trailing: Icon(
                    l == _language
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: l == _language ? greenAccent : _muted,
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
      body: SafeArea(
        child: StreamBuilder<User?>(
          initialData: FirebaseAuth.instance.currentUser,
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _header(user),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _sections(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _header(User? user) {
    final photoUrl = user?.photoURL;
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      color: _surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              // Plain back arrow, no border — same as Favaritescreen
              GestureDetector(
                onTap: () => _goHome(context),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.arrow_back, color: _text, size: 24),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: _text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          CircleAvatar(
            radius: 32,
            backgroundColor: avatarTan,
            backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
            child: hasPhoto
                ? null
                : const Icon(Icons.person, size: 38, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            _nameOf(user),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _emailOf(user),
            style: TextStyle(fontSize: 12, color: _muted),
          ),
        ],
      ),
    );
  }

  // ---------- Sections ----------
  List<Widget> _sections() {
    final themeProvider = context.watch<ThemeProvider>();

    return [
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
                themeProvider.isDark ? 'Dark' : 'Light',
                style: TextStyle(fontSize: 12, color: _muted),
              ),
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: themeProvider.isDark,
                  activeTrackColor: greenAccent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (v) =>
                      context.read<ThemeProvider>().setDark(v),
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
                style: TextStyle(fontSize: 12, color: _muted),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 20, color: _muted),
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
    ];
  }

  // ---------- Widgets ----------
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 8),
      child: Text(text, style: TextStyle(fontSize: 12, color: _muted)),
    );
  }

  Widget _card(List<Widget> rows) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i != rows.length - 1) {
        children.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 46,
            endIndent: 14,
            color: Theme.of(context).dividerColor,
          ),
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: _surface,
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
            Icon(icon, size: 20, color: _text),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 13, color: _text),
              ),
            ),
            trailing ?? Icon(Icons.chevron_right, size: 20, color: _muted),
          ],
        ),
      ),
    );
  }
}