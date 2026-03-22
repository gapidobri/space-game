import 'package:gamengine/gamengine.dart';

enum StageSetupStatus { idle, generating, ready }

class StageSetupState extends Component {
  StageSetupState({this.status = .idle});

  StageSetupStatus status;
}
