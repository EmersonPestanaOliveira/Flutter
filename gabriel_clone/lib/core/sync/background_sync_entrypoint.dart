import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../../firebase_options.dart';
import '../di/injection_container.dart';
import '../observability/telemetry.dart';
import 'ocorrencia_sync_worker.dart';

const ocorrenciaSyncPeriodicTask = 'ocorrencia_sync_periodic';

/// Entrypoint do isolate de background do WorkManager.
///
/// Android executa respeitando a janela minima de 15 min e rede conectada.
/// No iOS, o WorkManager usa os bindings de BGTaskScheduler/Background Fetch,
/// que sao best-effort: o sistema pode atrasar ou pular execucoes para preservar
/// bateria, historico de uso e condicoes de rede.
@pragma('vm:entry-point')
void ocorrenciaSyncCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await setupLocator();
      final telemetry = sl<Telemetry>();
      telemetry.log(
        TelemetryEvents.syncBackgroundStarted,
        params: {'taskName': taskName},
      );
      final result = await sl<OcorrenciaSyncWorker>().syncPendingOcorrencias();
      telemetry.log(
        TelemetryEvents.syncBackgroundFinished,
        params: {
          'taskName': taskName,
          'total': result.total,
          'success': result.success,
          'failed': result.failed,
        },
      );
      return true;
    } catch (error, stackTrace) {
      debugPrint('[WorkManager] Background sync failed: ${error.runtimeType}');
      if (sl.isRegistered<Telemetry>()) {
        sl<Telemetry>().recordError(
          error,
          stackTrace,
          reason: 'background_ocorrencia_sync',
        );
      }
      return false;
    }
  });
}

Future<void> configureBackgroundOcorrenciaSync() async {
  await Workmanager().initialize(ocorrenciaSyncCallbackDispatcher);
  await Workmanager().registerPeriodicTask(
    ocorrenciaSyncPeriodicTask,
    ocorrenciaSyncPeriodicTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
