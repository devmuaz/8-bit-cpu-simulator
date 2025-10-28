import 'package:flutter/material.dart';

import '../../core/disassembler.dart';

class InstructionRegisterModule extends StatelessWidget {
  final int value;
  final int busValue;
  final bool isInput;
  final bool isOutput;

  const InstructionRegisterModule({
    super.key,
    required this.value,
    required this.busValue,
    required this.isInput,
    required this.isOutput,
  });

  @override
  Widget build(BuildContext context) {
    final bits = value.toRadixString(2).padLeft(8, '0');
    final bitsAsHex = value.toRadixString(16).toUpperCase().padLeft(2, '0');
    final opcode = bits.substring(0, 4);
    final operand = bits.substring(4, 8);

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isInput || isOutput
              ? Colors.red
              : Colors.red.withValues(alpha: 0.5),
          width: isInput || isOutput ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: isInput || isOutput
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
                'INS REGISTER',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'OPCODE',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: opcode[i] == '1'
                                ? Colors.red
                                : Colors.grey[900],
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'OPERAND',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: operand[i] == '1'
                                ? Colors.blue
                                : Colors.grey[900],
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey[700]!),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '0x$bitsAsHex ($value)',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Expanded(
                child: Text(
                  Disassembler.disassemble(value),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
