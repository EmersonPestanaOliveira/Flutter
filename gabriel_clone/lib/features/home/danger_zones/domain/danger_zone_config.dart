class DangerZoneConfig {
  const DangerZoneConfig({
    required this.enabled,
    required this.minEvents,
    required this.radiusMeters,
    required this.timeWindowHours,
    required this.notificationCooldownMinutes,
  });

  static const disabled = DangerZoneConfig(
    enabled: false,
    minEvents: 5,
    radiusMeters: 300,
    timeWindowHours: 72,
    notificationCooldownMinutes: 60,
  );

  final bool enabled;
  final int minEvents;
  final double radiusMeters;
  final int timeWindowHours;
  final int notificationCooldownMinutes;

  Duration get timeWindow => Duration(hours: timeWindowHours);

  Duration get notificationCooldown =>
      Duration(minutes: notificationCooldownMinutes);
}
