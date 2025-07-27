import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syndic_app/features/auth/login_screen.dart';
import 'package:syndic_app/features/profile_screen.dart'; // 👈 Assure-toi que ce fichier existe

class DashboardSuperAdmin extends StatelessWidget {
  const DashboardSuperAdmin({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle), // 👤 Icône de profil
            tooltip: 'Mon profil',
            onPressed: () => goToProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gérer les syndics'),
            Text('Voir les statistiques globales'),
            Text('Gérer les accès')
          ],
        ),
      ),
    );
  }
}
