import 'package:flutter/material.dart';


class AddServerWidget extends StatelessWidget {
  const AddServerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 130,
            child: Center(
              child: Icon(
                Icons.add,
                size: 48,
                color: Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
