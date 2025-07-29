import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponsableController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getResponsables() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception("Utilisateur non connecté");
    
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'responsable')
        .where('syndicId', isEqualTo: currentUserId)
        .snapshots();
  }

  Future<void> addResponsable({
    required String fullName,
    required String email,
    required String phone,
    required String apartmentNumber,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('Utilisateur non connecté');

      // 1. Créer le compte utilisateur
      const tempPassword = 'TempPassword123'; // À changer en production
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: tempPassword,
      );

      // 2. Ajouter les données dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'apartmentNumber': apartmentNumber,
        'role': 'responsable',
        'syndicId': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Envoyer l'email de réinitialisation
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Annuler la création si erreur
      if (_auth.currentUser != null) {
        await _auth.currentUser!.delete();
      }
      throw Exception('Erreur création responsable: ${e.toString()}');
    }
  }

  Future<void> deleteResponsable(String responsableId) async {
    try {
      // Supprimer d'abord le document Firestore
      await _firestore.collection('users').doc(responsableId).delete();
      
      // Supprimer le compte Auth
      await _auth.currentUser?.delete();
      

    } catch (e) {
      throw Exception("Erreur lors de la suppression: ${e.toString()}");
    }
  }
}