import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../domain/danger_zone.dart';

class DangerZoneNotificationService {
  DangerZoneNotificationService({
    FlutterLocalNotificationsPlugin? notifications,
  }) : _notifications = notifications ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'danger_zones';
  static const _channelName = 'Areas de Atencao';
  static const _channelDescription =
      'Alertas de seguranca ao entrar em areas de atencao.';

  final FlutterLocalNotificationsPlugin _notifications;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      ),
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> showDangerZoneAlert(DangerZone zone) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    await _notifications.show(
      zone.id.hashCode,
      'Alerta de seguranca',
      'Voce entrou em uma area com alta concentracao de ocorrencias de '
          '${zone.eventType} nos ultimos dias.',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }
}
