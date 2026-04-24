import 'package:flutter/material.dart';

class AddNewPlacesPage extends StatefulWidget {
  const AddNewPlacesPage({super.key});

  @override
  State<AddNewPlacesPage> createState() => _AddNewPlacesPageState();
}

class _AddNewPlacesPageState extends State<AddNewPlacesPage> {
  static const Color primaryColor = Color(0xff16c1a3);
  final TextEditingController _searchController = TextEditingController(text: "Cong");
  bool _isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New Attractions",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "DONE",
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Type a Place",
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                           if (val.isEmpty) _isAdded = false;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAdded = true;
                        _searchController.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isAdded ? Colors.grey[300] : primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: _isAdded ? Colors.white : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown list or Added Tags
            if (_isAdded)
              // Showing the added tag (Third Screen in Mockup)
              Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/congcafe.png'), // Placeholder image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 8,
                      left: 10,
                      child: Text(
                        "Cong Coffee",
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              )
            else
              // Showing the suggestions dropdown (Second Screen in Mockup)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSuggestionItem("Cong Coffee"),
                    Divider(height: 1, color: Colors.grey[200]),
                    _buildSuggestionItem("Cong Hoa Market"),
                    Divider(height: 1, color: Colors.grey[200]),
                    _buildSuggestionItem("Cong Cho"),
                    Divider(height: 1, color: Colors.grey[200]),
                    _buildSuggestionItem("Cong Church", isLast: true),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String text, {bool isLast = false}) {
    return InkWell(
      onTap: () {
        setState(() {
          _isAdded = true;
          _searchController.clear();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
