import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop/Mainhomepage.dart';
import 'package:shop/admin/home_admin/homead.dart';
import 'package:shop/auth/authservice.dart';
import 'package:shop/auth/signinscreen.dart';
import 'package:shop/bloc/shop_bloc.dart';
import 'package:shop/firebase_options.dart';
import 'package:shop/mod/Them_Provider.dart';
const bool kAlwaysStartAtSignIn = true;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final String text = details.exceptionAsString();
    final bool isKnownHarmlessMouseTrackerBug =
        text.contains('mouse_tracker.dart') ||
        text.contains('Cannot hit test a render box with no size') ||
        text.contains(
          'Cannot hit test a render box that has never been laid out',
        );
    if (isKnownHarmlessMouseTrackerBug) {
      return;
    }
    if (originalOnError != null) {
      originalOnError(details);
    } else {
      FlutterError.presentError(details);
    }
  };
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kAlwaysStartAtSignIn) {
    await FirebaseAuth.instance.signOut();
  }
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<ShopBloc>(create: (_) => ShopBloc()),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..load(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home: StreamBuilder<User?>(
        stream: AuthService.instance.authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // បើមិនទាន់ login → SignInScreen
          if (!snapshot.hasData) {
            return const SignInScreen();
          }
          // បើ login ស្រាប់ → ពិនិត្យ role រួច route ត្រូវ
          return const _RoleRouter();
        },
      ),
    );
  }
}
/// Reads the logged-in user's role from Firestore and routes
/// to AdminHomePage or Mainhomepage accordingly.
class _RoleRouter extends StatelessWidget {
  const _RoleRouter();
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        // កំពុងផ្ទុក
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // បើមានបញ្ហា ឬ document មិនមាន → ទៅ Mainhomepage
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          debugPrint(
              '⚠️ RoleRouter: doc missing or error — going to Mainhomepage');
          return const Mainhomepage();
        }
        final role = snapshot.data!.data()?['role'];
        debugPrint('👤 RoleRouter role: $role');
        return role == 'admin'
            ? const Homeadmin()
            : const Mainhomepage();
      },
    );
  }
}