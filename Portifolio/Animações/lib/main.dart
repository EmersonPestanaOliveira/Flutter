import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AnimatedContainer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedContainerDemo(),
    );
  }
}

class AnimatedContainerDemo extends StatefulWidget {
  @override
  _AnimatedContainerDemoState createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  // Properties for the AnimatedContainer
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  // Function to trigger animation with random values
  void _changeProperties() {
    setState(() {
      _width = (100 + (200 * (0.5 - 0.25)));
      _height = (100 + (200 * (0.5 - 0.25)));
      _color = Colors.primaries[_width.toInt() % Colors.primaries.length];
      _borderRadius = BorderRadius.circular(_width % 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedContainer Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeProperties,
              child: Text('Change Properties'),
            ),
          ],
        ),
      ),
    );
  }
}
