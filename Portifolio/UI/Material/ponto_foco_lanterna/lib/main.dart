import 'package:flutter/material.dart';
import 'package:flutter_spotlight_plus/flutter_spotlight_plus.dart';

void main() {
  runApp(FocusLightDemoApp());
}

class FocusLightDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Light Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FocusLightDemoPage(),
    );
  }
}

class FocusLightDemoPage extends StatefulWidget {
  @override
  _FocusLightDemoPageState createState() => _FocusLightDemoPageState();
}

class _FocusLightDemoPageState extends State<FocusLightDemoPage> {
  bool _isHighlightVisible = false;

  void _toggleHighlight() {
    setState(() {
      _isHighlightVisible = !_isHighlightVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Focus Light Demo'),
      ),
      body: Spotlight(
        enabled: _isHighlightVisible,
        color: Colors.black.withOpacity(0.7),
        radius: 200,
        center: MediaQuery.of(context).size.center(Offset.zero),
        onTap: _toggleHighlight,
        animation: true,
        ignoring: false,
        description: Container(
          alignment: Alignment.center,
          child: Text(
            'This is the focused area',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Tap the button to toggle the spotlight',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _toggleHighlight,
                child: Text('Toggle Spotlight'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
