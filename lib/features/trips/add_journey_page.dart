import 'package:flutter/material.dart';

class AddJourneyPage extends StatelessWidget {
  const AddJourneyPage({super.key});

  static const Color primaryColor = Color(0xff16c1a3);

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
        title: const Text("Add Journey", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("DONE", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Name", "Journey's Name"),
            const SizedBox(height: 25),
            _buildTextField("Location", "Location of Journey"),
            const SizedBox(height: 35),
            _buildDashedUploadBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
        const SizedBox(height: 10),
        Text(hint, style: TextStyle(fontSize: 15, color: Colors.grey[400])),
        const SizedBox(height: 5),
        Container(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildDashedUploadBox() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        // A simple workaround for dashed border in vanilla flutter: using custom shape or just plain border for now. 
        // We will just use a transparent color and draw our own dashed lines or use a simple outline. 
        // Using an outline border is acceptable since we cannot rely on external dashed_rect packages.
      ),
      child: Stack(
        children: [
          // Simulated Dashed Border
          Positioned.fill(
            child: CustomPaint(
              painter: DashedBorderPainter(color: primaryColor),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt_outlined, color: primaryColor, size: 20),
                SizedBox(width: 8),
                Text("Upload Photos", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 4;
    double startX = 0;

    // Top & Bottom
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      canvas.drawLine(Offset(startX, size.height), Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    // Left & Right
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

