import 'package:flutter/material.dart';

class ModeOption extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ModeOption({
    Key? key,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.pink[50]?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            color: Color(0xFF111827), // text-gray-900 equivalent
          ),
        ),
      ),
    );
  }
}