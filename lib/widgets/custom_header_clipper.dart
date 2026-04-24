import 'package:flutter/material.dart';

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    // Bắt đầu từ góc trên bên trái
    path.lineTo(0.0, size.height - 30);

    // Điểm uốn (control_point) và điểm đích (end_point)
    var firstControlPoint = Offset(size.width / 3, size.height + 10);
    var firstEndPoint = Offset(size.width, size.height - 80);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    // Đường viền lên góc trên bên phải
    path.lineTo(size.width, 0.0);

    // Kín lại hình
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
