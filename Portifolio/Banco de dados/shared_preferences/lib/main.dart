import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SharedPreferencesDemo(),
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  @override
  _SharedPreferencesDemoState createState() => _SharedPreferencesDemoState();
}

class _SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  final TextEditingController _stringController = TextEditingController();
  final TextEditingController _intController = TextEditingController();
  final TextEditingController _doubleController = TextEditingController();
  final TextEditingController _boolController = TextEditingController();
  final TextEditingController _listController = TextEditingController();

  String _stringValue = "";
  int? _intValue;
  double? _doubleValue;
  bool? _boolValue;
  List<String>? _listValue;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    if (_stringController.text.isNotEmpty) {
      await prefs.setString('stringKey', _stringController.text);
    }

    if (_intController.text.isNotEmpty) {
      await prefs.setInt('intKey', int.parse(_intController.text));
    }

    if (_doubleController.text.isNotEmpty) {
      await prefs.setDouble('doubleKey', double.parse(_doubleController.text));
    }

    if (_boolController.text.isNotEmpty) {
      await prefs.setBool(
          'boolKey', _boolController.text.toLowerCase() == 'true');
    }

    if (_listController.text.isNotEmpty) {
      final list = _listController.text.split(',');
      await prefs.setStringList('listKey', list);
    }

    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _stringValue = prefs.getString('stringKey') ?? "";
      _intValue = prefs.getInt('intKey');
      _doubleValue = prefs.getDouble('doubleKey');
      _boolValue = prefs.getBool('boolKey');
      _listValue = prefs.getStringList('listKey');
    });
  }

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Preferences Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _stringController,
              decoration: InputDecoration(labelText: 'Enter String'),
            ),
            TextField(
              controller: _intController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Integer'),
            ),
            TextField(
              controller: _doubleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Double'),
            ),
            TextField(
              controller: _boolController,
              decoration:
                  InputDecoration(labelText: 'Enter Boolean (true/false)'),
            ),
            TextField(
              controller: _listController,
              decoration:
                  InputDecoration(labelText: 'Enter List (comma separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save Data'),
            ),
            ElevatedButton(
              onPressed: _clearData,
              child: Text('Clear Data'),
            ),
            SizedBox(height: 20),
            Text('Saved Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('String: $_stringValue'),
            Text('Integer: $_intValue'),
            Text('Double: $_doubleValue'),
            Text('Boolean: $_boolValue'),
            Text('List: ${_listValue?.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
