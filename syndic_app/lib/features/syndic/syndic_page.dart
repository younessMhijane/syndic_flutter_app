import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syndic_app/features/syndic/add_syndic_page.dart';

class SyndicPage extends StatelessWidget {
  const SyndicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(context),
      body: _buildSyndicList(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Liste des Syndics"),
      centerTitle: true,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToAddSyndicPage(context),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildSyndicList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'syndic')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget();
        }

        final syndics = snapshot.data?.docs ?? [];

        if (syndics.isEmpty) {
          return _buildEmptyListWidget();
        }

        return _buildSyndicListView(syndics);
      },
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Text(
        "Erreur lors du chargement.",
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyListWidget() {
    return const Center(
      child: Text(
        "Aucun syndic trouvé.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildSyndicListView(List<QueryDocumentSnapshot> syndics) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: syndics.length,
      itemBuilder: (context, index) => _buildSyndicCard(syndics[index]),
    );
  }

  Widget _buildSyndicCard(QueryDocumentSnapshot syndic) {
    final data = syndic.data() as Map<String, dynamic>;
    final photoUrl = data['photoUrl'] ?? '';
    final fullName = data['fullName'] ?? 'Nom inconnu';
    final immeuble = data['immeubleNom'] ?? 'Immeuble inconnu';
    final nbApparts = data['nbAppartActifs']?.toString() ?? '0';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildAvatar(photoUrl),
        title: Text(
          fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "$immeuble - $nbApparts appartements",
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, size: 24),
        onTap: () => _showSyndicDetails(syndic.id, data),
      ),
    );
  }

  Widget _buildAvatar(String photoUrl) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: photoUrl.isNotEmpty
          ? NetworkImage(photoUrl)
          : const AssetImage('assets/images/default_avatar.png')
              as ImageProvider,
      child: photoUrl.isEmpty
          ? const Icon(Icons.person, size: 28)
          : null,
    );
  }

  void _navigateToAddSyndicPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddSyndicPage()),
    );
  }

  void _showSyndicDetails(String syndicId, Map<String, dynamic> data) {
    // Implémentez la navigation vers la page de détails si nécessaire
  }
}