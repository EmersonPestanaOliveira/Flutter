import 'package:flutter/material.dart';

void main() {
  runApp(NotificationsDemoApp());
}

class NotificationsDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotificationsDemoPage(),
    );
  }
}

class NotificationsDemoPage extends StatelessWidget {
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Dialog'),
          content: Text('This is an alert dialog with two actions.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Cancel pressed');
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('OK pressed');
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('This is a SnackBar notification!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          print('SnackBar action pressed');
        },
      ),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showMaterialBanner(BuildContext context) {
    final banner = MaterialBanner(
      content: Text('This is a Material Banner notification!'),
      leading: Icon(Icons.info, color: Colors.blue),
      backgroundColor: Colors.lightBlue[50],
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            print('Dismiss pressed');
          },
          child: Text('Dismiss'),
        ),
      ],
    );
    ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              child: Text('Show Alert Dialog'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showSnackBar(context),
              child: Text('Show SnackBar'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showMaterialBanner(context),
              child: Text('Show Material Banner'),
            ),
          ],
        ),
      ),
    );
  }
}
