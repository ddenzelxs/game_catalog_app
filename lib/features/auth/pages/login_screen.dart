import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (success && mounted) {
        _emailController.clear();
        _passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(30, 30, 30, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Login',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Column(
                      children: [
                        Icon(
                              Icons.gamepad_outlined,
                              size: 80,
                              color: Colors.blueAccent,
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: -0.2, duration: 600.ms),
                        const SizedBox(height: 16),
                        const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: -0.2, duration: 600.ms),
                        const SizedBox(height: 8),
                        const Text(
                              'Log in to your ArcadiaX account',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 700.ms, delay: 100.ms)
                            .slideY(
                              begin: -0.2,
                              duration: 700.ms,
                              delay: 100.ms,
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Error message
                  if (authState.error != null)
                    Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: Text(
                            authState.error!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 100, 100),
                              fontSize: 12,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scale(begin: const Offset(0.95, 0.95)),

                  // Email Field
                  const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 200.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 200.ms),
                  const SizedBox(height: 8),
                  TextFormField(
                        controller: _emailController,
                        enabled: !authState.isLoading,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'example@email.com',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                          ),
                          fillColor: const Color.fromRGBO(50, 50, 50, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Color.fromRGBO(150, 150, 150, 1),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 200.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 200.ms),
                  const SizedBox(height: 20),

                  // Password Field
                  const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 300.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 300.ms),
                  const SizedBox(height: 8),
                  TextFormField(
                        controller: _passwordController,
                        enabled: !authState.isLoading,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            color: Color.fromRGBO(150, 150, 150, 1),
                          ),
                          fillColor: const Color.fromRGBO(50, 50, 50, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color.fromRGBO(150, 150, 150, 1),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color.fromRGBO(150, 150, 150, 1),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 300.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 300.ms),
                  const SizedBox(height: 12),

                  // Forgot Password Link
                  Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Forgot password feature coming soon!',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 350.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 350.ms),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            disabledBackgroundColor: Colors.blue[600]
                                ?.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 400.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 400.ms)
                      .scale(delay: 400.ms),
                  const SizedBox(height: 20),

                  // Sign Up Link
                  Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue[400],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 450.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 450.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
