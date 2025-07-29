import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syndic_app/features/auth/login_screen.dart';
import 'package:syndic_app/features/profile_screen.dart';
import 'package:syndic_app/features/syndic/syndic_page.dart'; // 👈 Crée cette page si elle n'existe pas encore

class DashboardSuperAdmin extends StatelessWidget {
  const DashboardSuperAdmin({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void goToSyndics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SyndicPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bienvenue, Super Admin 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.business, color: Colors.blue),
                title: const Text('Gérer les syndics'),
                subtitle: const Text('Voir, ajouter ou modifier les syndics'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => goToSyndics(context),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.bar_chart, color: Colors.green),
                title: const Text('Voir les statistiques globales'),
                subtitle: const Text('Nombre d’immeubles, syndics actifs...'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // À implémenter plus tard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fonctionnalité à venir")),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.orange),
                title: const Text('Gérer les accès'),
                subtitle: const Text('Définir les rôles et permissions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // À implémenter plus tard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fonctionnalité à venir")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
