import 'package:flutter/material.dart';
import 'package:Fellow4U/features/home/search_page.dart';
import 'package:Fellow4U/features/home/tour_detail_page.dart'; // import to navigate to tour details
import 'package:Fellow4U/features/home/guide_page.dart'; // import to navigate to guide details

enum SeeMoreType { guides, tours }

class SeeMorePage extends StatelessWidget {
  final SeeMoreType type;

  const SeeMorePage({super.key, required this.type});

  static const Color primaryColor = Color(0xff16c1a3);

  @override
  Widget build(BuildContext context) {
    final String title = type == SeeMoreType.guides
        ? "Book your own private local Guide and explore the city"
        : "Plenty of amazing tours are waiting for you";
    
    // Choose appropriate header images
    final String headerImage = type == SeeMoreType.guides
        ? "assets/icons/dn1.png" // Placeholder, in real app could be a specific banner
        : "assets/icons/dbh2.png"; // Placeholder

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildHeaderBackground(context, title, headerImage),
                _buildFloatingSearchBar(context),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40), // Space for overlapping search bar
          ),
          if (type == SeeMoreType.guides)
            _buildGuidesGrid()
          else
            _buildToursList(),
          SliverToBoxAdapter(
            child: const SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context, String title, String image) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.6)],
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 50,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // Title Text
        Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingSearchBar(BuildContext context) {
    return Positioned(
      bottom: -25,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 15),
              Text(
                "Hi, where do you want to explore?",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidesGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Emulating 6 items
            final guides = [
              {"name": "Tuan Tran", "image": "assets/icons/tuantran.png", "loc": "Danang, Vietnam"},
              {"name": "Emmy", "image": "assets/icons/emmy.png", "loc": "Hanoi, Vietnam"},
              {"name": "Linh Hana", "image": "assets/icons/linhhana.png", "loc": "Danang, Vietnam"},
              {"name": "Khai Ho", "image": "assets/icons/khaiho.png", "loc": "Ho Chi Minh, Vietnam"},
              {"name": "Tuan Tran", "image": "assets/icons/tuantran.png", "loc": "Danang, Vietnam"},
              {"name": "Emmy", "image": "assets/icons/emmy.png", "loc": "Hanoi, Vietnam"},
            ];
            final guide = guides[index];
            return _buildGuideCard(context, guide['name']!, guide['image']!, guide['loc']!);
          },
          childCount: 6,
        ),
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, String name, String image, String location) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GuidePage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 10,
                    child: Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 10)),
                        ),
                        const SizedBox(width: 4),
                        const Text("127 Reviews", style: TextStyle(color: Colors.white, fontSize: 8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: primaryColor, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToursList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final tours = [
              {"title": "Da Nang - Ba Na - Hoi An", "image": "assets/icons/dbh2.png", "price": "\$400.00"},
              {"title": "Melbourne - Sydney", "image": "assets/icons/mb.png", "price": "\$600.00"},
              {"title": "Hanoi - Ha Long Bay", "image": "assets/icons/hlb.png", "price": "\$300.00"},
              {"title": "Da Nang - Ba Na - Hoi An", "image": "assets/icons/dn1.png", "price": "\$400.00"},
              {"title": "Melbourne - Sydney", "image": "assets/icons/mb.png", "price": "\$600.00"},
            ];
            final tour = tours[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildTourCard(context, tour['title']!, tour['image']!, tour['price']!),
            );
          },
          childCount: 5,
        ),
      ),
    );
  }

  Widget _buildTourCard(BuildContext context, String title, String image, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TourDetailPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(image, height: 130, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
                      ),
                      const SizedBox(width: 6),
                      const Text("1247 likes", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.favorite_border, color: primaryColor, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Jan 30, 2020", style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.access_time, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("3 days", style: TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

