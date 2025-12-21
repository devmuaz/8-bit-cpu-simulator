import 'package:flutter/material.dart';
import '../../core/disassembler.dart';
import '../../core/assembler.dart';

class RAMModule extends StatelessWidget {
  final List<int> ram;
  final int address;
  final int busValue;
  final bool isInput;
  final bool isOutput;
  final Function(int, int) onEdit;

  const RAMModule({
    super.key,
    required this.ram,
    required this.address,
    required this.busValue,
    required this.isInput,
    required this.isOutput,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RAM',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '16 bytes (4-bit addressing)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(6),
              itemCount: 16,
              itemBuilder: (context, index) {
                final isActive = address == index;
                final instruction = Disassembler.disassemble(ram[index]);

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: const Color(0xFF1a1a1a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _EditRAMDialog(
                          address: index,
                          currentValue: ram[index],
                          onValueChanged: (newValue) => onEdit(index, newValue),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 3.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isActive ? Colors.red : Colors.grey[800]!,

                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'ADDR: 0x${index.toRadixString(16).toUpperCase()}',
                          style: TextStyle(
                            color: isActive ? Colors.red : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  '0x${ram[index].toRadixString(16).toUpperCase().padLeft(2, '0')}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  instruction,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.greenAccent
                                        : Colors.cyan,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EditRAMDialog extends StatefulWidget {
  final int address;
  final int currentValue;
  final Function(int) onValueChanged;

  const _EditRAMDialog({
    required this.address,
    required this.currentValue,
    required this.onValueChanged,
  });

  @override
  State<_EditRAMDialog> createState() => _EditRAMDialogState();
}

class _EditRAMDialogState extends State<_EditRAMDialog> {
  static final _assembler = Assembler();
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? _parseInput(String input) {
    final trimmed = input.trim();

    try {
      final machineCode = _assembler.assemble(trimmed);
      if (machineCode.isNotEmpty) {
        return machineCode[0];
      }
    } catch (e) {
      // DO NOTHING!
    }

    if (trimmed.toLowerCase().startsWith('0x')) {
      final hexValue = int.tryParse(trimmed.substring(2), radix: 16);
      if (hexValue != null) return hexValue;
    } else if (RegExp(r'^[0-9a-fA-F]+$').hasMatch(trimmed) &&
        trimmed.length <= 2) {
      final hexValue = int.tryParse(trimmed, radix: 16);
      if (hexValue != null) return hexValue;
    }

    final decimalValue = int.tryParse(trimmed);
    if (decimalValue != null) return decimalValue;

    return null;
  }

  void _submitValue() {
    setState(() {
      _errorMessage = null;
    });

    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a value';
      });
      return;
    }

    final parsedValue = _parseInput(input);

    if (parsedValue == null) {
      setState(() {
        _errorMessage =
            'Invalid input. Use instruction, hex (0xFF), or decimal (0-255)';
      });
      return;
    }

    if (parsedValue < 0 || parsedValue > 255) {
      setState(() {
        _errorMessage = 'Value must be between 0 and 255 (got: $parsedValue)';
      });
      return;
    }

    widget.onValueChanged(parsedValue);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EDIT RAM AT ADDRESS 0x${widget.address.toRadixString(16).toUpperCase()}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enter instruction, hex, or decimal value',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Examples: LDI #5, 0xFF, 240',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Instruction / Hex / Decimal',
              labelStyle: TextStyle(color: Colors.grey[400]),
              errorText: _errorMessage,
              errorStyle: const TextStyle(color: Colors.redAccent),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[700]!),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _errorMessage != null ? Colors.redAccent : Colors.red,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onSubmitted: (_) => _submitValue(),
            onChanged: (_) {
              if (_errorMessage != null) {
                setState(() {
                  _errorMessage = null;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _submitValue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
