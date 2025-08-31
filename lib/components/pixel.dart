import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}