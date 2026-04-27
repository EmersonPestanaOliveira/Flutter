import 'package:flutter/widgets.dart';

abstract final class ScreenUtils {
  static bool isSmall(BuildContext context) => _width(context) < 360;

  static bool isMedium(BuildContext context) {
    final width = _width(context);
    return width >= 360 && width <= 414;
  }

  static bool isLarge(BuildContext context) => _width(context) > 414;

  static bool isTablet(BuildContext context) => _width(context) > 600;

  static double horizontalPadding(BuildContext context) {
    if (isSmall(context)) {
      return 12;
    }
    if (isTablet(context)) {
      return 32;
    }
    return 16;
  }

  static double bottomOverlayPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom + 16;
  }

  static double topOverlayPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).top + 16;
  }

  static double _width(BuildContext context) => MediaQuery.sizeOf(context).width;
}