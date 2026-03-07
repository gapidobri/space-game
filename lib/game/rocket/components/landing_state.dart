import 'package:gamengine/gamengine.dart';

class LandingState extends Component {

  LandingState({this.hasLanded = false, this.planet});
  bool hasLanded;
  Entity? planet;
}
