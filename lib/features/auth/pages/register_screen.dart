import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            username: _usernameController.text.trim(),
          );

      if (success && mounted) {
        _emailController.clear();
        _usernameController.clear();
        _passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
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
          'Register',
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
                              'Create Account',
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
                              'Join ArcadiaX and start gaming',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(150, 150, 150, 1),
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
                  const SizedBox(height: 30),

                  if (authState.error != null)
                    Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(55),
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

                  // ======= Username =====
                  const Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 250.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 250.ms),
                  const SizedBox(height: 8),
                  TextFormField(
                        controller: _usernameController,
                        enabled: !authState.isLoading,
                        decoration: InputDecoration(
                          hintText: 'Choose a username',
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
                            return 'Username cannot be empty';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 250.ms)
                      .slideY(begin: 0.2, duration: 800.ms, delay: 250.ms),
                  const SizedBox(height: 20),
                  // ======= Username =====

                  // ======= Email =====
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
                          hintText: 'you@email.com',
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
                            Icons.email_outlined,
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
                  // ======= Email =====

                  // ======= Password =====
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
                          hintText: 'Create a password',
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
                  const SizedBox(height: 20),
                  // ======= Password =====

                  // ======= Terms and Conditions =====
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        fillColor: WidgetStateProperty.all(
                          Colors.purple[600],
                        ),
                        side: BorderSide(
                          color: Colors.purple[600]!,
                          width: 2,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: const TextStyle(
                              color: Color.fromRGBO(150, 150, 150, 1),
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Colors.blue[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.blue[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 800.ms, delay: 350.ms),
                  const SizedBox(height: 30),
                  // ======= Terms and Conditions =====

                  SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
                            disabledBackgroundColor: Colors.purple[600]
                                ?.withAlpha(100),
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
                                  'Create Account',
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

                  Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Login',
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
