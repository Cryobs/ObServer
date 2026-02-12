import 'package:flutter/material.dart';
import '../models/shortcut_model.dart';
import '../services/shortcuts_repository.dart';

class ShortcutFormPage extends StatefulWidget {
  final ShortcutModel? shortcut;

  const ShortcutFormPage({super.key, this.shortcut});

  @override
  State<ShortcutFormPage> createState() => _ShortcutFormPageState();
}

class _ShortcutFormPageState extends State<ShortcutFormPage> {
  final ShortcutsRepository _repo = ShortcutsRepository();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commandController = TextEditingController();

  IconData _icon = Icons.security;
  Color _color = Colors.purple;

  bool get isEdit => widget.shortcut != null;


  @override
  void initState() {
    super.initState();
    _repo.init();

    if (isEdit) {
      _titleController.text = widget.shortcut!.title;
      _commandController.text = widget.shortcut!.command;
      _icon = widget.shortcut!.icon;
      _color = widget.shortcut!.color;
    }
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Shortcut' : 'Add Shortcut'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commandController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Command'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SAVE
  // =========================
  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;

    if (isEdit) {
      widget.shortcut!
        ..title = _titleController.text
        ..command = _commandController.text
        ..iconCodePoint = _icon.codePoint
        ..colorValue = _color.value;

      await _repo.update(widget.shortcut!);
    } else {
      await _repo.add(
        ShortcutModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          iconCodePoint: _icon.codePoint,
          colorValue: _color.value,
          command: _commandController.text,
        ),
      );
    }

    Navigator.pop(context, true);
  }
}
