import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syndic_app/core/services/user_service.dart';
import 'package:syndic_app/features/auth/forgot_password_screen.dart';
import '../../core/services/auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }
    setState(() => isLoading = true);

    try {
final userCredential = await _authService.login(
  emailController.text.trim(),
  passwordController.text.trim(),
);

final uid = userCredential.user!.uid;
final userService = UserService();
final role = await userService.getUserRole(uid);

if (role == 'superadmin') {
  Navigator.pushReplacementNamed(context, '/dashboardSuperAdmin');
} else if (role == 'syndic') {
  Navigator.pushReplacementNamed(context, '/dashboardSyndic');
} else if (role == 'responsable') {
  Navigator.pushReplacementNamed(context, '/dashboardResponsable');
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Rôle inconnu, accès refusé')),
  );
}

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Erreur de connexion")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/images/login.png', height: 120),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Connexion"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  );
                },
                child: const Text("Mot de passe oublié ?"),
              ),
              

            ],
          ),
        ),
      ),
    );
  }
}
