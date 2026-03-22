import 'package:gamengine/gamengine.dart';

enum InputAction { rotateLeft, rotateRight, thrust, boost }

InputKeymap createInputKeymap() => InputKeymap<InputAction>()
  ..registerAction(action: .rotateLeft, keys: [.arrowLeft, .keyA])
  ..registerAction(action: .rotateRight, keys: [.arrowRight, .keyD])
  ..registerAction(action: .thrust, keys: [.space])
  ..registerAction(action: .boost, keys: [.shift]);
