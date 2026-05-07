import 'package:flutter/widgets.dart';

abstract final class AppResponsive {
  static const double compactMaxWidth = 359;
  static const double phoneMaxWidth = 600;
  static const double contentMaxWidth = 560;

  static bool isCompact(BuildContext context) =>
      width(context) <= compactMaxWidth;

  static bool isTablet(BuildContext context) => width(context) >= phoneMaxWidth;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double horizontalPadding(BuildContext context) {
    final currentWidth = width(context);
    if (currentWidth <= compactMaxWidth) {
      return 12;
    }
    if (currentWidth >= phoneMaxWidth) {
      return 32;
    }
    return 16;
  }

  static double topOverlayPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).top + 16;
  }

  static double bottomOverlayPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom + 16;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final horizontal = horizontalPadding(context);
    return EdgeInsets.fromLTRB(horizontal, 20, horizontal, 24);
  }

  static Widget constrainedContent({
    required BuildContext context,
    required Widget child,
    double maxWidth = contentMaxWidth,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
