import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;
  /// Sign in with email + password
  static Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  /// Sign out
  static Future<void> signOut() => _auth.signOut();
  /// Get current user's role from Firestore ("admin" or null)
  static Future<String?> getCurrentRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return doc.data()?['role'] as String?;
  }
  /// Check if current user is admin
  static Future<bool> isAdmin() async {
    final role = await getCurrentRole();
    return role == 'admin';
  }
}