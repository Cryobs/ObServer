import 'package:flutter/material.dart';

class InputList extends StatefulWidget {
  final String label;
  final List<String> options;

  const InputList({
    super.key,
    required this.options,
    required this.label,
  });

  @override
  State<StatefulWidget> createState() => _InputListState();
}

class _InputListState extends State<InputList> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: const Text(
                "Select",
                style: TextStyle(color: Colors.white38),
              ),
              borderRadius: BorderRadius.circular(20),
              iconEnabledColor: Colors.white,
              items: widget.options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
