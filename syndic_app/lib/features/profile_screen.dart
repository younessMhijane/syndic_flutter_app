import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syndic_app/core/services/cloudinary_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String phone = '';
  String role = '';
  String nbAppartActifs = '';
  String immeubleNom = '';
  String email = '';
  String imageUrl = '';
  File? _newImage;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          fullName = data['fullName']?.toString() ?? '';
          phone = data['phone']?.toString() ?? '';
          role = data['role']?.toString() ?? '';
          // Handle both int and String cases for nbAppartActifs
          nbAppartActifs = data['nbAppartActifs']?.toString() ?? '';
          immeubleNom = data['immeubleNom']?.toString() ?? '';
          email = data['email']?.toString() ?? user.email ?? '';
          imageUrl = data['photoUrl']?.toString() ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      try {
        String newPhotoUrl = imageUrl;

        if (_newImage != null) {
          final uploadedUrl = await CloudinaryService.uploadImage(_newImage!);
          if (uploadedUrl != null) {
            newPhotoUrl = uploadedUrl;
          }
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fullName': fullName,
          'phone': phone,
          'photoUrl': newPhotoUrl,
          'nbAppartActifs': nbAppartActifs.isNotEmpty ? int.tryParse(nbAppartActifs) ?? 0 : 0,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profil mis à jour.")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de la mise à jour: ${e.toString()}")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _newImage != null
                        ? FileImage(_newImage!)
                        : (imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null) as ImageProvider?,
                    child: _newImage == null && imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: fullName,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (val) => val == null || val.isEmpty ? 'Champ obligatoire' : null,
                onChanged: (val) => setState(() => fullName = val),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                onChanged: (val) => setState(() => phone = val),
              ),
              const SizedBox(height: 10),
              if (role == "syndic")
                TextFormField(
                  initialValue: nbAppartActifs,
                  decoration: const InputDecoration(labelText: 'Nombre d\'appartements actifs'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => setState(() => nbAppartActifs = val),
                ),
              if (role == "syndic")
                TextFormField(
                  initialValue: immeubleNom,
                  decoration: const InputDecoration(labelText: 'Nom de l\'immeuble'),
                  enabled: false,
                ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: role,
                decoration: const InputDecoration(labelText: 'Rôle'),
                enabled: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer'),
                onPressed: saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}