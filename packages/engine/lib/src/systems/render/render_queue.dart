import 'package:flutter/foundation.dart';
import 'package:gamengine/src/systems/render/render_commands.dart';

class RenderQueue extends ChangeNotifier {
  final _commands = <RenderCommand>[];

  List<RenderCommand> get commands => _commands;

  void beginFrame() {
    _commands.clear();
  }

  void add(RenderCommand command) {
    _commands.add(command);
  }

  void endFrame() {
    _commands.sort((a, b) => a.z.compareTo(b.z));
    notifyListeners();
  }
}
