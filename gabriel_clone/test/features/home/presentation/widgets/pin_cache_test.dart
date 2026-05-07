import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/features/home/presentation/widgets/pin_cache.dart';

void main() {
  test('normaliza quantidade de cluster por buckets estaveis', () {
    expect(PinCache.sizeBucket(1), 1);
    expect(PinCache.sizeBucket(9), 1);
    expect(PinCache.sizeBucket(10), 10);
    expect(PinCache.sizeBucket(49), 10);
    expect(PinCache.sizeBucket(50), 50);
    expect(PinCache.sizeBucket(99), 50);
    expect(PinCache.sizeBucket(100), 100);
    expect(PinCache.sizeBucket(499), 100);
    expect(PinCache.sizeBucket(500), 500);
  });
}
