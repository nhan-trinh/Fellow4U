import 'package:flutter/material.dart';
import 'package:Fellow4U/features/trips/add_new_places_page.dart';

class CreateNewTripPage extends StatefulWidget {
  const CreateNewTripPage({super.key});

  @override
  State<CreateNewTripPage> createState() => _CreateNewTripPageState();
}

class _CreateNewTripPageState extends State<CreateNewTripPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  int _travelersCount = 1;
  final List<String> _selectedAttractions = ["Dragon Bridge", "My Khe Beach"];

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
        title: const Text(
          "Create New Trip",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldTitle("Where you want to explore"),
                _buildTextField(Icons.location_on_outlined, "Danang, Vietnam"),
                const SizedBox(height: 25),

                _buildFieldTitle("Date"),
                _buildTextField(Icons.calendar_today, "mm/dd/yy"),
                const SizedBox(height: 25),

                _buildFieldTitle("Time"),
                Row(
                  children: [
                    Expanded(child: _buildTextField(Icons.access_time, "From")),
                    const SizedBox(width: 20),
                    Expanded(child: _buildTextField(Icons.access_time, "To")),
                  ],
                ),
                const SizedBox(height: 25),

                _buildFieldTitle("Number of travelers"),
                const SizedBox(height: 10),
                _buildTravelersCounter(),
                const SizedBox(height: 25),

                _buildFieldTitle("Fee"),
                _buildFeeField(),
                const SizedBox(height: 25),

                _buildFieldTitle("Guide's Language"),
                _buildTextField(Icons.public, "Korean, English"),
                const SizedBox(height: 25),

                _buildFieldTitle("Attractions"),
                const SizedBox(height: 15),
                _buildAttractionsGrid(),
              ],
            ),
          ),

          // Sticky Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "DONE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    );
  }

  Widget _buildTextField(IconData icon, String hint) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hint,
                style: TextStyle(
                  color:
                      hint.contains("mm/dd/yy") ||
                          hint == "From" ||
                          hint == "To"
                      ? Colors.grey
                      : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  Widget _buildTravelersCounter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCounterButton(Icons.arrow_drop_down, () {
          if (_travelersCount > 1) {
            setState(() {
              _travelersCount--;
            });
          }
        }),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black54)),
          ),
          child: Text("$_travelersCount", style: const TextStyle(fontSize: 16)),
        ),
        _buildCounterButton(Icons.arrow_drop_up, () {
          setState(() {
            _travelersCount++;
          });
        }),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
    );
  }

  Widget _buildFeeField() {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.monetization_on_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Fee",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const Text(
              "(\$/hour)",
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  Widget _buildAttractionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.8,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNewPlacesPage()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: primaryColor, size: 18),
                SizedBox(width: 5),
                Text(
                  "Add New",
                  style: TextStyle(color: primaryColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        _buildAttractionItem(
          "Dragon Bridge",
          "assets/icons/dn1.png",
        ), // Using congcafe as placeholder
        _buildAttractionItem("Cham Museum", "assets/icons/cham.png"),
        _buildAttractionItem("My Khe Beach", "assets/icons/mykhe.png"),
      ],
    );
  }

  Widget _buildAttractionItem(String title, String image) {
    bool isSelected = _selectedAttractions.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAttractions.remove(title);
          } else {
            _selectedAttractions.add(title);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 10,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

