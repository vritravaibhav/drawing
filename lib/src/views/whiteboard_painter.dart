import 'package:flutter/material.dart';

import '../models/drawing_model.dart';

class WhiteboardPainter extends CustomPainter {
  final List<Drawing> drawings;

  WhiteboardPainter(this.drawings);

  @override
  void paint(Canvas canvas, Size size) {
    for (final drawing in drawings) {
      final paint = Paint()
        ..color = drawing.color
        ..strokeWidth = drawing.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < drawing.points.length - 1; i++) {
        if (drawing.points[i] != null && drawing.points[i + 1] != null) {
          canvas.drawLine(drawing.points[i], drawing.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(WhiteboardPainter oldDelegate) => true;
}
