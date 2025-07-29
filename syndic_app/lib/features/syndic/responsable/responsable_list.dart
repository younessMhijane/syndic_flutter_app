import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syndic_app/features/syndic/responsable/responsable_controller.dart';

class ResponsableList extends StatelessWidget {
  const ResponsableList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ResponsableController();

    return StreamBuilder<QuerySnapshot>(
      stream: controller.getResponsables(),
      builder: (context, snapshot) {
                if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final responsables = snapshot.data?.docs ?? [];

        if (responsables.isEmpty) {
          return const Center(child: Text("Aucun responsable trouvé"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: responsables.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final responsable = responsables[index];
            final data = responsable.data() as Map<String, dynamic>;

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage: data['photoUrl']?.isNotEmpty == true
                              ? NetworkImage(data['photoUrl']!)
                              : null,
                          child: data['photoUrl']?.isNotEmpty == true
                              ? null
                              : const Icon(Icons.person, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            data['fullName'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, responsable.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.home, 'Appartement: ${data['apartmentNumber'] ?? ''}'),
                    _buildInfoRow(Icons.email, 'Email: ${data['email'] ?? ''}'),
                    _buildInfoRow(Icons.phone, 'Téléphone: ${data['phone'] ?? ''}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Cette action supprimera définitivement le responsable et son compte. Continuer ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Supprimer",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final scaffold = ScaffoldMessenger.of(context);
      try {
        final controller = ResponsableController();
        await controller.deleteResponsable(id);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text("Responsable supprimé avec succès"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text("Erreur: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}