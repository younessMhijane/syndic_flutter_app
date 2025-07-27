import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Crée un nouvel utilisateur + son document Firestore
  Future<UserCredential> signup({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    bool isSuperAdmin = false,
  }) async {
    // 1. Créer le compte avec Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Ajouter les infos Firestore
  await _firestore.collection('users').doc(userCredential.user!.uid).set({
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'profilePhotoUrl': '',
    'createdAt': FieldValue.serverTimestamp(),
    'isSuperAdmin': isSuperAdmin,
    'role': isSuperAdmin ? 'superadmin' : 'syndic', // Ajout du rôle
    'fcmToken': '',
  });


    return userCredential;
  }

  /// Login classique
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
