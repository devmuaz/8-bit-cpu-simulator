enum ControlSignal {
  // ? Halt
  hlt('HLT'),

  // ? Memory Address Register In
  mi('MI'),

  // ? RAM In
  ri('RI'),

  // ? RAM Out
  ro('RO'),

  // ? Instruction Register Out (lower 4 bits)
  io('IO'),

  // ? Instruction Register In
  ii('II'),

  // ? A Register In
  ai('AI'),

  // ? A Register Out
  ao('AO'),

  // ? B Register In
  bi('BI'),

  // ? Sum Out (ALU output)
  so('SO'),

  // ? Subtract mode
  su('SU'),

  // ? Output Register In
  oi('OI'),

  // ? Program Counter Enable
  ce('CE'),

  // ? Program Counter Out
  co('CO'),

  // ? Jump (load Program Counter)
  j('J'),

  // ? Flags In
  fi('FI');

  final String mnemonic;
  const ControlSignal(this.mnemonic);
}
