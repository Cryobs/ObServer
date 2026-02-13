import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pocket_ssh/models/shortcut_model.dart';
import 'package:pocket_ssh/services/shortcuts_repository.dart';

class ShortcutFormPage extends StatefulWidget {
  final ShortcutModel? shortcut;

  const ShortcutFormPage({super.key, this.shortcut});

  @override
  State<ShortcutFormPage> createState() => _ShortcutFormPageState();
}

class _ShortcutFormPageState extends State<ShortcutFormPage> {
  final _repo = ShortcutsRepository();

  late TextEditingController _titleController;
  late IconData _icon;
  late Color _color;

  Color _tempColor = Colors.blue;

  final List<IconData> _icons = [
    Icons.apps,
    Icons.security,
    Icons.language,
    Icons.folder,
    Icons.web,
    Icons.terminal,
  ];

  bool get isEdit => widget.shortcut != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _titleController =
          TextEditingController(text: widget.shortcut!.title);
      _icon = widget.shortcut!.icon;
      _color = widget.shortcut!.color;
    } else {
      _titleController = TextEditingController();
      _icon = Icons.apps;
      _color = Colors.blue;
    }

    _tempColor = _color;
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) return;

    await _repo.init();

    if (isEdit) {
      widget.shortcut!
        ..title = _titleController.text
        ..iconCodePoint = _icon.codePoint
        ..colorValue = _color.value;

      await _repo.update(widget.shortcut!);
    } else {
      final shortcut = ShortcutModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        iconCodePoint: _icon.codePoint,
        colorValue: _color.value,
      );

      await _repo.add(shortcut);
    }

    Navigator.pop(context, true); // refresh
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose color'),
        content: ColorPicker(
          pickerColor: _tempColor,
          onColorChanged: (c) => setState(() => _tempColor = c),
          enableAlpha: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _color = _tempColor);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit shortcut' : 'Create shortcut'),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PREVIEW
            Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Icon(_icon, color: Colors.white, size: 28),
                  ),
                  Center(
                    child: Text(
                      _titleController.text.isEmpty
                          ? 'Preview'
                          : _titleController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),

            // ICON PICKER
            Wrap(
              spacing: 12,
              children: _icons.map((i) {
                return GestureDetector(
                  onTap: () => setState(() => _icon = i),
                  child: CircleAvatar(
                    backgroundColor:
                    _icon == i ? Colors.green : Colors.grey[800],
                    child: Icon(i, color: Colors.white),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // COLOR PICKER
            ElevatedButton.icon(
              onPressed: _pickColor,
              icon: const Icon(Icons.color_lens),
              label: const Text('Pick color'),
            ),
          ],
        ),
      ),
    );
  }
}
