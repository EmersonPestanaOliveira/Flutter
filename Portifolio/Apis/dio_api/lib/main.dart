import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
  final Dio _dio = Dio();
  String _response = "";

  Future<void> _getPost() async {
    try {
      final response =
          await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      setState(() {
        _response = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> _createPost() async {
    try {
      final response = await _dio.post(
        'https://jsonplaceholder.typicode.com/posts',
        data: {'title': 'foo', 'body': 'bar', 'userId': 1},
      );
      setState(() {
        _response = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> _updatePost() async {
    try {
      final response = await _dio.put(
        'https://jsonplaceholder.typicode.com/posts/1',
        data: {
          'id': 1,
          'title': 'updated title',
          'body': 'updated body',
          'userId': 1
        },
      );
      setState(() {
        _response = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> _patchPost() async {
    try {
      final response = await _dio.patch(
        'https://jsonplaceholder.typicode.com/posts/1',
        data: {'title': 'patched title'},
      );
      setState(() {
        _response = response.data.toString();
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  Future<void> _deletePost() async {
    try {
      final response =
          await _dio.delete('https://jsonplaceholder.typicode.com/posts/1');
      setState(() {
        _response = response.statusCode == 200
            ? 'Deleted successfully'
            : 'Failed to delete';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSONPlaceholder with Dio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _getPost,
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
