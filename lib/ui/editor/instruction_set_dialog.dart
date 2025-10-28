import 'package:flutter/material.dart';

class InstructionSetDialog extends StatelessWidget {
  const InstructionSetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      constraints: const BoxConstraints(maxHeight: 700),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'INSTRUCTION SET REFERENCE',
                style: TextStyle(
                  color: Colors.blue,
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
            'Complete guide to all available opcodes and operand types',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOperandTypesSection(),
                  const SizedBox(height: 20),
                  _buildInstructionsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperandTypesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OPERAND TYPES',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        _OperandTypeCard(
          prefix: '#',
          name: 'Immediate Value',
          color: Color(0xFFB5CEA8),
          example: 'LDI #5',
          description:
              'A literal value (0-15) loaded directly into the register. '
              'Does NOT access memory - the value itself is used.',
        ),
        SizedBox(height: 6),
        _OperandTypeCard(
          prefix: '0x',
          name: 'Hexadecimal Address',
          color: Color(0xFFB5CEA8),
          example: 'LDA 0xE',
          description:
              'A memory address in hexadecimal format (0x0-0xF). '
              'Accesses the value stored at that RAM location.',
        ),
        SizedBox(height: 6),
        _OperandTypeCard(
          prefix: '',
          name: 'Decimal Address',
          color: Color(0xFFD4D4AA),
          example: 'LDA 14',
          description:
              'A memory address in decimal format (0-15). '
              'Accesses the value stored at that RAM location. Same as hex, just different notation.',
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInstructionCategory('CONTROL FLOW', Colors.grey, [
          const _InstructionInfo(
            mnemonic: 'NOP',
            hex: '0x0',
            usage: 'NOP',
            color: Colors.grey,
            description: 'No Operation - Does nothing, uses one clock cycle.',
            behavior:
                'The program counter increments but no data is moved or modified.',
            operandType: 'None',
          ),
          const _InstructionInfo(
            mnemonic: 'HLT',
            hex: '0xF',
            usage: 'HLT',
            color: Colors.red,
            description: 'Halt - Stops program execution.',
            behavior:
                'The clock stops and the CPU enters a halted state. No further instructions execute.',
            operandType: 'None',
          ),
        ]),
        const SizedBox(height: 16),
        _buildInstructionCategory('DATA MOVEMENT', Colors.blue, [
          const _InstructionInfo(
            mnemonic: 'LDA',
            hex: '0x1',
            usage: 'LDA addr',
            color: Colors.blue,
            description:
                'Load from Address - Loads value from RAM into A register.',
            behavior:
                'Reads the value at the specified memory address and stores it in register A. '
                'Previous A register value is overwritten.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'LDA 0xE ; Load value from RAM[14] into A',
          ),
          const _InstructionInfo(
            mnemonic: 'LDI',
            hex: '0x5',
            usage: 'LDI #val',
            color: Colors.blue,
            description:
                'Load Immediate - Loads a literal value into A register.',
            behavior:
                'Stores the immediate value directly into register A. '
                'Does NOT access memory - the operand IS the value.',
            operandType: 'Immediate value (#0-#15)',
            example: 'LDI #7 ; Load the number 7 into A',
          ),
          const _InstructionInfo(
            mnemonic: 'STA',
            hex: '0x4',
            usage: 'STA addr',
            color: Colors.blue,
            description: 'Store to Address - Stores A register value into RAM.',
            behavior:
                'Writes the current value of register A to the specified memory address. '
                'A register value remains unchanged.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'STA 0xD ; Store A register value to RAM[13]',
          ),
        ]),
        const SizedBox(height: 16),
        _buildInstructionCategory('ARITHMETIC', Colors.teal, [
          const _InstructionInfo(
            mnemonic: 'ADD',
            hex: '0x2',
            usage: 'ADD addr',
            color: Colors.teal,
            description: 'Add - Adds value from RAM to A register.',
            behavior:
                'Reads value from memory address, adds it to register A, stores result in A. '
                'Sets carry flag if result > 255. Sets zero flag if result = 0.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'ADD 0xF ; A = A + RAM[15]',
          ),
          const _InstructionInfo(
            mnemonic: 'SUB',
            hex: '0x3',
            usage: 'SUB addr',
            color: Colors.teal,
            description: 'Subtract - Subtracts value from RAM from A register.',
            behavior:
                'Reads value from memory address, subtracts it from register A, stores result in A. '
                'Sets carry flag if underflow (result < 0). Sets zero flag if result = 0.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'SUB 14 ; A = A - RAM[14]',
          ),
        ]),
        const SizedBox(height: 16),
        _buildInstructionCategory('JUMPS & BRANCHES', Colors.orange, [
          const _InstructionInfo(
            mnemonic: 'JMP',
            hex: '0x6',
            usage: 'JMP addr',
            color: Colors.orange,
            description: 'Jump - Unconditionally jumps to specified address.',
            behavior:
                'Sets the program counter to the operand address. Execution continues from that address. '
                'Used for loops and function calls.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'JMP 0 ; Jump back to start of program',
          ),
          const _InstructionInfo(
            mnemonic: 'JC',
            hex: '0x7',
            usage: 'JC addr',
            color: Colors.orange,
            description: 'Jump if Carry - Jumps only if carry flag is set.',
            behavior:
                'If carry flag = 1, sets program counter to operand address. '
                'Otherwise, continues to next instruction. Used for overflow detection.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'JC 8 ; Jump to address 8 if overflow occurred',
          ),
          const _InstructionInfo(
            mnemonic: 'JZ',
            hex: '0x8',
            usage: 'JZ addr',
            color: Colors.orange,
            description: 'Jump if Zero - Jumps only if zero flag is set.',
            behavior:
                'If zero flag = 1 (last ALU result was 0), sets program counter to operand address. '
                'Otherwise, continues to next instruction. Used for conditional logic.',
            operandType: 'Address (0x0-0xF or 0-15)',
            example: 'JZ 10 ; Jump to address 10 if A = 0',
          ),
        ]),
        const SizedBox(height: 16),
        _buildInstructionCategory('OUTPUT', Colors.purpleAccent, [
          const _InstructionInfo(
            mnemonic: 'OUT',
            hex: '0xE',
            usage: 'OUT',
            color: Colors.purpleAccent,
            description: 'Output - Displays value from A register.',
            behavior:
                'Sends the current value of register A to the output display. '
                'A register value remains unchanged.',
            operandType: 'None',
          ),
        ]),
      ],
    );
  }

  Widget _buildInstructionCategory(
    String name,
    Color color,
    List<_InstructionInfo> instructions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...instructions.map(
          (info) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _InstructionCard(info: info),
          ),
        ),
      ],
    );
  }
}

