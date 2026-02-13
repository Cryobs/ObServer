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

class _ShortcutsPageState extends State<ShortcutsPage>
    with AutomaticKeepAliveClientMixin {
  final ShortcutsRepository _repo = ShortcutsRepository();
  List<ShortcutModel> _shortcuts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  bool get wantKeepAlive => true;

  // =========================
  // LOAD
  // =========================
  Future<void> _load() async {
    await _repo.init();
    setState(() {
      _shortcuts = _repo.getAll();
    });
  }

  // =========================
  // ADD
  // =========================
  Future<void> _addShortcut() async {
    final refresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShortcutFormPage(),
      ),
    );

    if (refresh == true) {
      _load();
    }
  }

  // =========================
  // EDIT
  // =========================
  Future<void> _editShortcut(ShortcutModel shortcut) async {
    final refresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShortcutFormPage(shortcut: shortcut),
      ),
    );

    if (refresh == true) {
      _load();
    }
  }

  // =========================
  // DELETE
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
    super.build(context);

    return GridView.count(
      padding: const EdgeInsets.all(19),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        /// ISTNIEJĄCE SKRÓTY
        ..._shortcuts.map(
              (s) => EditableShortcutTile(
            key: ValueKey(s.id),
            shortcut: s,
            onEdit: () => _editShortcut(s),
            onDelete: () => _removeShortcut(s.id),
          ),
        ),

        /// ➕ ADD TILE
        AddShortcutTile(
          onAdd: _addShortcut,
        ),
      ],
    );
  }
}
