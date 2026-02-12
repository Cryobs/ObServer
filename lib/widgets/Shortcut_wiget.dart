import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PALETA
final List<Color> teamColors = [
  Color(0xFF1C7CA6),
  Color(0xFF54A4AF),
  Color(0xFF9E1C60),
  Color(0xFF986A44),
  Color(0xFFE52020),
  Color(0xFF9141AC),
  Color(0xFF750E21),
  Color(0xFFD63838),
];

class EditableShortcutTile extends StatefulWidget {
  final VoidCallback? onDelete;

  const EditableShortcutTile({
    super.key,
    this.onDelete,
  });

  @override
  State<EditableShortcutTile> createState() => _EditableShortcutTileState();
}

class _EditableShortcutTileState extends State<EditableShortcutTile>
    with AutomaticKeepAliveClientMixin {
  // =========================
  // DANE
  // =========================
  String title = 'New';
  IconData icon = Icons.apps;
  Color backgroundColor = Colors.blue;
  Color tempColor = Colors.blue;


  static const _titleKey = 'shortcut_title';
  static const _iconKey = 'shortcut_icon';
  static const _colorKey = 'shortcut_color';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  bool get wantKeepAlive => true;

  // =========================
  // WCZYTYWANIE
  // =========================
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      title = prefs.getString(_titleKey) ?? 'New';

      icon = IconData(
        prefs.getInt(_iconKey) ?? Icons.apps.codePoint,
        fontFamily: 'MaterialIcons',
      );

      backgroundColor = Color(
        prefs.getInt(_colorKey) ?? teamColors.first.value,
      );

      tempColor = backgroundColor;
    });
  }

  // =========================
  // ZAPIS
  // =========================
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_titleKey, title);
    await prefs.setInt(_iconKey, icon.codePoint);
    await prefs.setInt(_colorKey, backgroundColor.value);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      width: 175,
      height: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          /// (IKONA + MENU)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

              PopupMenuButton<String>(
                icon: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'name') _changeName();
                  if (value == 'icon') _changeIcon();
                  if (value == 'color') _changeColor();
                  if (value == 'delete') _confirmDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'name', child: Text('Change name')),
                  PopupMenuItem(value: 'icon', child: Text('Change icon')),
                  PopupMenuItem(value: 'color', child: Text('Change color')),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),



          /// TEKST
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // ZMIANA NAZWY
  // =========================
  void _changeName() {
    final controller = TextEditingController(text: title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                title = controller.text;
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // =========================
  // ZMIANA IKONY
  // =========================
  void _changeIcon() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose icon'),
        children: [
          _iconOption(Icons.language),
          _iconOption(Icons.security),
          _iconOption(Icons.folder),
          _iconOption(Icons.web),
        ],
      ),
    );
  }

  Widget _iconOption(IconData newIcon) {
    return IconButton(
      icon: Icon(newIcon),
      onPressed: () {
        setState(() {
          icon = newIcon;
        });
        _saveData();
        Navigator.pop(context);
      },
    );
  }

  // =========================
  // ZMIANA KOLORU
  // =========================
  void _changeColor() {
    tempColor = backgroundColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose color'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ColorPicker(
                pickerColor: tempColor,
                onColorChanged: (color) {
                  setState(() {
                    tempColor = color;
                  });
                },
                enableAlpha: false,
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
              const SizedBox(height: 12),
              Text(
                '#${tempColor.value.toRadixString(16).substring(2).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                backgroundColor = tempColor;
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // =========================
  // USUWANIE KAFELKA
  // =========================
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete shortcut'),
        content: const Text(
          'Are you sure you want to delete this shortcut?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete?.call();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
