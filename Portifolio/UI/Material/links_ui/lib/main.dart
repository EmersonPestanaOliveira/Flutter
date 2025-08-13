import 'package:flutter/material.dart';

void main() {
  runApp(LinksDemoApp());
}

class LinksDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Links Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LinksDemoPage(),
    );
  }
}

class LinksDemoPage extends StatelessWidget {
  void _onTap(String widgetType) {
    print('$widgetType tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Links Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => _onTap('TextButton'),
              child: Text('TextButton'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _onTap('InkWell'),
              onLongPress: () => print('InkWell long pressed'),
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.blue.withOpacity(0.3),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'InkWell',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            InkResponse(
              onTap: () => _onTap('InkResponse'),
              highlightColor: Colors.blue.withOpacity(0.2),
              splashColor: Colors.blue.withOpacity(0.3),
              radius: 30,
              child: Icon(
                Icons.touch_app,
                size: 50,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _onTap('GestureDetector'),
              onLongPress: () => print('GestureDetector long pressed'),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'GestureDetector',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
