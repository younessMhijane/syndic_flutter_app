import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dashboard/dashboard_screen.dart';
import '../dashboard/dashboard_superadmin.dart';
import '../dashboard/dashboard_syndic.dart';
import 'login_screen.dart';
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const LoginScreen(); // profil utilisateur inexistant
              }

              final role = userSnapshot.data!.get('role');
              if (role == 'superadmin') {
                return const DashboardSuperAdmin();
              } else if (role == 'syndic') {
                return const DashboardSyndic();
              } else {
                return const DashboardScreen(); // résident
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
