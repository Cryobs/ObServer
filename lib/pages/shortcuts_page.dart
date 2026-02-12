import 'package:flutter/material.dart';
import 'package:pocket_ssh/models/shortcut_model.dart';
import 'package:pocket_ssh/services/shortcuts_repository.dart';
import 'package:pocket_ssh/widgets/shortcut_widget.dart';
import 'package:pocket_ssh/widgets/add_shortcut_widget.dart';
import 'package:pocket_ssh/pages/shortcut_form_page.dart';

class ShortcutsPage extends StatefulWidget {
  const ShortcutsPage({super.key});

  @override
  State<ShortcutsPage> createState() => _ShortcutsPageState();
}

class _ShortcutsPageState extends State<ShortcutsPage> {
  final ShortcutsRepository _repo = ShortcutsRepository();

  List<ShortcutModel> _shortcuts = [];

  // =========================
  // INIT
  // =========================
  @override
  void initState() {
    super.initState();
    _load();
  }

  // =========================
  // LOAD DATA FROM HIVE
  // =========================
  Future<void> _load() async {
    await _repo.init();
    setState(() {
      _shortcuts = _repo.getAll();
    });
  }

  // =========================
  // ADD SHORTCUT
  // =========================
  Future<void> _addShortcut() async {
    final refreshed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShortcutFormPage(),
      ),
    );

    if (refreshed == true) {
      _load();
    }
  }

  // =========================
  // REMOVE SHORTCUT
  // =========================
  Future<void> _removeShortcut(String id) async {
    await _repo.remove(id);
    _load();
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(19),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        // =========================
        // SHORTCUT TILES
        // =========================
        ..._shortcuts.map(
              (shortcut) => EditableShortcutTile(
            shortcut: shortcut,

            /// EDIT
            onEdit: () async {
              final refreshed = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShortcutFormPage(shortcut: shortcut),
                ),
              );

              if (refreshed == true) {
                _load();
              }
            },

            /// DELETE
            onDelete: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete shortcut'),
                  content: const Text(
                    'Are you sure you want to delete this shortcut?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                _removeShortcut(shortcut.id);
              }
            },

            /// CHANGE ORDER (NA RAZIE PLACEHOLDER)
            onChangeOrder: () {
              // TODO: drag & drop
            },
          ),
        ),

        // =========================
        // ADD TILE
        // =========================
        AddShortcutTile(
          onAdd: _addShortcut,
        ),
      ],
    );
  }
}
