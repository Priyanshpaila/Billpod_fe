import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../widgets/neomorphic_input.dart';
import '../widgets/neomorphic_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  void handleSignup() async {
    if (!mounted) return;
    setState(() => loading = true);

    final res = await AuthService.signup(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (res.contains("successful")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful. Please login.")),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.go('/auth'),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          SvgPicture.asset(
            'assets/images/signup_illustration.svg',
            height: 390,
          ),
          const SizedBox(height: 24),
          const Text(
            'Create an Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          NeomorphicInput(controller: nameController, hint: 'Name'),
          NeomorphicInput(controller: emailController, hint: 'Email'),
          NeomorphicInput(
            controller: passwordController,
            hint: 'Password',
            obscure: true,
          ),
          loading
              ? const Center(child: CircularProgressIndicator())
              : NeomorphicButton(text: 'Sign Up', onTap: handleSignup),
        ],
      ),
    );
  }
}
