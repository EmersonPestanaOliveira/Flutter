import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/observability/telemetry.dart';
import 'package:gabriel_clone/features/home/domain/enums/alerta_tipo.dart';
import 'package:gabriel_clone/features/home/presentation/widgets/pin_cache.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  setUp(PinCache.clear);

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

  test('resolve pin com uma criacao real e hits subsequentes', () async {
    var created = 0;
    final telemetry = FakeTelemetry();

    for (var i = 0; i < 10; i++) {
      await PinCache.resolveAlertPin(
        AlertaTipo.rouboFurto,
        telemetry: telemetry,
        hitSampleRate: 1,
        createDescriptor: (_) async {
          created++;
          return BitmapDescriptor.defaultMarker;
        },
      );
    }

    expect(created, 1);
    expect(
      telemetry.events
          .where((event) => event == TelemetryEvents.mapIconCacheMiss)
          .length,
      1,
    );
    expect(
      telemetry.events
          .where((event) => event == TelemetryEvents.mapIconCacheHit)
          .length,
      9,
    );
  });
}

class FakeTelemetry extends Telemetry {
  FakeTelemetry();

  final events = <String>[];

  @override
  void log(String event, {Map<String, Object?> params = const {}}) {
    events.add(event);
  }
}
