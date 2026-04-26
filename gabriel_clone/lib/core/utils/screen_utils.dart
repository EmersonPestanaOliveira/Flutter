import 'package:flutter/widgets.dart';

abstract final class ScreenUtils {
  static bool isSmall(BuildContext context) => _width(context) < 360;

  static bool isMedium(BuildContext context) {
    final width = _width(context);
    return width >= 360 && width <= 414;
  }

  static bool isLarge(BuildContext context) => _width(context) > 414;

  static bool isTablet(BuildContext context) => _width(context) > 600;

  static double _width(BuildContext context) => MediaQuery.sizeOf(context).width;
}