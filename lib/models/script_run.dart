import 'package:hive/hive.dart';

part 'script_run.g.dart';

@HiveType(typeId: 3)
class ScriptRun extends HiveObject {
  @HiveField(0)
  String shortcutId;

  @HiveField(1)
  String id;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  String output;

  @HiveField(4)
  bool finished;

  ScriptRun({
    required this.id,
    required this.shortcutId,
    required this.startTime,
    required this.output,
    this.finished = true,
  });
}
