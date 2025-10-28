import 'package:flutter/material.dart';

class ALUModule extends StatelessWidget {
  final int registerA;
  final int registerB;
  final int sumRegister;
  final bool subtract;
  final bool carryFlag;
  final bool zeroFlag;
  final bool isOutput;
  final bool isFlagsIn;

  const ALUModule({
    super.key,
    required this.registerA,
    required this.registerB,
    required this.sumRegister,
    required this.subtract,
    required this.carryFlag,
    required this.zeroFlag,
    required this.isOutput,
    required this.isFlagsIn,
  });

  @override
  Widget build(BuildContext context) {
    final sumRegisterAsHex = sumRegister.toRadixString(16).padLeft(2, '0');

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOutput ? Colors.red : Colors.red.withValues(alpha: 0.5),
          width: isOutput ? 3 : 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: isOutput
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
                'ALU / Σ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isOutput)
                const Icon(Icons.arrow_back, color: Colors.red, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('A:', style: TextStyle(fontSize: 11)),
                    Text('$registerA', style: const TextStyle(fontSize: 11)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('B:', style: TextStyle(fontSize: 11)),
                    Text('$registerB', style: const TextStyle(fontSize: 11)),
                  ],
                ),
                const Divider(color: Colors.red, height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subtract ? 'A-B:' : 'A+B:',
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      '$sumRegister',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 7; i >= 0; i--)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ((sumRegister >> i) & 1) == 1
                        ? Colors.red
                        : Colors.grey[900],
                    border: Border.all(color: Colors.grey[700]!),
                    boxShadow: ((sumRegister >> i) & 1) == 1
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
            'SUM REGISTER: 0x$sumRegisterAsHex ($sumRegister)',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
