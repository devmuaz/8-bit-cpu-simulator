import 'package:flutter/material.dart';

class HardwareTrackShape extends RoundedRectSliderTrackShape {
  const HardwareTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final Rect adjustedTrackRect = Rect.fromLTWH(
      trackRect.left,
      trackRect.top + (trackRect.height - trackHeight) / 2,
      trackRect.width,
      trackHeight,
    );

    // Draw a recessed track background (shadow effect)
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        adjustedTrackRect.translate(0, 1),
        const Radius.circular(3),
      ),
      shadowPaint,
    );

    // Inactive track (right side)
    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(adjustedTrackRect, const Radius.circular(3)),
      inactivePaint,
    );

    // Active track (left side)
    final activeRect = Rect.fromLTRB(
      adjustedTrackRect.left,
      adjustedTrackRect.top,
      thumbCenter.dx,
      adjustedTrackRect.bottom,
    );
    final activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, const Radius.circular(3)),
      activePaint,
    );

    // Add border to track
    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromRectAndRadius(adjustedTrackRect, const Radius.circular(3)),
      borderPaint,
    );
  }
}
