import 'package:flutter/material.dart';

import '../../core/builtin_program_list.dart';

class BuiltinProgramBrowserDialog extends StatelessWidget {
  final List<BuiltinProgram> programs;
  final List<BuiltinProgramCategory> categories;
  final Function(BuiltinProgram program) onProgramSelected;

  const BuiltinProgramBrowserDialog({
    super.key,
    required this.programs,
    required this.categories,
    required this.onProgramSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      constraints: const BoxConstraints(maxHeight: 600),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LOAD SAMPLE PROGRAM',
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
            'Choose a program to load into the editor',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: _BuiltinProgramList(
                programs: programs,
                categories: categories,
                onProgramSelected: onProgramSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuiltinProgramList extends StatelessWidget {
  final List<BuiltinProgram> programs;
  final List<BuiltinProgramCategory> categories;
  final Function(BuiltinProgram program) onProgramSelected;

  const _BuiltinProgramList({
    required this.programs,
    required this.categories,
    required this.onProgramSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: categories.map((category) {
        final categoryPrograms = programs
            .where((program) => program.category.name == category.name)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Text(
                category.name,
                style: TextStyle(
                  color: category.color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...categoryPrograms.map(
              (program) => _ProgramListItem(
                program: program,
                category: category,
                onProgramSelected: onProgramSelected,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _ProgramListItem extends StatelessWidget {
  final BuiltinProgram program;
  final BuiltinProgramCategory category;
  final Function(BuiltinProgram program) onProgramSelected;

  const _ProgramListItem({
    required this.program,
    required this.category,
    required this.onProgramSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: OutlinedButton(
        onPressed: () {
          onProgramSelected(program);
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: category.color,
          side: BorderSide(color: category.color.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    program.description,
                    style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: category.color.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
