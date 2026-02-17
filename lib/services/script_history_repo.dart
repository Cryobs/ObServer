import 'package:hive/hive.dart';
import 'package:pocket_ssh/models/script_run.dart';

class ScriptHistoryRepository {
  static final ScriptHistoryRepository _instance = ScriptHistoryRepository._internal();
  factory ScriptHistoryRepository() => _instance;
  ScriptHistoryRepository._internal();

  late Box<ScriptRun> _box;

  Future<void> init() async {
    _box = await Hive.openBox<ScriptRun>('script_history');
  }

  List<ScriptRun> getRuns(String shortcutId) {
    return _box.values
        .where((r) => r.shortcutId == shortcutId)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  Future<void> addRun(ScriptRun run) async {
    await _box.put(run.id, run);
  }
}
