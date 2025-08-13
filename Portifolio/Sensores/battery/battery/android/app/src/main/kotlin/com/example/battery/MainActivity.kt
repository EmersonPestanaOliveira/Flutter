package com.example.battery

import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SAVER_CHANNEL = "battery_saver_channel"
    private val HEALTH_CHANNEL = "battery_health_channel"
    private val TIME_CHANNEL   = "battery_time_channel"

    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)

        // === Abrir Economia de Energia (sem plugin) ===
        MethodChannel(engine.dartExecutor.binaryMessenger, SAVER_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openBatterySaver") {
                    try {
                        val intent = Intent("android.settings.BATTERY_SAVER_SETTINGS")
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        // === Ler Saúde da Bateria ===
        MethodChannel(engine.dartExecutor.binaryMessenger, HEALTH_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getBatteryHealth") {
                    try {
                        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                        val batteryStatus = registerReceiver(null, filter)
                        val health = batteryStatus?.getIntExtra(
                            BatteryManager.EXTRA_HEALTH,
                            BatteryManager.BATTERY_HEALTH_UNKNOWN
                        ) ?: BatteryManager.BATTERY_HEALTH_UNKNOWN
                        result.success(health) // retorna o código inteiro do Android
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        // === Estatísticas p/ estimativa + detalhes (carga/descarga, temp, voltagem, tech) ===
        MethodChannel(engine.dartExecutor.binaryMessenger, TIME_CHANNEL)
           .setMethodCallHandler { call, result ->
        if (call.method == "getBatteryStats") {
            try {
                val bm = getSystemService(BATTERY_SERVICE) as BatteryManager

                val chargeUAH = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER) // µAh
                val currentUA = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)     // µA

                val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
                val level  = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
                val scale  = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
                val percent = if (level > 0 && scale > 0) (level * 100 / scale) else -1

                val tempTenthsC = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1 // décimos °C
                val voltageMv  = intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1) ?: -1       // mV
                val tech       = intent?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: ""     // ex: Li-ion

                val map = HashMap<String, Any>()
                map["charge_uAh"] = chargeUAH
                map["current_uA"] = currentUA
                map["status"] = status
                map["percent"] = percent
                map["temperature_tenths_c"] = tempTenthsC
                map["voltage_mV"] = voltageMv
                map["technology"] = tech
                result.success(map)
            } catch (e: Exception) {
                result.error("ERROR", e.message, null)
            }
        } else {
            result.notImplemented()
        }
    }

    }
}
