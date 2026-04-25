import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Fellow4U/features/profile/edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  bool _notificationsEnabled = true;

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
        title: const Text("Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 10),
            _buildSettingsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/icons/yoojin.png'),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Yoo Jin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 2),
                  Text("Traveler", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
              child: const Text("EDIT PROFILE", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSwitchTile("Notifications", Icons.notifications_none, _notificationsEnabled, (val) {
            setState(() {
              _notificationsEnabled = val;
            });
          }),
          _buildLinkTile("Languages", Icons.language),
          _buildLinkTile("Payment", Icons.credit_card),
          _buildLinkTile("Privacy & Policies", Icons.shield_outlined),
          _buildLinkTile("Feedback", Icons.message_outlined),
          _buildLinkTile("Usage", Icons.assignment_outlined),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {}, // Log out action
              child: const Text("Sign out", style: TextStyle(color: Colors.black87, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          leading: Icon(icon, color: Colors.black87, size: 24),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          trailing: CupertinoSwitch(
            value: value,
            activeColor: primaryColor,
            onChanged: onChanged,
          ),
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  Widget _buildLinkTile(String title, IconData icon) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          leading: Icon(icon, color: Colors.black87, size: 24),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () {},
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }
}

