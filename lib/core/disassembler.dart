import 'opcode.dart';

class Disassembler {
  static String disassemble(int byte) {
    final opcodeValue = (byte >> 4) & 0xF;
    final operandValue = byte & 0xF;

    final opcode = Opcode.fromHex(opcodeValue);

    if (opcode.requiresOperand) {
      if (opcode == Opcode.ldi) {
        return '${opcode.mnemonic} #$operandValue';
      } else if (opcode == Opcode.jmp ||
          opcode == Opcode.jc ||
          opcode == Opcode.jz) {
        return '${opcode.mnemonic} 0x${operandValue.toRadixString(16).toUpperCase()}';
      } else {
        return '${opcode.mnemonic} 0x${operandValue.toRadixString(16).toUpperCase()}';
      }
    } else {
      return opcode.mnemonic;
    }
  }

  static List<String> disassembleProgram(List<int> ram) {
    return ram.map((byte) => disassemble(byte)).toList();
  }
}
