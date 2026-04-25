import 'package:flutter/material.dart';

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Báº¯t Ä‘áº§u tá»« gĂ³c trĂªn bĂªn trĂ¡i
    path.lineTo(0.0, size.height - 30);

    // Äiá»ƒm uá»‘n (control_point) vĂ  Ä‘iá»ƒm Ä‘Ă­ch (end_point)
    var firstControlPoint = Offset(size.width / 3, size.height + 10);
    var firstEndPoint = Offset(size.width, size.height - 80);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    // ÄÆ°á»ng viá»n lĂªn gĂ³c trĂªn bĂªn pháº£i
    path.lineTo(size.width, 0.0);

    // KĂ­n láº¡i hĂ¬nh
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

