<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Flutter Battery Insights (Android + Flutter)</title>
<style>
  :root { color-scheme: light dark; }
  body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, Noto Sans, Arial, sans-serif; line-height: 1.6; margin: 2rem auto; max-width: 950px; padding: 0 1rem; }
  h1, h2, h3 { line-height: 1.25; }
  code, pre { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace; }
  pre { background: rgba(127,127,127,.08); padding: 1rem; border-radius: .5rem; overflow: auto; }
  kbd { background: #eee; border-radius: 4px; padding: .1rem .4rem; border: 1px solid #ccc; }
  .grid { display: grid; gap: .5rem; }
  .k { color: #824; font-weight: 600; }
  .small { opacity: .8; font-size: .95rem; }
  .tag { display: inline-block; padding: .15rem .45rem; border: 1px solid rgba(127,127,127,.3); border-radius: .4rem; margin-right: .25rem; font-size: .85rem; }
  .warn { background: #fff3cd; border: 1px solid #ffecb5; padding: .75rem 1rem; border-radius: .5rem; }
  img { max-width: 100%; height: auto; border-radius: .5rem; }
  hr { border: none; border-top: 1px solid rgba(127,127,127,.25); margin: 2rem 0; }
</style>
</head>
<body>

<header>
  <h1>Flutter Battery Insights (Android + Flutter)</h1>
  <p class="small">
    App em Flutter que exibe <strong>nível de bateria</strong>, <strong>estado</strong>, <strong>saúde</strong>, <strong>temperatura</strong>, <strong>voltagem</strong>,
    <strong>corrente instantânea</strong> e uma <strong>estimativa aproximada</strong> de <strong>tempo para carregar/descarregar</strong>.<br/>
    O projeto demonstra integração <strong>nativa Android via MethodChannel</strong> + <strong>Flutter (<code>battery_plus</code>)</strong>, com arquitetura limpa (<em>widgets</em>, <em>utils</em> e <em>mixin</em>).
  </p>
  <p><strong>Objetivo de portfólio:</strong> mostrar domínio de integração nativa (Kotlin ↔️ Flutter), boas práticas de organização e UX.</p>
</header>

<hr/>

<section>
  <h2>🎬 Demonstração</h2>
  <ul>
    <li>Vídeo/GIF: <code>docs/demo.gif</code></li>
    <li>Screenshots: <code>docs/screen_01.png</code>, <code>docs/screen_02.png</code></li>
  </ul>
</section>

<section>
  <h2>✨ Principais Funcionalidades</h2>
  <ul>
    <li>🔋 Nível da bateria (%) + estado (<code>charging</code>, <code>full</code>, <code>connectedNotCharging</code>, <code>discharging</code>, <code>unknown</code>)</li>
    <li>⚡ Barra linear tipo “bateria” com ícone sobreposto</li>
    <li>⏱️ Estimativa aprox. de tempo para <strong>carregar</strong>/<strong>descarregar</strong> (Android)</li>
    <li>❤️ Saúde da bateria (Android)</li>
    <li>🌡️ Temperatura, 🔌 Voltagem, 🔀 Corrente instantânea, 🧪 Tecnologia (Android)</li>
    <li>🟡 Alerta para <strong>Economia de energia</strong> quando ≤ <strong>20%</strong> (Android) + botão para abrir a tela do sistema</li>
    <li>🧱 Arquitetura organizada:
      <ul>
        <li><code>widgets/</code> (UI reutilizável)</li>
        <li><code>utils/</code> (serviços/integrações)</li>
        <li><code>mixins/</code> (separação de lógica da view)</li>
      </ul>
    </li>
  </ul>
</section>

<section>
  <h2>🧰 Stack</h2>
  <ul>
    <li>Flutter/Dart</li>
    <li>Kotlin (Android) via <strong>MethodChannel</strong></li>
    <li>Plugin: <code>battery_plus</code> (nível/estado)</li>
  </ul>
</section>

<section>
  <h2>🏗️ Arquitetura</h2>
  <pre><code>lib/
  battery/
    battery_page.dart
    mixins/
      battery_page_mixin.dart        # lógica/estado da tela
    utils/
      battery_state_styles.dart      # mapeia estados → (label, cor, ícone)
      battery_level_watcher.dart     # observa nível, threshold de 20%
      battery_saver.dart             # abre tela do Battery Saver (via MethodChannel)
      battery_health.dart            # lê saúde (via MethodChannel)
      battery_time_estimator.dart    # CHARGE_COUNTER/CURRENT_NOW → ETA (via MethodChannel)
      battery_details.dart           # temperatura, voltagem, corrente, tecnologia (via MethodChannel)
    widgets/
      battery_meter.dart             # barra linear estilizada tipo bateria
      battery_status_chip.dart       # chip de estado com cor/ícone
</code></pre>

  <p><strong>Canais nativos (Android/Kotlin):</strong></p>
  <ul>
    <li><code>battery_saver_channel</code> → abrir Economia de energia</li>
    <li><code>battery_health_channel</code> → ler saúde</li>
    <li><code>battery_time_channel</code> → ler <code>charge_uAh</code>, <code>current_uA</code>, <code>status</code>, <code>percent</code>, <code>temperatura</code>, <code>voltagem</code>, <code>tecnologia</code></li>
  </ul>
</section>

<section>
  <h2>🔌 Como funciona (alto nível)</h2>
  <pre><code>Flutter (Dart) ── MethodChannel ──► Android (Kotlin)
   ↑                                      │
   └──────── battery_plus ◄───────────────┘
</code></pre>
  <p><code>battery_plus</code>: nível (%) e estado.</p>
  <p><strong>MethodChannel:</strong> uso do <code>BatteryManager</code> (<code>BATTERY_PROPERTY_CHARGE_COUNTER</code> µAh, <code>BATTERY_PROPERTY_CURRENT_NOW</code> µA, <code>EXTRA_HEALTH</code>, <code>EXTRA_TEMPERATURE</code>, <code>EXTRA_VOLTAGE</code>, <code>EXTRA_TECHNOLOGY</code>, <code>EXTRA_STATUS</code>).</p>
  <p class="warn"><strong>Observação:</strong> Estimativas são <em>aproximadas</em> e variam conforme hardware/firmware e leitura instantânea de corrente.</p>
</section>

<section>
  <h2>📦 Pré-requisitos</h2>
  <ul>
    <li>Flutter 3.x+</li>
    <li>Android SDK (emulador ou device físico)</li>
    <li>Kotlin Embedding V2 (o projeto já usa)</li>
    <li><em>Opcional:</em> <code>battery_plus</code> pode exigir Android NDK 27 em algumas versões; se precisar:
      <ul>
        <li><code>android/app/build.gradle</code>: <code>ndkVersion "27.0.12077973"</code></li>
        <li>Instale o NDK pelo SDK Manager (ou <code>sdkmanager "ndk;27.0.12077973"</code>)</li>
      </ul>
    </li>
  </ul>
</section>

<section>
  <h2>▶️ Instalação e Execução</h2>
  <pre><code>flutter pub get
flutter run
</code></pre>

  <p><strong>Compilação “fria” é importante</strong> quando você altera canais nativos (Kotlin):</p>
  <pre><code>flutter clean
flutter pub get
flutter run
</code></pre>
</section>

<section>
  <h2>⚙️ Configuração Android (MainActivity)</h2>
  <p>Arquivo: <code>android/app/src/main/kotlin/&lt;seu/pacote&gt;/MainActivity.kt</code><br/>
  Contém os <strong>3 MethodChannels</strong>. Exemplo com pacote <code>com.example.battery</code>:</p>

  <pre><code class="language-kotlin">package com.example.battery

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
                } else result.notImplemented()
            }

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
                        result.success(health)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                } else result.notImplemented()
            }

        MethodChannel(engine.dartExecutor.binaryMessenger, TIME_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getBatteryStats") {
                    try {
                        val bm = getSystemService(BATTERY_SERVICE) as BatteryManager
                        val chargeUAH = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)
                        val currentUA = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)

                        val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                        val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
                        val level  = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
                        val scale  = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
                        val percent = if (level > 0 && scale > 0) (level * 100 / scale) else -1

                        val tempTenthsC = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
                        val voltageMv  = intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1) ?: -1
                        val tech       = intent?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: ""

                        val map = HashMap&lt;String, Any&gt;()
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
                } else result.notImplemented()
            }
    }
}
</code></pre>
</section>

