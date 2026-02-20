import 'package:flutter/material.dart';
import 'package:pocket_ssh/theme/app_theme.dart';

class AddServerWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const AddServerWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariantDark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            SizedBox(
              height: 130,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 48,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8,),
                    Text(
                      "Add server",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold
                      ),
                    )                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}