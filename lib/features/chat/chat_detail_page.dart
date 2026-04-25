import 'package:flutter/material.dart';
import 'package:Fellow4U/features/chat/add_friend_page.dart';

class ChatDetailPage extends StatefulWidget {
  final String contactName;
  final String contactImage;

  const ChatDetailPage({super.key, required this.contactName, required this.contactImage});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  final TextEditingController _msgController = TextEditingController();
  
  bool _isTyping = false;
  bool _isRecording = false;

  List<Map<String, dynamic>> _groupMembers = []; // Contains added friends
  
  final List<Map<String, dynamic>> _messages = [
    {
      "sender": "Emmy",
      "isMe": false,
      "text": "Hi, this is Emmy\nIt is a long established fact that a reader will be distracted by the",
      "time": "10:01 AM",
      "image": "assets/icons/emmy.png",
    },
    {
      "sender": "Me",
      "isMe": true,
      "text": "as opposed to using 'Content here",
      "time": "10:31 AM",
    },
    {
      "sender": "Me",
      "isMe": true,
      "text": "There are many variations of passages",
      "time": "10:31 AM",
    },
  ];

  @override
  void initState() {
    super.initState();
    _msgController.addListener(() {
      setState(() {
        _isTyping = _msgController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Very light background to make white bubbles pop
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: [
                const Center(
                  child: Text("Jan 28, 2020", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                ..._messages.map((m) => _buildMessageBubble(m)).toList(),
              ],
            ),
          ),
          _isRecording ? _buildVoiceRecordingBar() : _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAppBarAvatars(),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: primaryColor),
          onPressed: () async {
            final addedFriends = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFriendPage()),
            );
            if (addedFriends != null && (addedFriends as List).isNotEmpty) {
              setState(() {
                _groupMembers.addAll(addedFriends.cast<Map<String, dynamic>>());
                // Add a mock message from the first added friend to simulate group mode!
                _messages.add({
                  "sender": _groupMembers[0]['name'],
                  "isMe": false,
                  "text": "Hi everyone! It is a long established fact.",
                  "time": "10:45 AM",
                  "image": _groupMembers[0]['image'],
                });
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildAppBarAvatars() {
    if (_groupMembers.isEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage(widget.contactImage),
      );
    } else {
      // Stack group avatars
      return SizedBox(
        width: 80,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 40,
              child: CircleAvatar(radius: 17, backgroundImage: AssetImage(_groupMembers[0]['image'])),
            ),
            Positioned(
              left: 20,
              child: CircleAvatar(radius: 17, backgroundImage: AssetImage(widget.contactImage)),
            ),
            Positioned(
              left: 0,
              child: CircleAvatar(radius: 17, backgroundImage: const AssetImage('assets/icons/tuantran.png')), // My avatar implicitly
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    bool isMe = msg['isMe'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundImage: AssetImage(msg['image'])),
                const SizedBox(width: 8),
                Text(msg['sender'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                const SizedBox(width: 5),
                Text(msg['time'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe)
                Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 5),
                  child: Text(msg['time'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.white : primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: Radius.circular(isMe ? 15 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 15),
                    ),
                    boxShadow: isMe
                        ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: Text(
                    msg['text'],
                    style: TextStyle(
                      color: isMe ? Colors.black87 : Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.mic_none, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _isRecording = true;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.image_outlined, color: Colors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type message",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (_isTyping)
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              )
            else
              const SizedBox(width: 38), // placeholder to maintain padding when button disappears
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceRecordingBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black87, size: 28),
              onPressed: () {
                setState(() {
                  _isRecording = false; // Cancel recording
                });
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("0:12", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: primaryColor.withOpacity(0.3), width: 4),
                    boxShadow: [
                      BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 15, spreadRadius: 5),
                    ],
                  ),
                  child: const Icon(Icons.mic, color: primaryColor, size: 30),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isRecording = false; // Send voice
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_msgController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          "sender": "Me",
          "isMe": true,
          "text": _msgController.text.trim(),
          "time": "Just now",
        });
        _msgController.clear();
        _isTyping = false;
      });
    }
  }
}

