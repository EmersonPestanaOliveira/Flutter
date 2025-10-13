class Epicycle {
  final double speed; // frequência
  final double length; // raio
  final int direction; // +1 anti-horário, -1 horário
  final double phase; // fase inicial

  Epicycle({
    required this.speed,
    required this.length,
    required this.direction,
    required this.phase,
  });

  Epicycle copyWith({
    double? speed,
    double? length,
    int? direction,
    double? phase,
  }) => Epicycle(
    speed: speed ?? this.speed,
    length: length ?? this.length,
    direction: direction ?? this.direction,
    phase: phase ?? this.phase,
  );
}
