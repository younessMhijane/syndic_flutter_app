import 'package:flutter/material.dart';

class ManageApartmentsScreen extends StatelessWidget {
  const ManageApartmentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les appartements')),
      body: const Center(child: Text('Page de gestion des appartements')),
    );
  }
}
