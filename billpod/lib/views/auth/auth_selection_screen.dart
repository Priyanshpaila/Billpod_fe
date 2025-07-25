import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/neomorphic_button.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to BillPod", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              NeomorphicButton(text: "Sign Up", onTap: () => context.go('/signup')),
              NeomorphicButton(text: "Log In", onTap: () => context.go('/login')),
            ],
          ),
        ),
      ),
    );
  }
}
