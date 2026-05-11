import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/home/domain/services/stress_pins_generator.dart';

void main() {
  test('gera a quantidade solicitada dentro de Sao Paulo', () {
    const generator = StressPinsGenerator();

    final pins = generator.generateSaoPauloPins(count: 1000);

    expect(pins, hasLength(1000));
    expect(pins.map((pin) => pin.id).toSet(), hasLength(1000));
    for (final pin in pins) {
      expect(pin.latitude, inInclusiveRange(-24.008, -23.357));
      expect(pin.longitude, inInclusiveRange(-46.826, -46.365));
      expect(pin.cidade, 'Sao Paulo');
    }
  });

  test('usa seed deterministica para facilitar reproducao do stress', () {
    const generator = StressPinsGenerator();

    final first = generator.generateSaoPauloPins(count: 10, seed: 7);
    final second = generator.generateSaoPauloPins(count: 10, seed: 7);

    expect(second, first);
  });

  test('retorna lista vazia para count nao positivo', () {
    const generator = StressPinsGenerator();

    expect(generator.generateSaoPauloPins(count: 0), isEmpty);
    expect(generator.generateSaoPauloPins(count: -1), isEmpty);
  });
}
