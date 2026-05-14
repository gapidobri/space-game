import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/widgets/button.dart';

class SaveDialog extends StatefulWidget {
  const SaveDialog({super.key});

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32.0),
        color: Colors.white.withValues(alpha: 0.2),
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            Text(
              'Save Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontFamily: 'Doto',
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 32.0),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.black,
              width: 300.0,
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontFamily: 'Doto',
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Save Name',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 24.0,
                    fontFamily: 'Doto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32.0),

            Row(
              mainAxisSize: .min,
              spacing: 16.0,
              children: [
                MenuButton.text(
                  text: 'Cancel',
                  onClick: () => context.pop(null),
                ),
                MenuButton.text(
                  text: 'Save',
                  onClick: () => context.pop(_controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
