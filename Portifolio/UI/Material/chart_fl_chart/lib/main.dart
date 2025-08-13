import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Line Chart Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LineChartScreen(),
    );
  }
}

class LineChartScreen extends StatelessWidget {
  const LineChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos mrx_charts'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [LineChartWidget(), BarChartWidget(), PieChartWidget()],
          )),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Chart(
        layers: [
          ChartAxisLayer(
            settings: const ChartAxisSettings(
              x: ChartAxisSettingsAxis(
                frequency: 1.0,
                max: 6.0,
                min: 0.0,
                textStyle: TextStyle(),
              ),
              y: ChartAxisSettingsAxis(
                frequency: 20.0,
                max: 100.0,
                min: 0.0,
                textStyle: TextStyle(),
              ),
            ),
            labelX: (value) => 'X$value',
            labelY: (value) => 'Y$value',
          ),
          ChartLineLayer(
            items: [
              ChartLineDataItem(x: 0, value: 5),
              ChartLineDataItem(x: 1, value: 55),
              ChartLineDataItem(x: 2, value: 65),
              ChartLineDataItem(x: 3, value: 75),
              ChartLineDataItem(x: 4, value: 5),
              ChartLineDataItem(x: 5, value: 85),
            ],
            settings: const ChartLineSettings(
              color: Colors.blue,
              thickness: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Chart(
        layers: [
          ChartAxisLayer(
            settings: const ChartAxisSettings(
              x: ChartAxisSettingsAxis(
                frequency: 1.0,
                max: 6.0,
                min: 0.0,
                textStyle: TextStyle(),
              ),
              y: ChartAxisSettingsAxis(
                frequency: 20.0,
                max: 100.0,
                min: 0.0,
                textStyle: TextStyle(),
              ),
            ),
            labelX: (value) => 'X$value',
            labelY: (value) => 'Y$value',
          ),
          ChartBarLayer(
            items: [
              ChartBarDataItem(value: 20, x: 0, color: Colors.blue),
              ChartBarDataItem(value: 40, x: 1, color: Colors.blue),
              ChartBarDataItem(value: 60, x: 2, color: Colors.blue),
              ChartBarDataItem(value: 80, x: 3, color: Colors.blue),
              ChartBarDataItem(value: 50, x: 4, color: Colors.blue),
              ChartBarDataItem(value: 90, x: 5, color: Colors.blue),
            ],
            settings: const ChartBarSettings(
              thickness: 10.0,
              radius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Chart(
        layers: [
          ChartGroupPieLayer(
            // Camada para gráfico de pizza
            items: [
              [
                ChartGroupPieDataItem(
                  amount: 40,
                  color: Colors.blue,
                  label: 'a',
                ),
                ChartGroupPieDataItem(
                  amount: 30,
                  color: Colors.red,
                  label: 'b',
                ),
                ChartGroupPieDataItem(
                  amount: 20,
                  color: Colors.green,
                  label: 'c',
                ),
                ChartGroupPieDataItem(
                  amount: 10,
                  color: Colors.yellow,
                  label: 'd',
                ),
              ],
            ],
            settings: const ChartGroupPieSettings(
              gapBetweenChartCircles: 0,
            ),
          ),
        ],
      ),
    );
  }
}