<section>
  <h2>🖥️ Uso (na tela)</h2>
  <ul>
    <li>Barra linear tipo bateria com ícone ⚡ ao centro (<code>BatteryMeter</code>)</li>
    <li>Chip de estado (<code>BatteryStatusChip</code>)</li>
    <li>Estimativa aprox. logo abaixo da barra (via <code>BatteryTimeEstimator</code>)</li>
    <li>Detalhes em card: temperatura, voltagem, corrente, tecnologia (via <code>BatteryDetailsService</code>)</li>
    <li><strong>Botões:</strong>
      <ul>
        <li>“Ativar economia de energia” → abre tela do sistema (Android)</li>
        <li>“Atualizar agora” → força leitura</li>
        <li>“Ver saúde da bateria” → modal com status</li>
      </ul>
    </li>
  </ul>
</section>

<section>
  <h2>🧪 Simulação no Emulador</h2>
  <ul>
    <li><strong>Nível de bateria:</strong> Android Studio → <em>Extended Controls</em> → <em>Battery</em> → ajuste o <em>Charge level</em> (ex.: 15% para ver o alerta).</li>
    <li><strong>Estados:</strong> plugue/desplugue energia no painel do emulador.</li>
    <li><strong>Corrente/temperatura/saúde:</strong> podem ser estáticos ou não realistas no emulador. Em device físico você verá valores reais.</li>
  </ul>
