import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(IconsDemoApp());
}

class IconsDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icons Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: IconsDemoPage(),
    );
  }
}

class IconsDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Icons Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Built-in Icon:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 50.0,
                semanticLabel: 'Favorite Icon',
              ),
              SizedBox(height: 16),
              Text('Flutter Logo:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              FlutterLogo(
                size: 50.0,
                style: FlutterLogoStyle.horizontal,
                textColor: Colors.blue,
              ),
              SizedBox(height: 16),
              Text('External Icons (FontAwesome):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(FontAwesomeIcons.github,
                      size: 50.0, color: Colors.black),
                  Icon(FontAwesomeIcons.twitter,
                      size: 50.0, color: Colors.blue),
                  Icon(FontAwesomeIcons.facebook,
                      size: 50.0, color: Colors.blueAccent),
                  Icon(FontAwesomeIcons.linkedin,
                      size: 50.0, color: Colors.blue),
                ],
              ),
              SizedBox(height: 16),
              Text('Custom Button with Icon:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => print('Icon button pressed!'),
                icon: Icon(Icons.send),
                label: Text('Send'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
