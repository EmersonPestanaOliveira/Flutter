import 'package:flutter/material.dart';

enum StrokeMode { solid, rainbow } // <-- NOVO

class StrokeConfig {
  final Color color;
  final double width;
  final bool shadow;
  final double shadowSigma;
  final StrokeMode mode; // <-- NOVO

  const StrokeConfig({
    this.color = const Color(0xFFF48FB1),
    this.width = 1.6,
    this.shadow = false,
    this.shadowSigma = 6.0,
    this.mode = StrokeMode.solid, // <-- default mantém cor única
  });

  StrokeConfig copyWith({
    Color? color,
    double? width,
    bool? shadow,
    double? shadowSigma,
    StrokeMode? mode,
  }) => StrokeConfig(
    color: color ?? this.color,
    width: width ?? this.width,
    shadow: shadow ?? this.shadow,
    shadowSigma: shadowSigma ?? this.shadowSigma,
    mode: mode ?? this.mode,
  );
}
