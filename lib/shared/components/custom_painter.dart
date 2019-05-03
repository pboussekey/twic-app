import 'package:flutter/material.dart';

class CustomBackgroundPainter extends CustomPainter {
  Color color;
  double padding;

  CustomBackgroundPainter({this.color, this.padding});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = this.color;
    canvas.drawCircle(
        Offset(size.width / 2.0, -size.height * (this.padding ?? 0.1)), size.height, paint);
  }

  @override
  bool shouldRepaint(CustomBackgroundPainter oldDelegate) {
    return oldDelegate.color != this.color;
  }
}
