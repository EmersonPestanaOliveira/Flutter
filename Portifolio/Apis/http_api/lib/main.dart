import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JsonPlaceholderApp(),
    );
  }
}

class JsonPlaceholderApp extends StatefulWidget {
  @override
  _JsonPlaceholderAppState createState() => _JsonPlaceholderAppState();
}

class _JsonPlaceholderAppState extends State<JsonPlaceholderApp> {
  String _response = "";

  Future<void> _getPosts() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    setState(() {
      _response = response.body;
    });
  }

  Future<void> _createPost() async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': 'foo', 'body': 'bar', 'userId': 1}),
    );
    setState(() {
      _response = response.body;
    });
  }

  Future<void> _updatePost() async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': 1,
        'title': 'updated title',
        'body': 'updated body',
        'userId': 1
      }),
    );
    setState(() {
      _response = response.body;
    });
  }

  Future<void> _patchPost() async {
    final response = await http.patch(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': 'patched title'}),
    );
    setState(() {
      _response = response.body;
    });
  }

  Future<void> _deletePost() async {
    final response = await http
        .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    setState(() {
      _response = response.statusCode == 200
          ? 'Deleted successfully'
          : 'Failed to delete';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSONPlaceholder API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _getPosts,
              child: Text('GET'),
            ),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('POST'),
            ),
            ElevatedButton(
              onPressed: _updatePost,
              child: Text('PUT'),
            ),
            ElevatedButton(
              onPressed: _patchPost,
              child: Text('PATCH'),
            ),
            ElevatedButton(
              onPressed: _deletePost,
              child: Text('DELETE'),
            ),
            SizedBox(height: 20),
            Text(
              'Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
