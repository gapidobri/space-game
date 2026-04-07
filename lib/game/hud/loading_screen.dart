import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Loading...',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
    );
  }
}
