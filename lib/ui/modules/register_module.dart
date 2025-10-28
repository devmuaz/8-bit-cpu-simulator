import 'package:flutter/material.dart';

class RegisterModule extends StatelessWidget {
  final String name;
  final int value;
  final int busValue;
  final bool isInput;
  final bool isOutput;
  final Color color;
  final bool isConnectedToBus;
  final int bitWidth;

  const RegisterModule({
    super.key,
    required this.name,
    required this.value,
    required this.busValue,
    required this.isInput,
    required this.isOutput,
    required this.color,
    this.isConnectedToBus = false,
    this.bitWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    final maskedValue = value & ((1 << bitWidth) - 1);
    final hexPadding = bitWidth == 4 ? 1 : 2;
    final valueAsHex = maskedValue
        .toRadixString(16)
        .toUpperCase()
        .padLeft(hexPadding, '0');

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isInput || isOutput ? color : color.withValues(alpha: 0.5),
          width: isInput || isOutput ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: isInput || isOutput
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (bitWidth == 4)
                    Text(
                      '(4-bit)',
                      style: TextStyle(color: color, fontSize: 10),
                    ),
                ],
              ),
              Row(
                children: [
                  if (isInput)
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.green,
                      size: 16,
                    ),
                  if (isOutput)
                    const Icon(Icons.arrow_back, color: Colors.red, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: bitWidth == 4
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              for (int i = bitWidth - 1; i >= 0; i--)
                Container(
                  width: 20,
                  height: 20,
                  margin: bitWidth == 4
                      ? const EdgeInsets.only(right: 8)
                      : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ((maskedValue >> i) & 1) == 1
                        ? Colors.red
                        : Colors.grey[900],
                    border: Border.all(color: Colors.grey[700]!),
                    boxShadow: ((maskedValue >> i) & 1) == 1
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
            '0x$valueAsHex ($maskedValue)',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
