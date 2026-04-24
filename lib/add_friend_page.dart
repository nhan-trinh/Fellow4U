import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  static const Color primaryColor = Color(0xff16c1a3);

  final List<Map<String, dynamic>> _friends = [
    {"name": "Pena Valdez", "image": "assets/icons/lynd nguyen.png", "selected": false},
    {"name": "Gil Hajoon", "image": "assets/icons/korean.png", "selected": false},
    {"name": "Fitzgerald", "image": "assets/icons/man.png", "selected": false},
    {"name": "Kerri Barber", "image": "assets/icons/emmy.png", "selected": false},
    {"name": "WhiteCastaneda", "image": "assets/icons/linhhana.png", "selected": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context, []),
        ),
        title: const Text("Add Friends", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Return the list of selected friends
              final selectedFriends = _friends.where((f) => f['selected'] == true).toList();
              Navigator.pop(context, selectedFriends);
            },
            child: const Text("DONE", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  SizedBox(width: 10),
                  Text("Search Friend", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          ),
          
          // Horizontal Selected Friends List
          _buildSelectedAvatars(),

          // Vertical Friends List
          Expanded(
            child: ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(friend['image']),
                  ),
                  title: Text(friend['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        friend['selected'] = !friend['selected'];
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: friend['selected'] ? primaryColor : Colors.grey[300]!, width: 2),
                        color: friend['selected'] ? primaryColor : Colors.transparent,
                      ),
                      child: friend['selected'] ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAvatars() {
    final selectedFriends = _friends.where((f) => f['selected'] == true).toList();
    if (selectedFriends.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedFriends.length,
        itemBuilder: (context, index) {
          final friend = selectedFriends[index];
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(friend['image']),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        friend['selected'] = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
