import 'package:flutter/material.dart';

import '../displays/seven_segment_display.dart';

class OutputModule extends StatelessWidget {
  final int value;
  final int busValue;
  final bool isInput;

  const OutputModule({
    super.key,
    required this.value,
    required this.busValue,
    required this.isInput,
  });

  @override
  Widget build(BuildContext context) {
    final valueAsHex = value.toRadixString(16).toUpperCase().padLeft(2, '0');

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isInput ? Colors.red : Colors.red.withValues(alpha: 0.5),
          width: isInput ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: isInput
            ? [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'OUTPUT',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isInput)
                const Icon(Icons.arrow_forward, color: Colors.green, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18.8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SevenSegmentDisplay(
                  value: value >= 100 ? (value ~/ 100) % 10 : null,
                ),
                SevenSegmentDisplay(
                  value: value >= 10 ? (value ~/ 10) % 10 : null,
                ),
                SevenSegmentDisplay(value: value % 10),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '0x$valueAsHex ($value)',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
