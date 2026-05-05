import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/game/persistence/persistence.dart';
import 'package:space_game/ui/widgets/button.dart';

class LoadMenu extends StatelessWidget {
  const LoadMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Load Game',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64.0,
            fontFamily: 'Doto',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 128.0),
        FutureBuilder(
          future: Persistence.instance.listSaves(),
          builder: (context, future) {
            final saves = future.data;
            if (saves == null) {
              return CircularProgressIndicator();
            }

            if (saves.isEmpty) {
              return Text(
                'No saves found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: saves.length,
              itemBuilder: (context, index) {
                final saveFile = saves[index];
                return ListTile(
                  title: Text(
                    saveFile,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () => context.go('/game', extra: saveFile),
                );
              },
            );
          },
        ),
        SizedBox(height: 128.0),
        Button(text: 'Back', onClick: () => context.pop()),
      ],
    );
  }
}
