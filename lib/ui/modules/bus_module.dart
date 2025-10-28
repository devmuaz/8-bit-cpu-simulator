import 'package:flutter/material.dart';

class BusModule extends StatelessWidget {
  final int bus;
  final bool busActive;
  final Animation<double> animation;

  const BusModule({
    super.key,
    required this.bus,
    required this.busActive,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final bits = bus.toRadixString(2).padLeft(8, '0');
    final valueAsHex = bus.toRadixString(16).toUpperCase().padLeft(2, '0');

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a1a),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: busActive
                  ? Colors.red.withValues(alpha: 0.5 + animation.value * 0.5)
                  : Colors.red.withValues(alpha: 0.5),
              width: busActive ? 3 : 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            boxShadow: busActive
                ? [
                    BoxShadow(
                      color: Colors.red.withValues(
                        alpha: 0.4 * animation.value,
                      ),
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
                    'BUS',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (busActive)
                    Icon(
                      Icons.circle,
                      color: Colors.red.withValues(
                        alpha: 0.5 + animation.value * 0.5,
                      ),
                      size: 12,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 8; i++)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: busActive && bits[i] == '1'
                            ? Colors.red.withValues(
                                alpha: 0.7 + animation.value * 0.3,
                              )
                            : Colors.grey[900],
                        border: Border.all(color: Colors.grey[700]!),
                        boxShadow: busActive && bits[i] == '1'
                            ? [
                                BoxShadow(
                                  color: Colors.red.withValues(
                                    alpha: 0.6 * animation.value,
                                  ),
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
                busActive ? '0x$valueAsHex ($bus)' : '-- (Inactive)',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
