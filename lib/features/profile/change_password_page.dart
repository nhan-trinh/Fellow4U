import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

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
        title: const Text("Change Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("SAVE", style: TextStyle(color: Color(0xff16c1a3), fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Current Password", "â€¢â€¢â€¢â€¢â€¢â€¢"),
            const SizedBox(height: 25),
            _buildTextField("New Password", "â€¢â€¢â€¢â€¢â€¢â€¢"),
            const SizedBox(height: 25),
            _buildTextField("Retype New Password", "â€¢â€¢â€¢â€¢â€¢â€¢"),
          ],
        ),
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

