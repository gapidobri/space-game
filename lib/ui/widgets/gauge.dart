import 'package:flutter/material.dart';

class Gauge extends StatelessWidget {
  const Gauge({super.key, required this.progress, this.color});

  final double progress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = (progress * 10).ceil();
    return Row(
      spacing: 4.0,
      children: [
        for (int i = 0; i < 10; i++)
          Container(
            color: i > p ? Colors.black : color ?? Colors.white,
            width: 10,
            height: 20,
          ),
      ],
    );
  }
}
