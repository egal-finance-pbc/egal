import 'package:flutter_session/flutter_session.dart';

import '../clients/api.dart';

class Dependencies {
  final api = API();
  final session = FlutterSession();
}
