import 'package:flutter/material.dart';

class ProgramCounterModule extends StatelessWidget {
  final int value;
  final int busValue;
  final bool isOutput;
  final bool isCount;
  final bool isJump;

  const ProgramCounterModule({
    super.key,
    required this.value,
    required this.busValue,
    required this.isOutput,
    required this.isCount,
    required this.isJump,
  });

  @override
  Widget build(BuildContext context) {
    final value4bit = value & 0xF;
    final valueAsHex = value4bit.toRadixString(16).toUpperCase();

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOutput || isCount || isJump
              ? Colors.red
              : Colors.red.withValues(alpha: 0.5),
          width: isOutput || isCount || isJump ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: isOutput || isCount || isJump
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROGRAM COUNTER',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(4-bit)',
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: [
                  if (isOutput)
                    const Icon(Icons.arrow_back, color: Colors.red, size: 16),
                  if (isCount)
                    const Icon(Icons.add, color: Colors.yellow, size: 16),
                  if (isJump)
                    const Icon(
                      Icons.subdirectory_arrow_left,
                      color: Colors.orange,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 3; i >= 0; i--)
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ((value4bit >> i) & 1) == 1
                        ? Colors.red
                        : Colors.grey[900],
                    border: Border.all(color: Colors.grey[700]!),
                    boxShadow: ((value4bit >> i) & 1) == 1
                        ? [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '0x$valueAsHex ($value4bit)',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
