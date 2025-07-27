import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        fullName = data['fullName'] ?? '';
        phone = data['phone'] ?? '';
        role = data['role'] ?? '';
        email = data['email'] ?? user.email!;
        imageUrl = data['photoUrl'] ?? '';
        isLoading = false;
      });
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

  Future<String> uploadProfileImage(File file) async {
    final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');
    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      String newPhotoUrl = imageUrl;

      if (_newImage != null) {
        newPhotoUrl = await uploadProfileImage(_newImage!);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': fullName,
        'phone': phone,
        'photoUrl': newPhotoUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil mis à jour.")));
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
