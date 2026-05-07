import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

import 'core/di/injection_container.dart';
import 'core/network/network_connection_monitor.dart';
import 'core/router/app_router.dart';
import 'core/sync/ocorrencia_sync_worker.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/widgets/network_status_banner.dart';
import 'features/ocorrencias/domain/usecases/watch_my_ocorrencias_usecase.dart';
import 'firebase_options.dart';

// ---------------------------------------------------------------------------
// WorkManager — nomes de tarefas
// ---------------------------------------------------------------------------
const _kSyncTaskUniqueName = 'ocorrencia_sync_periodic';

/// Dispatcher executado pelo WorkManager em isolate de background.
/// Deve ser top-level e anotado com @pragma('vm:entry-point').
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await setupLocator();
      final worker = sl<OcorrenciaSyncWorker>();
      await worker.syncPendingOcorrencias();
      return true;
    } catch (e) {
      debugPrint('[WorkManager] Erro no background sync: $e');
      return false;
    }
  });
}

void main() {
  runZonedGuarded(
    () async {
      await _bootstrap();
      runApp(const MyApp());
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await setupLocator();

  // ── WorkManager ──────────────────────────────────────────────────────────
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Workmanager().registerPeriodicTask(
    _kSyncTaskUniqueName,
    _kSyncTaskUniqueName,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  // ── Sync imediato ao voltar online ───────────────────────────────────────
  sl<NetworkConnectionMonitor>().onBackOnline = () {
    debugPrint('[main] Conexão restaurada → sync imediato.');
    sl<OcorrenciaSyncWorker>().syncPendingOcorrencias().ignore();
  };

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Gabriel Clone',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: NetworkStatusBanner(
                  monitor: sl<NetworkConnectionMonitor>(),
                  pendingStream: sl<WatchPendingOcorrenciasUseCase>().call(),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
