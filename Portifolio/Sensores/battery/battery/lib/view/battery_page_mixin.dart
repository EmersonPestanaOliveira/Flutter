import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

import '../utils/battery_level_watcher.dart';
import '../utils/battery_time_estimator.dart';
import '../utils/battery_details.dart';

/// Mixin que concentra estado e lógica da tela de bateria,
/// deixando a view focada apenas no layout.
/// Chame:
///   - `initBatteryController(onBelowThreshold: ...)` no initState()
///   - `refreshBatteryInfo()` para atualizar manualmente
///   - `disposeBatteryController()` no dispose()
mixin BatteryPageMixin<T extends StatefulWidget> on State<T> {
  // Dependências
  final Battery _battery = Battery();
  BatteryLevelWatcher? watcher;
  StreamSubscription<BatteryState>? sub;

  // Estado exposto para a view
  int? level;
  BatteryState? batteryState;

  // ETA (aproximado)
  Duration? etaToEmpty;
  Duration? etaToFull;

  // Detalhes (Android)
  String tempTxt = '—', voltTxt = '—', currTxt = '—', techTxt = '—';

  /// Inicializa watcher/stream e faz a primeira leitura.
  /// onBelowThreshold(lvl) será chamado quando nível <= threshold (Android).
  void initBatteryController({
    required void Function(int lvl) onBelowThreshold,
    int threshold = 20,
  }) {
    watcher = BatteryLevelWatcher(
      threshold: threshold,
      pollInterval: const Duration(seconds: 10),
      onBelowThreshold: (lvl) {
        if (!mounted) return;
        onBelowThreshold(lvl);
      },
    )..start();

    sub = _battery.onBatteryStateChanged.listen((s) async {
      if (!mounted) return;
      setState(() => batteryState = s);
      await refreshBatteryInfo();
    });

    // primeira leitura
    // ignore: discarded_futures
    refreshBatteryInfo();
  }

  /// Atualiza nível, ETA e detalhes. Seguro para usar no botão "Atualizar".
  Future<void> refreshBatteryInfo() async {
    try {
      final lvl = await (watcher?.readOnce() ?? _battery.batteryLevel);
      if (!mounted) return;

      // ETA (Android) + detalhes (Android)
      if (Platform.isAndroid && lvl != null) {
        final est = await BatteryTimeEstimator.estimate(levelPercent: lvl);
        final d = await BatteryDetailsService.fetch();
        if (!mounted) return;
        setState(() {
          level = lvl;
          etaToEmpty = est.toEmpty;
          etaToFull = est.toFull;
          tempTxt = BatteryDetailsService.fmtTemp(d.temperatureC);
          voltTxt = BatteryDetailsService.fmtVolt(d.voltageMv);
          currTxt = BatteryDetailsService.fmtCurr(d.currentUa);
          techTxt = BatteryDetailsService.fmtTech(d.technology);
        });
      } else {
        setState(() {
          level = lvl;
          etaToEmpty = null;
          etaToFull = null;
          tempTxt = voltTxt = currTxt = techTxt = '—';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        level = null;
        etaToEmpty = null;
        etaToFull = null;
        tempTxt = voltTxt = currTxt = techTxt = '—';
      });
    }
  }

  /// Texto pronto da estimativa (para exibir abaixo do progress).
  String etaLine() {
    if (!Platform.isAndroid) return 'Estimativa: —';
    final isCharging =
        batteryState == BatteryState.charging ||
        batteryState == BatteryState.connectedNotCharging;
    if (isCharging) {
      return etaToFull == null
          ? 'Estimativa: —'
          : 'Tempo aprox. para carregar: ${BatteryTimeEstimator.pretty(etaToFull!)}';
    } else {
      return etaToEmpty == null
          ? 'Estimativa: —'
          : 'Tempo aprox. para descarregar: ${BatteryTimeEstimator.pretty(etaToEmpty!)}';
    }
  }

  /// Liberar recursos no dispose() da view.
  void disposeBatteryController() {
    watcher?.dispose();
    sub?.cancel();
  }
}
