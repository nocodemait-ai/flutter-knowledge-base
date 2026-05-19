import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: Card(
              key: ValueKey(isLogin),
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, size: 64, color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(isLogin ? "Welcome Back" : "Create Account", style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                        validator: (v) => v!.contains('@') ? null : "Enter valid email",
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                        validator: (v) => v!.length >= 6 ? null : "Min 6 characters",
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.go('/dashboard');
                            }
                          },
                          child: Text(isLogin ? "Sign In" : "Register"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(isLogin ? "Create Account" : "Already have an account? Sign In"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}