import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../core/opcode.dart';
import '../../core/operand.dart';

class AssemblyTextEditingController extends TextEditingController {
  AssemblyTextEditingController({super.text});

  @override
  set value(TextEditingValue newValue) {
    final normalizedText = _normalizeOpcodes(newValue.text);

    if (normalizedText != newValue.text) {
      super.value = newValue.copyWith(
        text: normalizedText,
        selection: newValue.selection,
      );
    } else {
      super.value = newValue;
    }
  }

  String _normalizeOpcodes(String text) {
    final lines = text.split('\n');
    final normalizedLines = <String>[];

    for (final line in lines) {
      normalizedLines.add(_normalizeOpcodeLine(line));
    }

    return normalizedLines.join('\n');
  }

  String _normalizeOpcodeLine(String line) {
    final commentIndex = line.indexOf(';');
    final codePart = commentIndex >= 0 ? line.substring(0, commentIndex) : line;
    final comment = commentIndex >= 0 ? line.substring(commentIndex) : '';

    if (codePart.trim().isEmpty) return line;

    final trimmedCode = codePart.trimLeft();
    final leadingWhitespace = codePart.substring(
      0,
      codePart.length - trimmedCode.length,
    );
    final parts = trimmedCode.split(RegExp(r'\s+'));

    if (parts.isEmpty || parts[0].isEmpty) return line;

    final instructionUpper = parts[0].toUpperCase();
    final isValidOpcode = Opcode.values.any(
      (op) => op.mnemonic == instructionUpper,
    );

    if (isValidOpcode && parts[0] != instructionUpper) {
      final afterInstruction = trimmedCode.substring(parts[0].length);
      return leadingWhitespace + instructionUpper + afterInstruction + comment;
    }

    return line;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final lines = text.split('\n');
    final List<TextSpan> spans = [];

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      _processLine(lines[lineIndex], style, spans);

      if (lineIndex < lines.length - 1) {
        spans.add(TextSpan(text: '\n', style: style));
      }
    }

    return TextSpan(style: style, children: spans);
  }

  void _processLine(String line, TextStyle? style, List<TextSpan> spans) {
    final lineParts = _splitLineIntoCodeAndComment(line);

    if (lineParts.codePart.trim().isNotEmpty) {
      _processCodePart(
        lineParts.codePart,
        lineParts.commentIndex,
        style,
        spans,
      );
    } else if (lineParts.codePart.isNotEmpty) {
      spans.add(TextSpan(text: lineParts.codePart, style: style));
    }

    if (lineParts.comment != null) {
      _processComment(lineParts.comment!, style, spans);
    }
  }

  _LineParts _splitLineIntoCodeAndComment(String line) {
    final commentIndex = line.indexOf(';');
    final codePart = commentIndex >= 0 ? line.substring(0, commentIndex) : line;
    final comment = commentIndex >= 0 ? line.substring(commentIndex) : null;

    return _LineParts(
      codePart: codePart,
      comment: comment,
      commentIndex: commentIndex,
    );
  }

  void _processCodePart(
    String codePart,
    int commentIndex,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    _addLeadingWhitespace(codePart, style, spans);

    final trimmedCode = codePart.trim();
    final parts = trimmedCode.split(RegExp(r'\s+'));

    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      _processInstruction(parts[0], style, spans);

      if (parts.length > 1) {
        _processInstructionWithOperand(
          codePart,
          parts,
          commentIndex,
          style,
          spans,
        );
      } else {
        _addTrailingWhitespaceAfterInstruction(
          codePart,
          parts[0],
          style,
          spans,
        );
      }
    }
  }

  void _addLeadingWhitespace(
    String codePart,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    final leadingWhitespace = codePart.length - codePart.trimLeft().length;
    if (leadingWhitespace > 0) {
      spans.add(
        TextSpan(text: codePart.substring(0, leadingWhitespace), style: style),
      );
    }
  }

  void _processInstruction(
    String instructionText,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    final instruction = instructionText.toUpperCase();
    final color = _getInstructionColor(instruction);

    spans.add(
      TextSpan(
        text: instructionText,
        style: style?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color? _getInstructionColor(String instruction) {
    final opcode = Opcode.values.firstWhereOrNull(
      (opcode) => opcode.mnemonic == instruction,
    );

    if (opcode == null) return null;

    final highlightColor = opcode.highlightColor.color;
    final alpha = opcode.highlightColor.alpha;
    return highlightColor.withValues(alpha: alpha);
  }

  void _processInstructionWithOperand(
    String codePart,
    List<String> parts,
    int commentIndex,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    final instructionEnd = codePart.indexOf(parts[0]) + parts[0].length;
    final operandStart = codePart.indexOf(parts[1], instructionEnd);

    _addWhitespaceBetweenInstructionAndOperand(
      codePart,
      instructionEnd,
      operandStart,
      style,
      spans,
    );

    final operandText = _extractOperandText(
      codePart,
      operandStart,
      commentIndex,
    );

    _processOperand(operandText, style, spans);

    _addTrailingWhitespaceBeforeComment(
      codePart,
      operandStart,
      operandText,
      commentIndex,
      style,
      spans,
    );
  }

  void _addWhitespaceBetweenInstructionAndOperand(
    String codePart,
    int instructionEnd,
    int operandStart,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    if (operandStart > instructionEnd) {
      spans.add(
        TextSpan(
          text: codePart.substring(instructionEnd, operandStart),
          style: style,
        ),
      );
    }
  }

  String _extractOperandText(
    String codePart,
    int operandStart,
    int commentIndex,
  ) {
    return codePart
        .substring(
          operandStart,
          commentIndex >= 0 ? commentIndex : codePart.length,
        )
        .trimRight();
  }

  void _processOperand(
    String operandText,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    final color = _getOperandColor(operandText);

    spans.add(
      TextSpan(
        text: operandText,
        style: style?.copyWith(color: color),
      ),
    );
  }

  Color _getOperandColor(String operand) {
    final highlightColor = _getOperandHighlightColor(operand);
    final alpha = highlightColor.alpha;
    return highlightColor.color.withValues(alpha: alpha);
  }

  OperandHighlightColor _getOperandHighlightColor(String operand) {
    return OperandPrefix.values
            .firstWhereOrNull((e) => operand.startsWith(e.prefix))
            ?.highlightColor ??
        OperandHighlightColor.decimal;
  }

  void _addTrailingWhitespaceBeforeComment(
    String codePart,
    int operandStart,
    String operandText,
    int commentIndex,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    final operandEnd = operandStart + operandText.length;
    if (commentIndex >= 0 && operandEnd < commentIndex) {
      spans.add(TextSpan(text: codePart.substring(operandEnd), style: style));
    } else if (commentIndex < 0 && operandEnd < codePart.length) {
      spans.add(TextSpan(text: codePart.substring(operandEnd), style: style));
    }
  }

  void _addTrailingWhitespaceAfterInstruction(
    String codePart,
    String instruction,
    TextStyle? style,
    List<TextSpan> spans,
  ) {
    final instructionEnd = codePart.indexOf(instruction) + instruction.length;
    if (instructionEnd < codePart.length) {
      spans.add(
        TextSpan(text: codePart.substring(instructionEnd), style: style),
      );
    }
  }

  void _processComment(String comment, TextStyle? style, List<TextSpan> spans) {
    spans.add(
      TextSpan(
        text: comment,
        style: style?.copyWith(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _LineParts {
  final String codePart;
  final String? comment;
  final int commentIndex;

  _LineParts({
    required this.codePart,
    required this.comment,
    required this.commentIndex,
  });
}
