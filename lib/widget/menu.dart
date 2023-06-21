import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final String text;
  final IconData icon;

  const Menu({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 30,
          ),
          Text(text)
        ],
      ),
    );
  }
}
