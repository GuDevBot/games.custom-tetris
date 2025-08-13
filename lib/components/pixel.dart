import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({
    super.key,
    this.color,
    required this.index
  });

  final Color? color;
  final int index;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      child: Center(child: Text(index.toString(), style: TextStyle(color: Colors.white),)),
    );
  }
}