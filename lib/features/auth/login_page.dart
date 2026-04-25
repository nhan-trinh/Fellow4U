import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/auth/data/auth_service.dart';
import 'package:Fellow4U/features/auth/register_page.dart';
import 'package:Fellow4U/features/home/home_page.dart';
import 'package:Fellow4U/features/auth/forgot_password_page.dart';
import 'package:Fellow4U/shared/widgets/custom_header_clipper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // Helper widget cho icon máº¡ng xĂ£ há»™i
  Widget _buildSocialIcon(String assetPath) {
    return GestureDetector(
      onTap: () {
        // Handle social login
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.login(email: email, password: password);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff16c1a3);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER vá»›i CustomClipper
            ClipPath(
              clipper: CustomHeaderClipper(),
              child: Container(
                height: 250,
                width: double.infinity,
                color: primaryColor,
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 30,
                      child: Image.asset(
                        'assets/icons/logo.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 40,
                      child: Image.asset(
                        'assets/icons/plane.png',
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // FORM SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Welcome back, Yoo Jin",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                  const SizedBox(height: 30),

                  // EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      hintText: "yoojin@gmail.com",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      hintText: "******",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 5),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // FORGOT PASSWORD
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // SIGN IN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "SIGN IN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (_isLoading)
                    const Text(
                      "Signing in...",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  if (_isLoading) const SizedBox(height: 10),
                  
                  // SOCIAL LOGIN TEXT
                  const Center(
                    child: Text(
                      "or sign in with",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SOCIAL LOGIN ICONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon('assets/icons/facebook.png'),
                      const SizedBox(width: 30),
                      _buildSocialIcon('assets/icons/talk.png'),
                      const SizedBox(width: 30),
                      _buildSocialIcon('assets/icons/line.png'),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // SIGN UP LINK
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

