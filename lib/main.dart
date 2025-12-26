import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gotnunchi/core/router/app_router.dart';
import 'package:gotnunchi/core/theme/app_theme.dart';
import 'package:gotnunchi/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Auto sign-in anonymously for testing
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    try {
      await auth.signInAnonymously();
      print('✅ Signed in anonymously: ${auth.currentUser?.uid}');
    } catch (e) {
      print('❌ Anonymous sign-in failed: $e');
    }
  }

  runApp(
    const ProviderScope(
      child: GotNunchiApp(),
    ),
  );
}

class GotNunchiApp extends StatelessWidget {
  const GotNunchiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
