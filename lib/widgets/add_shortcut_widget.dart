import 'package:flutter/material.dart';
import 'package:pocket_ssh/theme/app_theme.dart';

class AddShortcutTile extends StatelessWidget {
  final VoidCallback onAdd;

  const AddShortcutTile({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 175,
        height: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppColors.surfaceVariantDark,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: AppColors.onSurfaceVariant,
              size: 40,
            ),
            SizedBox(height: 8,),
            Text(
              "Add shortcut",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}
