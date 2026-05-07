class LoginMetrics {
  const LoginMetrics({
    required this.logoHeight,
    required this.titleSize,
    required this.subtitleSize,
    required this.fieldHeight,
    required this.primaryButtonHeight,
    required this.googleButtonHeight,
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.headerGap,
    required this.fieldGap,
    required this.actionsGap,
  });

  factory LoginMetrics.fromHeight(double height) {
    if (height < 680) {
      return const LoginMetrics(
        logoHeight: 58,
        titleSize: 24,
        subtitleSize: 16,
        fieldHeight: 54,
        primaryButtonHeight: 54,
        googleButtonHeight: 50,
        horizontalPadding: 24,
        topPadding: 12,
        bottomPadding: 14,
        headerGap: 8,
        fieldGap: 10,
        actionsGap: 14,
      );
    }

    if (height < 780) {
      return const LoginMetrics(
        logoHeight: 120,
        titleSize: 27,
        subtitleSize: 18,
        fieldHeight: 58,
        primaryButtonHeight: 58,
        googleButtonHeight: 54,
        horizontalPadding: 28,
        topPadding: 18,
        bottomPadding: 20,
        headerGap: 10,
        fieldGap: 12,
        actionsGap: 18,
      );
    }

    return const LoginMetrics(
      logoHeight: 120,
      titleSize: 29,
      subtitleSize: 20,
      fieldHeight: 62,
      primaryButtonHeight: 64,
      googleButtonHeight: 58,
      horizontalPadding: 30,
      topPadding: 24,
      bottomPadding: 26,
      headerGap: 12,
      fieldGap: 16,
      actionsGap: 24,
    );
  }

  final double logoHeight;
  final double titleSize;
  final double subtitleSize;
  final double fieldHeight;
  final double primaryButtonHeight;
  final double googleButtonHeight;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double headerGap;
  final double fieldGap;
  final double actionsGap;
}