class _InstructionInfo {
  final String mnemonic;
  final String hex;
  final String usage;
  final Color color;
  final String description;
  final String behavior;
  final String operandType;
  final String? example;

  const _InstructionInfo({
    required this.mnemonic,
    required this.hex,
    required this.usage,
    required this.color,
    required this.description,
    required this.behavior,
    required this.operandType,
    this.example,
  });
}

class _InstructionCard extends StatelessWidget {
  final _InstructionInfo info;

  const _InstructionCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: info.color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
        color: info.color.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: info.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  info.mnemonic,
                  style: TextStyle(
                    color: info.color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                info.hex,
                style: TextStyle(color: Colors.grey[500], fontSize: 10),
              ),
              const Spacer(),
              Text(
                info.usage,
                style: TextStyle(
                  color: info.color.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            info.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          _buildInfoRow('Operand', info.operandType),
          const SizedBox(height: 4),
          Text(
            info.behavior,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              height: 1.4,
            ),
          ),
          if (info.example != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                info.example!,
                style: TextStyle(color: Colors.grey[300], fontSize: 10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(color: Color(0xFFB5CEA8), fontSize: 10),
        ),
      ],
    );
  }
}

class _OperandTypeCard extends StatelessWidget {
  final String prefix;
  final String name;
  final Color color;
  final String example;
  final String description;

  const _OperandTypeCard({
    required this.prefix,
    required this.name,
    required this.color,
    required this.example,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
        color: color.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (prefix.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    prefix,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '(no prefix)',
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                example,
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
