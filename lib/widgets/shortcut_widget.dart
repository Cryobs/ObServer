import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pocket_ssh/models/shortcut_model.dart';
import 'package:pocket_ssh/services/ssh_controller.dart';

/// ======================================================
/// KAFEL EK SHORTCUTU (EDIT / DELETE / EXECUTE)
/// ======================================================
class EditableShortcutTile extends StatelessWidget {
  final ShortcutModel shortcut;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onChangeOrder;

  const EditableShortcutTile({
    super.key,
    required this.shortcut,
    required this.onEdit,
    required this.onDelete,
    required this.onChangeOrder,
  });

  @override
  Widget build(BuildContext context) {
    final ssh = context.read<SshController>();

    return Material(
      color: Colors.transparent,

      /// InkWell NIE BLOKUJE childów (menu działa)
      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        /// TAP → wykonaj komendę na serwerze
        onTap: () {
          if (shortcut.command.isNotEmpty) {
            ssh.run(shortcut.command);
          }
        },

        /// LONG PRESS → edycja
        onLongPress: onEdit,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            /// GRADIENT KAFELKA
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                shortcut.color.withOpacity(0.9),
                shortcut.color.withOpacity(0.6),
              ],
            ),
          ),

          child: Stack(
            children: [
              /// =========================
              /// IKONA (LEWY GÓRNY RÓG)
              /// =========================
              Positioned(
                top: 16,
                left: 16,
                child: Icon(
                  shortcut.icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              /// =========================
              /// MENU (PRAWY GÓRNY RÓG)
              /// =========================
              Positioned(
                top: 12,
                right: 12,
                child: PopupMenuButton<String>(
                  splashRadius: 20,

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
                    if (value == 'edit') onEdit();
                    if (value == 'order') onChangeOrder();
                    if (value == 'delete') _confirmDelete(context);
                  },

                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'order',
                      child: Text('Change order'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              /// =========================
              /// TEKST (ŚRODEK)
              /// =========================
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    shortcut.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// POTWIERDZENIE USUNIĘCIA
  /// =========================
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete shortcut'),
        content: const Text('Are you sure you want to delete this shortcut?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
