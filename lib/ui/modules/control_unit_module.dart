import 'package:flutter/material.dart';

import '../../core/control_signal.dart';

class ControlUnitModule extends StatelessWidget {
  final int instruction;
  final int step;
  final int controlWord;
  final Map<ControlSignal, bool> signals;

  const ControlUnitModule({
    super.key,
    required this.instruction,
    required this.step,
    required this.controlWord,
    required this.signals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.5),
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTROL LOGIC',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(EEPROM MICROCODE)',
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: [
                    Text(
                      'T$step',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0x${controlWord.toRadixString(16).toUpperCase().padLeft(4, '0')}',
                      style: const TextStyle(color: Colors.cyan, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 3,
            runSpacing: 3,
            children: signals.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: entry.value ? Colors.green[700] : Colors.grey[900],
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: entry.value
                      ? [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.6),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  entry.key.mnemonic,
                  style: TextStyle(
                    color: entry.value ? Colors.white : Colors.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
