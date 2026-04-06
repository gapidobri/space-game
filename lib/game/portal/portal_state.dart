import 'package:gamengine/gamengine.dart';

enum PortalStatus { closed, activated, teleporting, completed }

class PortalState extends Component {
  PortalState({this.status = .closed});

  PortalStatus status;
}
