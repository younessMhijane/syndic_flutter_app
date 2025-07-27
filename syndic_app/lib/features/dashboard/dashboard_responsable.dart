import 'package:flutter/material.dart';

class DashboardResponsable extends StatelessWidget {
  const DashboardResponsable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsable Dashboard')),
      
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Voir les factures'),
            Text('Signaler un incident'),
            Text('Profil personnel')
          ],
        ),
      ),
    );
  }
}