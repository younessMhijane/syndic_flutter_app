import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syndic_app/features/auth/login_screen.dart';
import 'package:syndic_app/features/profile_screen.dart';
import 'package:syndic_app/features/syndic/Appartement/manage_apartments_screen.dart';
import 'package:syndic_app/features/syndic/responsable/manage_responsables_screen.dart';
import 'package:syndic_app/features/syndic/payements/payments_incidents_screen.dart';

class DashboardSyndic extends StatelessWidget {
  const DashboardSyndic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildDashboardGrid(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Tableau de bord Syndic',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        _buildProfileButton(context),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle),
      tooltip: 'Mon profil',
      onPressed: () => _navigateToProfile(context),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Déconnexion',
      onPressed: () => _confirmLogout(context),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
        children: [
          _buildDashboardItem(
            context: context,
            icon: Icons.home_work_outlined,
            label: 'Appartements',
            color: Colors.blue.shade700,
            destination: const ManageApartmentsScreen(),
          ),
          _buildDashboardItem(
            context: context,
            icon: Icons.people_outline,
            label: 'Responsables',
            color: Colors.green.shade700,
            destination: const ManageResponsablesScreen(),
          ),
          _buildDashboardItem(
            context: context,
            icon: Icons.payments_outlined,
            label: 'Paiements & Incidents',
            color: Colors.orange.shade700,
            destination: const PaymentsIncidentsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Widget destination,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateTo(context, destination),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la déconnexion'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}