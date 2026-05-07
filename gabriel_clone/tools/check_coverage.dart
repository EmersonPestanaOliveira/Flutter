import 'dart:io';

const minCoverage = 70.0;

void main(List<String> args) {
  final path = args.isEmpty ? 'coverage/lcov.info' : args.first;
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Coverage file not found: $path');
    stderr.writeln('Run: flutter test --coverage');
    exit(1);
  }

  var found = 0;
  var hit = 0;
  for (final line in file.readAsLinesSync()) {
    if (!line.startsWith('DA:')) {
      continue;
    }

    final parts = line.substring(3).split(',');
    if (parts.length != 2) {
      continue;
    }

    found++;
    final count = int.tryParse(parts[1]) ?? 0;
    if (count > 0) {
      hit++;
    }
  }

  final coverage = found == 0 ? 0.0 : (hit / found) * 100;
  stdout.writeln('Line coverage: ${coverage.toStringAsFixed(2)}%');

  if (coverage < minCoverage) {
    stderr.writeln(
      'Coverage below ${minCoverage.toStringAsFixed(0)}% minimum.',
    );
    exit(1);
  }
}
