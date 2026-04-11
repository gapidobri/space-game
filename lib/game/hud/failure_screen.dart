import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/widgets/button.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({super.key, required this.onReset});

  final void Function() onReset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.black,
            child: const Text(
              'Rocket Destroyed ):',
              style: TextStyle(color: Colors.white, fontSize: 32.0),
            ),
          ),
          SizedBox(height: 32.0),
          Button(text: 'Retry', onClick: onReset),
          SizedBox(height: 8.0),
          Button(text: 'Main Menu', onClick: () => context.go('/')),
        ],
      ),
    );
  }
}
