import 'package:flutter/material.dart';
import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/auth/data/auth_service.dart';
import 'package:Fellow4U/features/auth/login_page.dart';
import 'package:Fellow4U/features/profile/data/profile_service.dart';
import 'package:Fellow4U/features/profile/settings_page.dart';
import 'package:Fellow4U/features/profile/my_photos_page.dart';
import 'package:Fellow4U/features/trips/my_journeys_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryColor = Color(0xff16c1a3);
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  String _name = "Traveler";
  String _email = "";
  bool _isLoadingProfile = true;

  final List<String> _photosPreview = [
    "assets/icons/pr1.png",
    "assets/icons/pr2.png",
    "assets/icons/pr3.png",
    "assets/icons/longden.png",
    "assets/icons/pr4.png",
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final profile = await _profileService.getMe();
      if (!mounted) return;
      setState(() {
        _name = profile["name"]?.toString() ?? "Traveler";
        _email = profile["email"]?.toString() ?? "";
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 60),
            _buildSectionHeader("My Photos", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyPhotosPage()),
              );
            }),
            _buildPhotosGrid(),
            const SizedBox(height: 20),
            _buildSectionHeader("My Journeys", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyJourneysPage()),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  JourneyCard(
                    title: "A memory in Danang",
                    location: "Danang, Vietnam",
                    date: "Jan 20, 2020",
                    likes: "234 Likes",
                    images: [
                      'assets/icons/nemnuong.png',
                      'assets/icons/hcm.png',
                      'assets/icons/pr1.png',
                    ],
                  ),
                  SizedBox(height: 15),
                  JourneyCard(
                    title: "Sapa in spring",
                    location: "Sapa, Vietnam",
                    date: "Jan 20, 2020",
                    likes: "234 Likes",
                    images: [
                      'assets/icons/pr4.png',
                      'assets/icons/hcm.png',
                      'assets/icons/cham.png',
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/icons/nui.png',
              ), // Using mountain scenic
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200,
          color: Colors.black.withOpacity(0.2), // slight dark overlay
        ),
        Positioned(
          top: 50,
          right: 16,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
                child: const Icon(Icons.settings, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _handleLogout,
                child: const Icon(Icons.logout, color: Colors.white, size: 26),
              ),
            ],
          ),
        ),
        // Avatar crossing border
        Positioned(
          bottom: -50,
          left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/icons/yoojin.png'),
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLoadingProfile ? "Loading..." : _name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _email.isEmpty ? "No email" : _email,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid() {
    final double tileWidth = MediaQuery.of(context).size.width / 3;

    return Wrap(
      children: _photosPreview.map((path) {
        return SizedBox(
          width: tileWidth,
          height: tileWidth,
          child: Image.asset(path, fit: BoxFit.cover),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
      showUnselectedLabels: true,
      elevation: 20,
      currentIndex: 4, // Profile Tab
      onTap: (index) {
        if (index != 4) {
          Navigator.pop(context);
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: "Explore",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: "My Trips",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "2",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          label: "Notify",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}

