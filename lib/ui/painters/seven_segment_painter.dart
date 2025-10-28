import 'package:flutter/material.dart';

class SevenSegmentPainter extends CustomPainter {
  final List<bool> segments;
  final double segmentThickness;

  SevenSegmentPainter({required this.segments, this.segmentThickness = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final segmentWidth = size.width * 0.7;
    final segmentHeight = segmentThickness;
    const gap = 1.0;

    void drawHorizontal(double y, bool on) {
      paint.color = on ? Colors.red : Colors.grey[900]!;

      final left = size.width * 0.15;
      final right = left + segmentWidth;
      final centerY = y + segmentHeight / 2;
      final bevel = segmentHeight / 2;

      final path = Path()
        ..moveTo(left + bevel, y)
        ..lineTo(right - bevel, y)
        ..lineTo(right, centerY)
        ..lineTo(right - bevel, y + segmentHeight)
        ..lineTo(left + bevel, y + segmentHeight)
        ..lineTo(left, centerY)
        ..close();

      canvas.drawPath(path, paint);
    }

    void drawVertical(double x, double y, double height, bool on) {
      paint.color = on ? Colors.red : Colors.grey[900]!;

      final centerX = x + segmentHeight / 2;
      final bottom = y + height;
      final bevel = segmentHeight / 2;

      final path = Path()
        ..moveTo(centerX, y)
        ..lineTo(x + segmentHeight, y + bevel)
        ..lineTo(x + segmentHeight, bottom - bevel)
        ..lineTo(centerX, bottom)
        ..lineTo(x, bottom - bevel)
        ..lineTo(x, y + bevel)
        ..close();

      canvas.drawPath(path, paint);
    }

    drawHorizontal(0, segments[0]);

    drawVertical(
      size.width * 0.1,
      gap + segmentHeight,
      size.height * 0.35,
      segments[1],
    );

    drawVertical(
      size.width * 0.9 - segmentHeight,
      gap + segmentHeight,
      size.height * 0.35,
      segments[2],
    );

    drawHorizontal(size.height * 0.45, segments[3]);

    drawVertical(
      size.width * 0.1,
      size.height * 0.45 + gap + segmentHeight,
      size.height * 0.35,
      segments[4],
    );

    drawVertical(
      size.width * 0.9 - segmentHeight,
      size.height * 0.45 + gap + segmentHeight,
      size.height * 0.35,
      segments[5],
    );

    drawHorizontal(size.height - segmentHeight, segments[6]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
