import 'package:hive/hive.dart';
import '../models/shortcut_model.dart';

class ShortcutsRepository {
  static const String _boxName = 'shortcuts';

  late Box<ShortcutModel> _box;

  Future<void> init() async {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box<ShortcutModel>(_boxName);
    } else {
      _box = await Hive.openBox<ShortcutModel>(_boxName);
    }
  }


  List<ShortcutModel> getAll() {
    return _box.values.toList();
  }


  Future<void> add(ShortcutModel shortcut) async {
    await _box.put(shortcut.id, shortcut);
  }


  Future<void> update(ShortcutModel shortcut) async {
    await _box.put(shortcut.id, shortcut);
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
  }

  // =========================
  // SAVE ORDER (DRAG & DROP)
  // =========================
  Future<void> saveOrder(List<ShortcutModel> ordered) async {
    await _box.clear();
    for (final shortcut in ordered) {
      await _box.put(shortcut.id, shortcut);
    }
  }
}
