import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_service.dart';
import '../database/app_database.dart';
import '../network/network_connection_monitor.dart';
import '../observability/telemetry.dart';
import '../profile/profile_photo_cache.dart';
import '../security/attachment_storage.dart';
import '../security/local_payload_crypto.dart';
import '../sync/ocorrencia_sync_orchestrator.dart';
import '../sync/ocorrencia_sync_worker.dart';
import '../../features/home/data/datasources/alerta_remote_datasource.dart';
import '../../features/home/data/datasources/camera_remote_datasource.dart';
import '../../features/home/data/repositories/alerta_repository_impl.dart';
import '../../features/home/data/repositories/camera_repository_impl.dart';
import '../../features/home/danger_zones/data/danger_zone_location_monitor.dart';
import '../../features/home/danger_zones/data/danger_zone_notification_service.dart';
import '../../features/home/danger_zones/data/danger_zone_remote_config_service.dart';
import '../../features/home/danger_zones/data/danger_zone_service.dart';
import '../../features/home/danger_zones/domain/danger_zone_calculator.dart';
import '../../features/home/domain/repositories/alerta_repository.dart';
import '../../features/home/domain/repositories/camera_repository.dart';
import '../../features/home/domain/usecases/get_alertas_in_bounds_usecase.dart';
import '../../features/home/domain/usecases/get_alertas_usecase.dart';
import '../../features/home/domain/usecases/get_cameras_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/ocorrencias/data/datasources/ocorrencia_local_datasource.dart';
import '../../features/ocorrencias/data/datasources/ocorrencia_remote_datasource.dart';
import '../../features/ocorrencias/data/repositories/ocorrencia_repository_impl.dart';
import '../../features/ocorrencias/domain/repositories/ocorrencia_repository.dart';
import '../../features/ocorrencias/domain/usecases/create_ocorrencia_usecase.dart';
import '../../features/ocorrencias/domain/usecases/watch_my_ocorrencias_usecase.dart';
import '../../features/ocorrencias/presentation/cubit/ocorrencia_form_cubit.dart';
import '../firebase/firebase_connection_validator.dart';
import '../theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final preferences = await SharedPreferences.getInstance();
  final documentsDir = await getApplicationDocumentsDirectory();

  sl
    // ── Core ──────────────────────────────────────────────────────────────
    ..registerLazySingleton(ThemeCubit.new)
    ..registerLazySingleton(NetworkConnectionMonitor.new)
    ..registerLazySingleton(Telemetry.new)
    ..registerLazySingleton<SharedPreferences>(() => preferences)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => ProfilePhotoCache(sl()))
    ..registerLazySingleton(
      () => AuthService(
        firebaseAuth: sl(),
        firestore: sl(),
        storage: sl(),
        profilePhotoCache: sl(),
      ),
    )
    // ── Security ──────────────────────────────────────────────────────────
    ..registerLazySingleton<LocalCryptoKeyStore>(
      () => const SecureStorageLocalCryptoKeyStore(),
    )
    ..registerLazySingleton<LocalPayloadCrypto>(
      () => AesGcmLocalPayloadCrypto(sl()),
    )
    ..registerLazySingleton<AttachmentStorage>(
      () => EncryptedAttachmentStorage(documentsDir.path, sl()),
    )
    // ── Danger Zones ──────────────────────────────────────────────────────
    ..registerLazySingleton(DangerZoneRemoteConfigService.new)
    ..registerLazySingleton(DangerZoneNotificationService.new)
    ..registerLazySingleton(() => const DangerZoneCalculator())
    ..registerLazySingleton(
      () => DangerZoneService(remoteConfigService: sl(), calculator: sl()),
    )
    ..registerLazySingleton(
      () => DangerZoneLocationMonitor(
        preferences: sl(),
        notificationService: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseConnectionValidator(firestore: sl()))
    // ── Home feature ──────────────────────────────────────────────────────
    ..registerLazySingleton<CameraRemoteDatasource>(
      () => CameraRemoteDatasourceImpl(sl()),
    )
    ..registerLazySingleton<AlertaRemoteDatasource>(
      () => AlertaRemoteDatasourceImpl(sl(), telemetry: sl()),
    )
    ..registerLazySingleton<CameraRepository>(() => CameraRepositoryImpl(sl()))
    ..registerLazySingleton<AlertaRepository>(() => AlertaRepositoryImpl(sl()))
    ..registerFactory(() => GetCamerasUseCase(sl()))
    ..registerFactory(() => GetAlertasUseCase(sl()))
    ..registerFactory(() => GetAlertasInBoundsUseCase(sl()))
    // HomeCubit agora recebe Telemetry explicitamente (sem sl<> global interno)
    ..registerFactory(
      () => HomeCubit(
        sl(),
        sl(),
        sl(),
        telemetry: sl(),
        localOcorrencias: sl(),
        retryFailedOcorrenciaUseCase: sl(),
      ),
    )
    // ── Database (SQLite) ─────────────────────────────────────────────────
    ..registerLazySingleton(AppDatabase.new)
    ..registerLazySingleton(() => sl<AppDatabase>().pendingOcorrenciasDao)
    // ── Ocorrencias feature ───────────────────────────────────────────────
    ..registerLazySingleton<OcorrenciaLocalDatasource>(
      () => OcorrenciaLocalDatasourceImpl(sl<PendingOcorrenciasDao>(), sl()),
    )
    ..registerLazySingleton<OcorrenciaRemoteDatasource>(
      () => OcorrenciaRemoteDatasourceImpl(
        firestore: sl(),
        auth: sl(),
        storage: sl(),
        attachmentStorage: sl(),
        telemetry: sl(),
      ),
    )
    ..registerLazySingleton<OcorrenciaRepository>(
      () => OcorrenciaRepositoryImpl(
        local: sl(),
        remote: sl(),
        network: sl(),
        telemetry: sl(),
        attachmentStorage: sl(),
      ),
    )
    ..registerLazySingleton(
      () => OcorrenciaSyncWorker(
        local: sl(),
        remote: sl(),
        telemetry: sl(),
        attachmentStorage: sl(),
      ),
    )
    ..registerLazySingleton(
      () => OcorrenciaSyncOrchestrator(
        network: sl<NetworkConnectionMonitor>(),
        syncPendingOcorrencias:
            sl<OcorrenciaSyncWorker>().syncPendingOcorrencias,
        telemetry: sl(),
      ),
    )
    ..registerFactory(() => CreateOcorrenciaUseCase(sl()))
    ..registerFactory(() => WatchMyOcorrenciasUseCase(sl()))
    ..registerFactory(() => WatchPendingOcorrenciasUseCase(sl()))
    ..registerFactory(() => RetryFailedOcorrenciaUseCase(sl()))
    // OcorrenciaFormCubit — factory para nova instância por tela
    ..registerFactory(
      () => OcorrenciaFormCubit(createUseCase: sl(), telemetry: sl()),
    );
}
