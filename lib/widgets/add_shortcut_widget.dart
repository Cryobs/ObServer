import 'package:flutter/material.dart';

class AddShortcutTile extends StatelessWidget {
  final VoidCallback onAdd;

  const AddShortcutTile({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 42, color: Colors.white54),
        ),
      ),
    );
  }
}
