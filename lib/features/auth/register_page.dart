import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/auth/data/auth_service.dart';
import 'package:Fellow4U/features/home/home_page.dart';
import 'package:Fellow4U/shared/widgets/custom_header_clipper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String role = "Traveler";
  bool isTermsAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (firstName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Confirm password does not match")),
      );
      return;
    }
    if (!isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept Terms & Conditions")),
      );
      return;
    }

    final fullName = "$firstName $lastName".trim();

    setState(() => _isLoading = true);
    try {
      await _authService.register(email: email, password: password, name: fullName);
      await _authService.login(email: email, password: password);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
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

  InputDecoration _buildInputDecoration(String label, String hint) {
    const Color primaryColor = Color(0xff16c1a3);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      contentPadding: const EdgeInsets.only(bottom: 0, top: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff16c1a3);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER with CustomClipper
            ClipPath(
              clipper: CustomHeaderClipper(),
              child: Container(
                height: 180, // slightly shorter for signup
                width: double.infinity,
                color: primaryColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Image.asset(
                      'assets/icons/b_logo.png', // Or 'img/b_logo.png' 
                      height: 60,
                      errorBuilder: (context, error, stackTrace) =>
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.flight, color: primaryColor, size: 40),
                        ),
                    ),
                  ),
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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // RADIO BUTTONS
                  Row(
                    children: [
                      Radio<String>(
                        value: "Traveler",
                        groupValue: role,
                        activeColor: primaryColor,
                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),
                      const Text("Traveler", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 30),
                      Radio<String>(
                        value: "Guide",
                        groupValue: role,
                        activeColor: primaryColor,
                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),
                      const Text("Guide", style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // NAME
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: _buildInputDecoration("First Name", "Yoo"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: _buildInputDecoration("Last Name", "Jin"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // COUNTRY
                  TextField(
                    decoration: _buildInputDecoration("Country", "Country"),
                  ),
                  const SizedBox(height: 15),

                  // EMAIL
                  TextField(
                    controller: _emailController,
                    decoration: _buildInputDecoration("Email", "Type email"),
                  ),
                  const SizedBox(height: 15),

                  // PASSWORD
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _buildInputDecoration("Password", "Type password"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      "Password must be more than 6 letters",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),

                  // CONFIRM PASSWORD
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: _buildInputDecoration("Confirm Password", "******"),
                  ),
                  const SizedBox(height: 25),

                  // TERMS CHECKBOX
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: isTermsAccepted,
                          activeColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isTermsAccepted = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "By Signing Up, you agree to our ",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            children: [
                              TextSpan(
                                text: "Terms & Conditions",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // SIGNUP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
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
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // SIGN IN LINK
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

