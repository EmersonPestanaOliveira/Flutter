import 'package:flutter/widgets.dart';

import '../design_system/app_responsive.dart';

abstract final class ScreenUtils {
  static bool isSmall(BuildContext context) => AppResponsive.isCompact(context);

  static bool isMedium(BuildContext context) {
    final width = AppResponsive.width(context);
    return width >= 360 && width <= 414;
  }

  static bool isLarge(BuildContext context) =>
      AppResponsive.width(context) > 414;

  static bool isTablet(BuildContext context) => AppResponsive.isTablet(context);

  static double horizontalPadding(BuildContext context) {
    return AppResponsive.horizontalPadding(context);
  }

  static double bottomOverlayPadding(BuildContext context) {
    return AppResponsive.bottomOverlayPadding(context);
  }

  static double topOverlayPadding(BuildContext context) {
    return AppResponsive.topOverlayPadding(context);
  }
}
