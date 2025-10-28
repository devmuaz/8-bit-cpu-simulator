import 'package:flutter/material.dart';

enum Opcode {
  nop(
    'NOP',
    usage: 'NOP',
    hex: 0x0,
    requiresOperand: false,
    highlightColor: OpcodeHighlightColor.grey,
  ),
  lda(
    'LDA',
    usage: 'LDA addr',
    hex: 0x1,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.blue,
  ),
  add(
    'ADD',
    usage: 'ADD addr',
    hex: 0x2,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.green,
  ),
  sub(
    'SUB',
    usage: 'SUB addr',
    hex: 0x3,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.green,
  ),
  sta(
    'STA',
    usage: 'STA addr',
    hex: 0x4,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.blue,
  ),
  ldi(
    'LDI',
    usage: 'LDI #val',
    hex: 0x5,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.blue,
  ),
  jmp(
    'JMP',
    usage: 'JMP addr',
    hex: 0x6,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.orange,
  ),
  jc(
    'JC',
    usage: 'JC addr',
    hex: 0x7,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.orange,
  ),
  jz(
    'JZ',
    usage: 'JZ addr',
    hex: 0x8,
    requiresOperand: true,
    highlightColor: OpcodeHighlightColor.orange,
  ),
  out(
    'OUT',
    usage: 'OUT',
    hex: 0xE,
    requiresOperand: false,
    highlightColor: OpcodeHighlightColor.purple,
  ),
  hlt(
    'HLT',
    usage: 'HLT',
    hex: 0xF,
    requiresOperand: false,
    highlightColor: OpcodeHighlightColor.red,
  );

  final String mnemonic;
  final String usage;
  final int hex;
  final bool requiresOperand;
  final OpcodeHighlightColor highlightColor;

  const Opcode(
    this.mnemonic, {
    required this.usage,
    required this.hex,
    required this.requiresOperand,
    required this.highlightColor,
  });

  factory Opcode.fromHex(int hex) {
    return Opcode.values.firstWhere(
      (opcode) => opcode.hex == hex,
      orElse: () => Opcode.nop,
    );
  }
}

enum OpcodeHighlightColor {
  grey(Color(0xFF7F848E), alpha: 1),
  blue(Color(0xFF82AAFE), alpha: 1),
  green(Color(0xFF17A386), alpha: 1),
  orange(Color(0xFFED8F03), alpha: 1),
  purple(Color(0xFFFF6BCB), alpha: 1),
  red(Color(0xFFD43B30), alpha: 1);

  final Color color;
  final double alpha;
  const OpcodeHighlightColor(this.color, {required this.alpha});
}
