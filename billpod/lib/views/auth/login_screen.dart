import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../widgets/neomorphic_input.dart';
import '../widgets/neomorphic_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  void handleLogin() async {
    if (!mounted) return;
    setState(() => loading = true);

    await ref.read(authProvider.notifier).login(
          emailController.text,
          passwordController.text,
        );

    if (!mounted) return;
    setState(() => loading = false);

    final state = ref.read(authProvider);
    if (state.status == AuthStatus.authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login successful.")),
      );
      // No redirect here — AuthGuard will handle it
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message ?? "Login failed")),
      );
    }
  }

  @override
  void dispose() {
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
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          SvgPicture.asset('assets/images/login_illustration.svg', height: 390),
          const SizedBox(height: 24),
          const Text(
            'Welcome Back',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          NeomorphicInput(controller: emailController, hint: 'Email'),
          NeomorphicInput(
            controller: passwordController,
            hint: 'Password',
            obscure: true,
          ),
          loading
              ? const Center(child: CircularProgressIndicator())
              : NeomorphicButton(text: 'Login', onTap: handleLogin),
        ],
      ),
    );
  }
}
