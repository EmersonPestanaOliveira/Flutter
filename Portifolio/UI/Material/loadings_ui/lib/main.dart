import 'package:flutter/material.dart';

void main() {
  runApp(LoadingsDemoApp());
}

class LoadingsDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loadings Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoadingsDemoPage(),
    );
  }
}

class LoadingsDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loadings Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Circular Progress Indicator:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Center(
              child: CircularProgressIndicator(
                value: 0.7,
                strokeWidth: 6.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey[300],
              ),
            ),
            SizedBox(height: 24),
            Text('Linear Progress Indicator:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 24),
            Text('Custom Circular Progress Indicator:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0.8,
                      strokeWidth: 8.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                      backgroundColor: Colors.grey[300],
                    ),
                    Text('80%',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Custom Linear Progress Indicator:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Stack(
              children: [
                LinearProgressIndicator(
                  value: 0.6,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  backgroundColor: Colors.grey[300],
                ),
                Center(
                  child: Text('60%',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
