import 'control_signal.dart';

enum ControlWord {
  // Bit 0 - Halt
  hlt(ControlSignal.hlt, 0x0001),

  // Bit 1 - Memory Address Register In
  mi(ControlSignal.mi, 0x0002),

  // Bit 2 - RAM In
  ri(ControlSignal.ri, 0x0004),

  // Bit 3 - RAM Out
  ro(ControlSignal.ro, 0x0008),

  // Bit 4 - Instruction Register Out (lower 4 bits)
  io(ControlSignal.io, 0x0010),

  // Bit 5 - Instruction Register In
  ii(ControlSignal.ii, 0x0020),

  // Bit 6 - A Register In
  ai(ControlSignal.ai, 0x0040),

  // Bit 7 - A Register Out
  ao(ControlSignal.ao, 0x0080),

  // Bit 8 - B Register In
  bi(ControlSignal.bi, 0x0100),

  // Bit 9 - Sum Out (ALU output, also called EO)
  so(ControlSignal.so, 0x0200),

  // Bit 10 - Subtract mode
  su(ControlSignal.su, 0x0400),

  // Bit 11 - Output Register In
  oi(ControlSignal.oi, 0x0800),

  // Bit 12 - Program Counter Enable (increment)
  ce(ControlSignal.ce, 0x1000),

  // Bit 13 - Program Counter Out
  co(ControlSignal.co, 0x2000),

  // Bit 14 - Jump (load Program Counter)
  j(ControlSignal.j, 0x4000),

  // Bit 15 - Flags In
  fi(ControlSignal.fi, 0x8000);

  final ControlSignal controlSignal;
  final int hex;

  const ControlWord(this.controlSignal, this.hex);

  bool isActive(int word) => (word & hex) != 0;
}