</section>

<section>
  <h2>⚠️ Limitações</h2>
  <ul>
    <li>Estimativa de tempo é <em>aproximada</em>. Depende de <code>CURRENT_NOW</code>/<code>CHARGE_COUNTER</code>, que nem todo hardware expõe. Quando indisponível, o app mostra “—”.</li>
    <li><strong>iOS</strong>: APIs públicas não expõem saúde/temperatura/voltagem/corrente. O app foca em Android para métricas avançadas.</li>
    <li>Sinal de corrente (<code>CURRENT_NOW</code>) pode variar entre dispositivos; o código tenta inferir pelo <code>STATUS</code>.</li>
  </ul>
</section>

<section>
  <h2>🧪 Testes (sugestões)</h2>
  <ul>
    <li><strong>Dart unit</strong>
      <ul>
        <li>Mapeamento de saúde (códigos Android → labels)</li>
        <li>Formatação de temperatura/voltagem/corrente</li>
        <li><code>BatteryTimeEstimator.pretty</code></li>
      </ul>
    </li>
    <li><strong>Widget/golden</strong>
      <ul>
        <li>Estados visuais (carregando / descarregando / conectado-sem-carregar)</li>
      </ul>
    </li>
    <li><strong>Kotlin (opcional)</strong>
      <ul>
        <li>Extrair leituras para classe e mockar <code>BatteryManager</code> em testes instrumentados</li>
      </ul>
    </li>
  </ul>
  <pre><code>flutter test
</code></pre>
</section>

<section>
  <h2>✅ Qualidade &amp; CI (opcional)</h2>
  <ul>
    <li>Análise: <code>flutter analyze</code></li>
    <li>CI: GitHub Actions com jobs para <em>analyze</em> + <em>test</em> + build Android</li>
    <li>Lints: <code>flutter_lints</code> ou <code>very_good_analysis</code></li>
    <li>Apresentação: <code>flutter_launcher_icons</code> + <code>flutter_native_splash</code></li>
  </ul>
</section>

<section>
  <h2>🗺️ Roadmap</h2>
  <ul>
    <li>Plugin Flutter federado (<code>battery_insights</code>) com <code>platform_interface</code></li>
    <li>Gráfico de corrente/nível nas últimas horas (local storage)</li>
    <li>Animação do ícone ⚡ quando carregando (pulsar)</li>
  </ul>
</section>

<section>
  <h2>📄 Licença</h2>
  <p>Sugestão: <strong>MIT</strong>. Crie um arquivo <code>LICENSE</code> com o texto MIT.</p>
</section>

<section>
  <h2>🙏 Créditos</h2>
  <ul>
    <li><code>battery_plus</code> pela API multiplataforma de nível/estado</li>
    <li>Android <code>BatteryManager</code> / <code>ACTION_BATTERY_CHANGED</code> (APIs públicas)</li>
  </ul>
</section>

</body>
</html>
