import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Fellow4U/features/auth/check_email_page.dart';
import 'package:Fellow4U/shared/widgets/custom_header_clipper.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff16c1a3);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            ClipPath(
              clipper: CustomHeaderClipper(),
              child: Container(
                height: 250,
                width: double.infinity,
                color: primaryColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      'assets/icons/b_logo.png', // Or 'img/b_logo.png'
                      height: 80,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.flight,
                          color: primaryColor,
                          size: 50,
                        ),
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
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Input your email, we will send you an instruction to reset your password.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // EMAIL
                  TextField(
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
                  const SizedBox(height: 40),

                  // SEND BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckEmailPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "SEND",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // BACK TO SIGN IN
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Back to ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
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

