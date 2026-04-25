import 'package:flutter/material.dart';

class MyPhotosPage extends StatefulWidget {
  const MyPhotosPage({super.key});

  @override
  State<MyPhotosPage> createState() => _MyPhotosPageState();
}

class _MyPhotosPageState extends State<MyPhotosPage> {
  static const Color primaryColor = Color(0xff16c1a3);

  bool _isAdding = false;

  final List<Map<String, dynamic>> _photos = [
    {"image": "assets/icons/pr2.png", "selected": false},
    {
      "image": "assets/icons/cham.png",
      "selected": true,
    }, // Default true to mimic mockup Add Photos state
    {"image": "assets/icons/hcm.png", "selected": false},
    {"image": "assets/icons/dinhdoclap.png", "selected": true},
    {"image": "assets/icons/hoguom.png", "selected": false},
    {"image": "assets/icons/hanoi.png", "selected": true},
    {"image": "assets/icons/pr1.png", "selected": false},
    {"image": "assets/icons/nemnuong.png", "selected": false},
    {"image": "assets/icons/comtam.png", "selected": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isAdding ? Icons.close : Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            if (_isAdding) {
              setState(() {
                _isAdding = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _isAdding ? "Add Photos" : "My Photos",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: _isAdding
            ? [
                TextButton(
                  onPressed: () {
                    // Simulating adding completion
                    setState(() {
                      _isAdding = false;
                    });
                  },
                  child: const Text(
                    "DONE",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2), // slight padding for grid
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                children: [
                  _buildFirstTile(),
                  ..._photos.map((photo) => _buildPhotoTile(photo)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstTile() {
    // Width is approx 1/3 of screen width minus spacing
    final double width = (MediaQuery.of(context).size.width - 8) / 3;
    final double height = width;

    return GestureDetector(
      onTap: () {
        if (!_isAdding) {
          setState(() {
            _isAdding = true;
          });
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isAdding ? Icons.camera_alt_outlined : Icons.add,
              color: primaryColor,
              size: 28,
            ),
            const SizedBox(height: 5),
            Text(
              _isAdding ? "Take Photo" : "Add Photos",
              style: const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(Map<String, dynamic> photo) {
    final double width = (MediaQuery.of(context).size.width - 8) / 3;
    final double height = width;

    return GestureDetector(
      onTap: () {
        if (_isAdding) {
          setState(() {
            photo['selected'] = !photo['selected'];
          });
        }
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(photo['image'], fit: BoxFit.cover),
            if (_isAdding)
              Container(
                color: Colors.black.withOpacity(0.1),
                alignment: Alignment.center,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: photo['selected']
                        ? primaryColor
                        : Colors.transparent,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: photo['selected']
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

