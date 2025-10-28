import 'package:flutter/material.dart';

import '../../core/control_signal.dart';

class ControlWordModule extends StatelessWidget {
  final int controlWord;

  const ControlWordModule({super.key, required this.controlWord});

  @override
  Widget build(BuildContext context) {
    final bitsAsHex = controlWord.toRadixString(16).padLeft(4, '0');

    final bitLabels = ControlSignal.values
        .map((signal) => signal.mnemonic)
        .toList();

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
          const Text(
            'CONTROL WORD',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 16; i++) ...[
                SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      bitLabels[i],
                      style: TextStyle(
                        color: _isBitSet(i) ? Colors.green : Colors.grey[600],
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (i == 7) const Spacer(),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 16; i++) ...[
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _isBitSet(i) ? Colors.green : Colors.grey[900],
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Center(
                    child: Text(
                      '${_getBit(i)}',
                      style: TextStyle(
                        color: _isBitSet(i) ? Colors.white : Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (i == 7) const Spacer(),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 16; i++) ...[
                SizedBox(
                  width: 20,
                  child: Center(
                    child: Text(
                      '$i',
                      style: TextStyle(color: Colors.grey[600], fontSize: 7),
                    ),
                  ),
                ),
                if (i == 7) const Spacer(),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '0x$bitsAsHex ($controlWord)',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  int _getBit(int bitPosition) {
    return (controlWord >> bitPosition) & 1;
  }

  bool _isBitSet(int bitPosition) {
    return _getBit(bitPosition) == 1;
  }
}
