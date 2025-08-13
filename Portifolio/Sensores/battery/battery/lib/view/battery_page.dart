import 'dart:io' show Platform;
import 'package:battery/utils/battery_health.dart';
import 'package:battery/utils/battery_saver.dart';
import 'package:battery/utils/battery_state_styles.dart';
import 'package:battery/view/battery_page_mixin.dart';
import 'package:battery/widgets/battery_meter.dart';
import 'package:battery/widgets/battery_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});
  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage>
    with BatteryPageMixin<BatteryPage> {
  @override
  void initState() {
    super.initState();
    initBatteryController(
      onBelowThreshold: (lvl) {
        if (!Platform.isAndroid || !mounted) return;
        _showSaverDialog(lvl);
      },
    );
  }

  @override
  void dispose() {
    disposeBatteryController();
    super.dispose();
  }

  void _showSaverDialog(int lvl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Economia de energia'),
        content: Text(
          'Sua bateria está em $lvl%. '
          'Deseja abrir as configurações para ativar o modo de economia?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              BatterySaver.openSettings();
            },
            child: const Text('Abrir configurações'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkBatteryHealth() async {
    final info = await BatteryHealthService.getHealth();
    if (!mounted) return;
    final label = BatteryHealthService.label(info.status);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Saúde da bateria'),
        content: Text('Status: $label\n(código Android: ${info.rawCode})'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = styleForBatteryState(batteryState);
    final showPowerIcon =
        batteryState == BatteryState.charging ||
        batteryState == BatteryState.connectedNotCharging;

    return Scaffold(
      appBar: AppBar(title: const Text('Nível de Bateria')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BatteryMeter(
              level: level,
              color: color,
              showPowerIcon: showPowerIcon,
            ),

            const SizedBox(height: 8),
            Text(
              etaLine(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),
            Text(
              level == null ? '--' : '$level%',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BatteryStatusChip(label: label, color: color, icon: icon),
            const SizedBox(height: 24),

            if (Platform.isAndroid)
              FilledButton.icon(
                onPressed: BatterySaver.openSettings,
                icon: const Icon(Icons.battery_saver),
                label: const Text('Ativar economia de energia'),
              ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: refreshBatteryInfo,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar agora'),
            ),
            const SizedBox(height: 12),
            if (Platform.isAndroid)
              FilledButton.icon(
                onPressed: _checkBatteryHealth,
                icon: const Icon(Icons.health_and_safety),
                label: const Text('Ver saúde da bateria'),
              ),

            const SizedBox(height: 24),
            if (Platform.isAndroid)
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withAlpha(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      _rowKV('Temperatura', tempTxt),
                      const SizedBox(height: 8),
                      _rowKV('Voltagem', voltTxt),
                      const SizedBox(height: 8),
                      _rowKV('Corrente', currTxt),
                      const SizedBox(height: 8),
                      _rowKV('Tecnologia', techTxt),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _rowKV(String k, String v) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Flexible(child: Text(v, textAlign: TextAlign.right)),
      ],
    );
  }
}
