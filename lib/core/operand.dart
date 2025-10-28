import 'package:flutter/material.dart';

enum OperandPrefix {
  immediate('#', OperandHighlightColor.immediate),
  hex('0x', OperandHighlightColor.hex),
  decimalAddress('', OperandHighlightColor.decimal);

  final String prefix;
  final OperandHighlightColor highlightColor;
  const OperandPrefix(this.prefix, this.highlightColor);
}

enum OperandHighlightColor {
  immediate(Color(0xFFB5CEA8), 1),
  hex(Color(0xFFB5CEA8), 1),
  decimal(Color(0xFFD4D4AA), 1);

  final Color color;
  final double alpha;
  const OperandHighlightColor(this.color, this.alpha);
}
