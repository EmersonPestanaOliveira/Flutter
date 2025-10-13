import 'package:flutter/material.dart';

class ResponsiveTwoPane extends StatelessWidget {
  const ResponsiveTwoPane({
    super.key,
    required this.preview,
    required this.controls,
  });

  final Widget preview;
  final Widget controls;

  static const double _breakTablet = 700;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isPortrait = mq.orientation == Orientation.portrait;
    final isCompact = width < _breakTablet || isPortrait;

    if (isCompact) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              AspectRatio(aspectRatio: 1, child: preview),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(margin: EdgeInsets.zero, child: controls),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(flex: 3, child: preview),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(margin: const EdgeInsets.all(16), child: controls),
            ),
          ),
        ),
      ],
    );
  }
}
