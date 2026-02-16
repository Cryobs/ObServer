import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const InputText({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                controller: controller,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                onChanged: onChanged,
              ),
            )
        )
      ],
    );
  }
}