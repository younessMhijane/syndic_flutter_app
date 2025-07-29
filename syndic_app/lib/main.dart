import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syndic_app/features/auth/auth_gate.dart';
import 'core/theme.dart';
import 'firebase_options.dart'; // généré par FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SyndicApp());
}

class SyndicApp extends StatelessWidget {
  const SyndicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Syndic App',
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}
