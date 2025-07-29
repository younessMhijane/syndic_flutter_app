import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';

class AddSyndicPage extends StatefulWidget {
  @override
  State<AddSyndicPage> createState() => _AddSyndicPageState();
}

class _AddSyndicPageState extends State<AddSyndicPage> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final immeubleController = TextEditingController();
  final nbAppartsController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

void _saveSyndic() async {
  if (_formKey.currentState!.validate()) {
    try {
      final authService = AuthService();
      final email = emailController.text.trim();
      final passwordTemporaire = 'Password123'; // ou génère un mot de passe temporaire
      final fullName = fullNameController.text.trim();
      final phone = phoneController.text.trim();
      final immeuble = immeubleController.text.trim();
      final nbApparts = int.parse(nbAppartsController.text.trim());

      // Créer le compte Auth + Firestore
      final userCredential = await authService.signup(
        email: email,
        password: passwordTemporaire,
        fullName: fullName,
        phone: phone,
        isSuperAdmin: false,
      );

      // Ajouter les infos supplémentaires dans le document utilisateur
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).update({
        'immeubleNom': immeuble,
        'nbAppartActifs': nbApparts,
      });

      // Envoyer un email de réinitialisation de mot de passe
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le compte a été créé. Un email de réinitialisation a été envoyé.'),
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur : $e'),
      ));
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un Syndic")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: fullNameController, decoration: InputDecoration(labelText: "Nom complet"), validator: (v) => v!.isEmpty ? "Obligatoire" : null),
              TextFormField(controller: emailController, decoration: InputDecoration(labelText: "Email"), validator: (v) => v!.isEmpty ? "Obligatoire" : null),
              TextFormField(controller: phoneController, decoration: InputDecoration(labelText: "Téléphone"), validator: (v) => v!.isEmpty ? "Obligatoire" : null),
              TextFormField(controller: immeubleController, decoration: InputDecoration(labelText: "Nom de l'immeuble"), validator: (v) => v!.isEmpty ? "Obligatoire" : null),
              TextFormField(controller: nbAppartsController, decoration: InputDecoration(labelText: "Nombre d'appartements"), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? "Obligatoire" : null),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveSyndic, child: Text("Enregistrer")),
            ],
          ),
        ),
      ),
    );
  }
}
