import 'opcode.dart';

class Assembler {
  List<int> assemble(String source) {
    final List<int> machineCode = [];
    final lines = _splitIntoLines(source);

    for (int i = 0; i < lines.length; i++) {
      final line = _removeComments(lines[i]);

      if (_shouldSkipLine(line)) continue;

      final instruction = _parseInstruction(line, lineNumber: i + 1);

      final opcodeEnum = _findOpcodeByMnemonic(
        instruction.mnemonic,
        lineNumber: i + 1,
      );

      _validateOperandRequirement(
        opcodeEnum,
        instruction.operand,
        lineNumber: i + 1,
      );

      final machineCodeInstruction = _combineOpcodeAndOperand(
        opcodeEnum.hex,
        instruction.operand ?? 0,
      );

      machineCode.add(machineCodeInstruction);
    }

    _validateMachineCode(machineCode);
    return machineCode;
  }

  List<String> _splitIntoLines(String source) {
    return source.split('\n');
  }

  String _removeComments(String line) {
    line = line.trim();
    if (line.contains(';')) {
      return line.substring(0, line.indexOf(';')).trim();
    }
    return line;
  }

  bool _shouldSkipLine(String line) {
    return line.isEmpty;
  }

  _ParsedInstruction _parseInstruction(String line, {int? lineNumber}) {
    final parts = line.split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      throw 'Line $lineNumber: Empty instruction';
    }

    final mnemonic = parts[0].toUpperCase();
    int? operand;

    if (parts.length > 1) {
      operand = _parseOperand(parts[1], lineNumber);
    }

    return _ParsedInstruction(mnemonic, operand);
  }

  int _parseOperand(String operandStr, [int? lineNumber]) {
    final cleanOperandStr = operandStr.replaceAll('#', '');
    int? operand;

    if (cleanOperandStr.startsWith('0x') || cleanOperandStr.startsWith('0X')) {
      operand = int.tryParse(cleanOperandStr.substring(2), radix: 16);
    } else {
      operand = int.tryParse(cleanOperandStr);
    }

    if (operand == null) {
      throw 'Line $lineNumber: Invalid operand "$operandStr"';
    }

    if (operand < 0 || operand > 15) {
      throw 'Line $lineNumber: Operand must be 0-15 (4-bit), got $operand';
    }

    return operand;
  }

  Opcode _findOpcodeByMnemonic(String mnemonic, {int? lineNumber}) {
    try {
      return Opcode.values.firstWhere((opcode) => opcode.mnemonic == mnemonic);
    } catch (e) {
      throw 'Line $lineNumber: Unknown instruction "$mnemonic"';
    }
  }

  void _validateOperandRequirement(
    Opcode opcode,
    int? operand, {
    int? lineNumber,
  }) {
    if (opcode.requiresOperand && operand == null) {
      throw 'Line $lineNumber: ${opcode.mnemonic} requires an operand';
    }
  }

  int _combineOpcodeAndOperand(int opcode, int operand) {
    return (opcode << 4) | (operand & 0xF);
  }

  void _validateMachineCode(List<int> machineCode) {
    if (machineCode.isEmpty) {
      throw 'Program is empty';
    }
  }
}

class _ParsedInstruction {
  final String mnemonic;
  final int? operand;

  _ParsedInstruction(this.mnemonic, this.operand);
}
