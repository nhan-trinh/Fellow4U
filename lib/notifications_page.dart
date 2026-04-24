import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const Color primaryColor = Color(0xff16c1a3);

  final List<Map<String, dynamic>> _notifications = [
    {
      "type": "accepted",
      "image": "assets/icons/tuantran.png",
      "message": "Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2020",
      "date": "Jan 16",
    },
    {
      "type": "offer",
      "image": "assets/icons/emmy.png",
      "message": "Emmy sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2020",
      "date": "Jan 16",
    },
    {
      "type": "system_review",
      "image": "assets/icons/logo_system.png", // Will construct a mock logo widget
      "message": "Thanks! Your trip in Danang, Vietnam on Jan 20, 2020 has been finished. Please leave a review for the guide Tuan Tran.",
      "date": "Jan 24",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/dn1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.search, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatarWithBadge(notif),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['message'],
                  style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  notif['date'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (notif['type'] == 'system_review') ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(120, 32),
                    ),
                    child: const Text("Leave Review", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithBadge(Map<String, dynamic> notif) {
    Widget mainAvatar;
    Widget badge;

    if (notif['type'] == 'system_review') {
      mainAvatar = Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            "b",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'serif'),
          ),
        ),
      );
      badge = Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue[400],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.edit, color: Colors.white, size: 8),
      );
    } else {
      mainAvatar = CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage(notif['image']),
      );

      if (notif['type'] == 'accepted') {
        badge = Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xff8bc34a), // Light Green
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 10),
        );
      } else {
        // offer
        badge = Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.amber, 
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.list_alt, color: Colors.white, size: 9),
        );
      }
    }

    return Stack(
      children: [
        mainAvatar,
        Positioned(
          bottom: 0,
          right: 0,
          child: badge,
        ),
      ],
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
      currentIndex: 3, // Notifications Tab
      onTap: (index) {
        if (index != 3) {
          Navigator.pop(context); // Go back if another tab is tapped, handling basic flow
        }
      },
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        const BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "My Trips"),
        const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications),
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
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          label: "Notify",
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
