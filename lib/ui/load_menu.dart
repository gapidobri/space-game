import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/game/persistence/persistence.dart';
import 'package:space_game/ui/widgets/button.dart';

class LoadMenu extends StatefulWidget {
  const LoadMenu({super.key});

  @override
  State<LoadMenu> createState() => _LoadMenuState();
}

class _LoadMenuState extends State<LoadMenu> {
  List<String>? saves;

  @override
  void initState() {
    super.initState();
    _loadSaves();
  }

  void _loadSaves() async {
    final s = await Persistence.instance.listSaves();
    setState(() => saves = s);
  }

  void _deleteSave(String fileName) async {
    await Persistence.instance.deleteSave(fileName);
    _loadSaves();
  }

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
        if (saves == null)
          CircularProgressIndicator()
        else if (saves!.isEmpty)
          Text(
            'No saves found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          )
        else
          SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              children: [
                for (final save in saves!)
                  Row(
                    mainAxisSize: .min,
                    children: [
                      MenuButton.text(
                        onClick: () => context.go('/game', extra: save),
                        text: save,
                      ),
                      const SizedBox(width: 16.0),
                      MenuButton(
                        onClick: () => _deleteSave(save),
                        child: Image.asset('assets/icons/trash.png'),
                      ),
                    ],
                  ),
              ],
            ),
          ),

        SizedBox(height: 128.0),
        MenuButton.text(text: 'Back', onClick: () => context.pop()),
      ],
    );
  }
}
