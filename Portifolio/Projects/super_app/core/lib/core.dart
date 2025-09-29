library core;

import 'package:flutter/widgets.dart';

abstract class MicroApp {
  String get name;
  String get initialRoute;
  Map<String, WidgetBuilder> get routes;
}
