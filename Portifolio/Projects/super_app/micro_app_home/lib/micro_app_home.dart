library micro_app_home;

import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:micro_app_home/home_page.dart';

class MicroAppHome implements MicroApp {
  @override
  String get name => 'micro_app_home';

  @override
  String get initialRoute => '/home';

  @override
  Map<String, WidgetBuilder> get routes => {
        initialRoute: (context) => const HomePage(),
      };
}
