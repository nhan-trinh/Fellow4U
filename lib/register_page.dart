import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home_page.dart';
import 'widgets/custom_header_clipper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String role = "Traveler";
  bool isTermsAccepted = false;

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
                          decoration: _buildInputDecoration("First Name", "Yoo"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
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
                    decoration: _buildInputDecoration("Email", "Type email"),
                  ),
                  const SizedBox(height: 15),

                  // PASSWORD
                  TextField(
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
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
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
