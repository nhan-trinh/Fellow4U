import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key});

  static const Color primaryColor = Color(0xff16c1a3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionBar(),
                  const SizedBox(height: 15),
                  const Text(
                    "Title here: Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, height: 1.3),
                  ),
                  const SizedBox(height: 15),
                  _buildAuthorRow(),
                  const SizedBox(height: 20),
                  _buildBodyText("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
                  const SizedBox(height: 15),
                  _buildBodyText("It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                  const SizedBox(height: 20),
                  _buildVideoMoc(),
                  const SizedBox(height: 20),
                  _buildSubtitle("Header here: Lorem Ipsum is simply dummy text of the printing and typesetting industry"),
                  const SizedBox(height: 15),
                  _buildBodyText("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type."),
                  const SizedBox(height: 20),
                  _buildImageRow(),
                  const SizedBox(height: 20),
                  _buildBodyText("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type."),
                  const SizedBox(height: 15),
                  _buildLinkText("It was popularised in the 1960s with the release of Letraset sheets (Link)"),
                  const SizedBox(height: 20),
                  _buildStandAloneImage('assets/icons/blogimg3.png'), // Assuming blogimg3 exists
                  const SizedBox(height: 20),
                  _buildSubtitle("Header here: Lorem Ipsum is simply dummy text of the printing and typesetting industry"),
                  const SizedBox(height: 15),
                  _buildBodyText("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type."),
                  const SizedBox(height: 20),
                  _buildStandAloneImage('assets/icons/blogimg1.png'), // Using whatever images are available
                  const SizedBox(height: 20),
                  _buildTags(),
                  const SizedBox(height: 20),
                  _buildActionBar(likes: "Like 84"),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.black12, height: 1),
                  const SizedBox(height: 20),
                  _buildCommentsSection(),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.black12, height: 1),
                  const SizedBox(height: 20),
                  _buildRelatedPosts(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/hcm.png'), // Placeholder
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 15,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBar({String likes = "124 Likes"}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite_border, color: primaryColor, size: 20),
            const SizedBox(width: 5),
            Text(likes, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.facebook, color: Colors.grey, size: 20),
            SizedBox(width: 15),
            Icon(Icons.flutter_dash, color: Colors.grey, size: 20), // Mocking Twitter bird
            SizedBox(width: 15),
            Icon(Icons.message_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthorRow() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/icons/korean.png'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Chin - Sun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Row(
              children: const [
                Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                SizedBox(width: 5),
                Text("Mar 8, 2020", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[800], fontSize: 14, height: 1.5),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
    );
  }

  Widget _buildLinkText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.blue, fontSize: 14, decoration: TextDecoration.underline),
    );
  }

  Widget _buildVideoMoc() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset('assets/icons/blogimg1.png', height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 200, color: Colors.grey[300])),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: primaryColor, size: 30),
        ),
      ],
    );
  }

  Widget _buildImageRow() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/icons/blogimg2.png', height: 120, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 120, color: Colors.grey[300])),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/icons/blogimg3.png', height: 120, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 120, color: Colors.grey[300])),
          ),
        ),
      ],
    );
  }

  Widget _buildStandAloneImage(String asset) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(asset, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 200, color: Colors.grey[300])),
    );
  }

  Widget _buildTags() {
    final tags = ["#Vietnam Local Guide", "#Hoi An", "#Da Nang Local Tour", "#Vietnam", "#Guide"];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((t) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(t, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        );
      }).toList(),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Comments (1)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Icon(Icons.keyboard_arrow_up, color: primaryColor),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text("CH", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Choi Hwa-Laa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  const Text("Mar 10, 2020", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(
                    "It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                    style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.chat_bubble_outline, color: primaryColor, size: 14),
                      SizedBox(width: 5),
                      Text("Reply", style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              const Text("Add Your Comment", style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Related Posts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 20),
        _buildRelatedCard("New Destination in Danang City", "Feb 5, 2020", 'assets/icons/dbh2.png'),
        const SizedBox(height: 15),
        _buildRelatedCard("\$1 Flight Ticket", "Feb 3, 2020", 'assets/icons/window.png'), // placeholder
        const SizedBox(height: 15),
        _buildRelatedCard("Visit Korea in this Tet Holiday", "Jan 28, 2020", 'assets/icons/korean.png'), // placeholder
      ],
    );
  }

  Widget _buildRelatedCard(String title, String date, String assetImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 3),
        Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(assetImage, height: 100, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 100, color: Colors.grey[300])),
        ),
      ],
    );
  }
}
