import 'package:flutter/material.dart';

class BatteryMeter extends StatelessWidget {
  final int? level;
  final Color color;
  final bool showPowerIcon;

  const BatteryMeter({
    super.key,
    required this.level,
    required this.color,
    required this.showPowerIcon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = level == null ? null : (level!.clamp(0, 100)) / 100.0;

    final bg = color.withAlpha(26); // fundo fraco
    final bd = color.withAlpha(128); // borda

    // Largura total menor e altura maior
    const corpoLargura = 180.0;
    const corpoAltura = 40.0;
    const tampaLargura = 10.0;
    const tampaAltura = 20.0;

    return SizedBox(
      width: corpoLargura + tampaLargura + 10, // corpo + tampa + margem
      height: corpoAltura + 8, // um pouco mais de espaço vertical
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Corpo
              Container(
                width: corpoLargura,
                height: corpoAltura,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: bd, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: progress == null
                    ? Container(color: bg)
                    : LinearProgressIndicator(
                        value: progress,
                        minHeight: corpoAltura,
                        backgroundColor: bg,
                      ),
              ),
              // Tampa
              Container(
                width: tampaLargura,
                height: tampaAltura,
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                  color: bd,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          if (showPowerIcon)
            const Icon(
              Icons.electric_bolt,
              size: 28,
              color: Colors.amber, // ícone amarelo fixo
            ),
        ],
      ),
    );
  }
}
