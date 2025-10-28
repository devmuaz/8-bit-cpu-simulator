import 'package:flutter/material.dart';

import '../../core/assembler.dart';
import '../../core/builtin_program_list.dart';
import 'assembly_text_editing_controller.dart';
import 'builtin_program_browser_dialog.dart';
import 'instruction_set_dialog.dart';

class ProgramEditor extends StatefulWidget {
  final Function(List<int> program, bool hasError) onAssemble;
  final String? initialProgram;

  const ProgramEditor({
    super.key,
    required this.onAssemble,
    this.initialProgram,
  });

  @override
  State<ProgramEditor> createState() => _ProgramEditorState();
}

class _ProgramEditorState extends State<ProgramEditor> {
  static const _programs = BuiltinProgramList.all;
  static final _categories = BuiltinProgramList.getCategories();
  static final _assembler = Assembler();

  late final TextEditingController _errorMessageController;
  late final AssemblyTextEditingController _editorController;

  late final ScrollController _scrollController;
  late final ScrollController _lineNumberScrollController;

  bool _isLogTypeInfo = false;
  bool _isLogTypeError = false;

  bool isAssembled = false;
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    _editorController = AssemblyTextEditingController(
      text: widget.initialProgram ?? '',
    );
    _errorMessageController = TextEditingController(
      text: '[NORMAL] Initialized!',
    );
    _scrollController = ScrollController();
    _lineNumberScrollController = ScrollController();
    _scrollController.addListener(_syncLineNumberScroll);
    _updateLineCount();
  }

  void _updateLineCount() {
    setState(() {
      _lineCount = '\n'.allMatches(_editorController.text).length + 1;
    });
  }

  void _syncLineNumberScroll() {
    if (_lineNumberScrollController.hasClients &&
        _scrollController.hasClients) {
      _lineNumberScrollController.jumpTo(_scrollController.offset);
    }
  }

  void _setLogTypeNormal() {
    setState(() {
      _isLogTypeInfo = false;
      _isLogTypeError = false;
    });
  }

  void _setLogTypeInfo() {
    setState(() {
      _isLogTypeInfo = true;
      _isLogTypeError = false;
    });
  }

  void _setLogTypeError() {
    setState(() {
      _isLogTypeInfo = false;
      _isLogTypeError = true;
    });
  }

  @override
  void dispose() {
    _editorController.dispose();
    _errorMessageController.dispose();
    _scrollController.dispose();
    _lineNumberScrollController.dispose();
    super.dispose();
  }

  void _assembleProgram() {
    try {
      final program = _assembler.assemble(_editorController.text);
      setState(() {
        isAssembled = true;
      });
      _errorMessageController.text =
          '[INFO] Assembled successfully!\n[INFO] See RAM\'s content in the CPU Board.';
      _setLogTypeInfo();
      widget.onAssemble(program, false);
    } catch (e) {
      setState(() {
        isAssembled = false;
      });
      _errorMessageController.text = '[ERROR] ${e.toString()}';
      _setLogTypeError();
      widget.onAssemble([], true);
    }
  }

  void _openProgramBrowserDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: BuiltinProgramBrowserDialog(
          programs: _programs,
          categories: _categories,
          onProgramSelected: (program) {
            _editorController.text = program.code;
            _updateLineCount();
            setState(() {
              isAssembled = false;
            });
            _errorMessageController.text =
                '[NORMAL] Program loaded successfully!';
            _setLogTypeNormal();
          },
        ),
      ),
    );
  }

  void _openInstructionSetDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1a1a1a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const InstructionSetDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const hintText =
        'Enter assembly code here...\n\n'
        'Example:\n'
        'LDI #5     ; Load immediate\n'
        'STA 0xF    ; Store to hex addr\n'
        'OUT        ; Output value\n'
        'HLT        ; Halt execution';

    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isLogTypeError
              ? Colors.red
              : isAssembled
              ? Colors.green
              : Colors.blue.withValues(alpha: 0.5),
          strokeAlign: BorderSide.strokeAlignOutside,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROGRAM EDITOR (ASSEMBLER)',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Generate machine code from assembly code',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              Icon(
                _isLogTypeError
                    ? Icons.error
                    : isAssembled
                    ? Icons.check_circle
                    : Icons.code,
                color: _isLogTypeError
                    ? Colors.red
                    : isAssembled
                    ? Colors.green
                    : Colors.blue,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 455,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _lineCount > 99 ? 36 : 26,
                  height: 455,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border(right: BorderSide(color: Colors.grey[800]!)),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      controller: _lineNumberScrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          _lineCount,
                          (index) => Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _editorController,
                      scrollController: _scrollController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.57,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        _updateLineCount();
                        setState(() {
                          isAssembled = false;
                        });
                        _errorMessageController.text =
                            '[NORMAL] Program modified!\n[NORMAL] Please assemble again.';
                        _setLogTypeNormal();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Assembler Logs',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            readOnly: true,
            controller: _errorMessageController,
            maxLines: 3,
            style: TextStyle(
              fontSize: 13,
              color: _isLogTypeError
                  ? Colors.red[600]!
                  : _isLogTypeInfo
                  ? Colors.green[600]!
                  : Colors.white60,
              height: 1.57,
            ),
            decoration: InputDecoration(
              fillColor: Colors.black,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white12),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white12),
                borderRadius: BorderRadius.circular(4),
              ),
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _assembleProgram,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'ASSEMBLE & LOAD',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openProgramBrowserDialog,
                    icon: const Icon(Icons.folder_open, size: 16),
                    label: const Text('Browse Built-In Programs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withValues(alpha: 0.2),
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                          color: Colors.blue.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openInstructionSetDialog,
                    icon: const Icon(Icons.edit_document, size: 16),
                    label: const Text('See Instruction Set Reference'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withValues(alpha: 0.2),
                      foregroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                          color: Colors.green.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
