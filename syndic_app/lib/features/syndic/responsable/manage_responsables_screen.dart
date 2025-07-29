import 'package:flutter/material.dart';
import 'package:syndic_app/features/syndic/responsable/responsable_list.dart';
import 'package:syndic_app/features/syndic/responsable/add_responsable_form.dart';

class ManageResponsablesScreen extends StatelessWidget {
  const ManageResponsablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestion des Responsables",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outlined, size: 28),
            tooltip: 'Ajouter un responsable',
            onPressed: () => _showAddResponsableForm(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: const ResponsableList(),
      ),
    );
  }

void _showAddResponsableForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Très important
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: AddResponsableForm(),
    ),
  );
}
}