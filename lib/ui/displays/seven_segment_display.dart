import 'package:flutter/material.dart';

import '../painters/seven_segment_painter.dart';

class SevenSegmentDisplay extends StatelessWidget {
  final int? value;

  const SevenSegmentDisplay({super.key, this.value});

  static const List<List<bool>> segments = [
    [true, true, true, false, true, true, true], // ? 0
    [false, false, true, false, false, true, false], // ? 1
    [true, false, true, true, true, false, true], // ? 2
    [true, false, true, true, false, true, true], // ? 3
    [false, true, true, true, false, true, false], // ? 4
    [true, true, false, true, false, true, true], // ? 5
    [true, true, false, true, true, true, true], // ? 6
    [true, false, true, false, false, true, false], // ? 7
    [true, true, true, true, true, true, true], // ? 8
    [true, true, true, true, false, true, true], // ? 9
  ];

  static const List<bool> blankSegments = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    final segs = value == null
        ? blankSegments
        : (value! >= 0 && value! <= 9 ? segments[value!] : segments[0]);

    return SizedBox(
      width: 40,
      height: 60,
      child: CustomPaint(painter: SevenSegmentPainter(segments: segs)),
    );
  }
}
