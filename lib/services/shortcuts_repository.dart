import 'package:hive/hive.dart';
import 'package:pocket_ssh/models/shortcut_model.dart';

class ShortcutsRepository {
  static const String _boxName = 'shortcuts';

  late Box<ShortcutModel> _box;

  // =========================
  // INIT
  // =========================
  Future<void> init() async {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<ShortcutModel>(_boxName);
    } else {
      _box = await Hive.openBox<ShortcutModel>(_boxName);
    }
  }

  // =========================
  // READ
  // =========================
  List<ShortcutModel> getAll() {
    return _box.values.toList();
  }

  ShortcutModel? getById(String id) {
    return _box.get(id);
  }

  // =========================
  // CREATE
  // =========================
  Future<void> add(ShortcutModel shortcut) async {
    await _box.put(shortcut.id, shortcut);
  }

  // =========================
  // UPDATE
  // =========================
  Future<void> update(ShortcutModel shortcut) async {
    // Hive: put = add OR update
    await _box.put(shortcut.id, shortcut);
  }

  // =========================
  // DELETE
  // =========================
  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  // =========================
  // SAVE ORDER (DRAG & DROP)
  // =========================
  Future<void> saveOrder(List<ShortcutModel> ordered) async {
    // czyścimy box, żeby kolejność była identyczna
    await _box.clear();

    for (final shortcut in ordered) {
      await _box.put(shortcut.id, shortcut);
    }
  }
}
