import 'package:flutter/material.dart';
import 'package:Fellow4U/features/profile/change_password_page.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static const Color primaryColor = Color(0xff16c1a3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("SAVE", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            _buildAvatar(),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(child: _buildTextField("First Name", "Yoo")),
                const SizedBox(width: 20),
                Expanded(child: _buildTextField("Last Name", "Jin")),
              ],
            ),
            const SizedBox(height: 25),
            _buildTextField("Password", "â€¢â€¢â€¢â€¢â€¢â€¢"),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
                },
                child: const Text("Change Password", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage('assets/icons/yoojin.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }
}

