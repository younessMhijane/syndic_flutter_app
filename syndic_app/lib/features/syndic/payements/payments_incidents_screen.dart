import 'package:flutter/material.dart';

class PaymentsIncidentsScreen extends StatelessWidget {
  const PaymentsIncidentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les paiements et incidents')),
      body: const Center(child: Text('Page de gestion des paiements et incidents')),
    );
  }
}
