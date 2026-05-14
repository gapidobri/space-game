import 'package:flutter/material.dart' hide Transform;
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_factory.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/run/components/current_stage.dart';

class Console extends StatefulWidget {
  const Console({super.key, required this.session, required this.onClose});

  final GameSession session;
  final Function() onClose;

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  static final _kTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Roboto Mono',
  );

  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final _history = <String>[];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final value = _textController.text;
    if (value.trim().isEmpty) return;

    _textController.clear();
    setState(() => _history.add(value));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _handleCommand(value);
  }

  void _handleCommand(String command) async {
    final GameSession(:engine, :assetManager) = widget.session;

    switch (command) {
      case 'spawn fighter':
        final alien = createAlienFighter(
          image: await assetManager.loadImage('assets/aliens/fighter.png'),
          position:
              engine.world
                  .query<RocketTag>()
                  .firstOrNull!
                  .get<Transform>()
                  .position +
              Vector2(0, -100),
          parent: engine.world.tryGetComponent<CurrentStage>()?.stage,
        );
        engine.addEntity(alien);
        break;

      case 'spawn frigate':
        final alien = createAlienFrigate(
          image: await assetManager.loadImage('assets/aliens/frigate.png'),
          position:
              engine.world
                  .query<RocketTag>()
                  .firstOrNull!
                  .get<Transform>()
                  .position +
              Vector2(0, -100),
          parent: engine.world.tryGetComponent<CurrentStage>()?.stage,
        );
        engine.addEntity(alien);
        break;

      case 'spawn torpedo':
        final alien = createAlienTorpedo(
          image: await assetManager.loadImage('assets/aliens/torpedo.png'),
          position:
              engine.world
                  .query<RocketTag>()
                  .firstOrNull!
                  .get<Transform>()
                  .position +
              Vector2(0, 700),
          parent: engine.world.tryGetComponent<CurrentStage>()?.stage,
        );
        engine.addEntity(alien);
        break;

      case 'spawn dreadnought':
        final alien = createAlienDreadnought(
          image: await assetManager.loadImage('assets/aliens/dreadnought.png'),
          position:
              engine.world
                  .query<RocketTag>()
                  .firstOrNull!
                  .get<Transform>()
                  .position +
              Vector2(0, 0),
          parent: engine.world.tryGetComponent<CurrentStage>()?.stage,
        );
        engine.addEntity(alien);
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.black.withValues(alpha: 0.5),
      width: 500,
      height: 300,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .end,
            children: [
              GestureDetector(
                onTap: widget.onClose,
                child: Text('x', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                width: double.infinity,
                child: Text(_history.join('\n'), style: _kTextStyle),
              ),
            ),
          ),
          Row(
            children: [
              Text('> ', style: _kTextStyle),
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: _kTextStyle,
                  decoration: InputDecoration(border: InputBorder.none),
                  onEditingComplete: _onSubmit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
