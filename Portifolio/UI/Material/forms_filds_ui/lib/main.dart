import 'package:flutter/material.dart';

void main() {
  runApp(TextWidgetsDemoApp());
}

class TextWidgetsDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Widgets Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TextWidgetsDemoPage(),
    );
  }
}

class TextWidgetsDemoPage extends StatefulWidget {
  @override
  _TextWidgetsDemoPageState createState() => _TextWidgetsDemoPageState();
}

class _TextWidgetsDemoPageState extends State<TextWidgetsDemoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFormFieldController =
      TextEditingController();
  String _formattedText = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Form Submitted');
      print('TextField Value: ${_textFieldController.text}');
      print('TextFormField Value: ${_textFormFieldController.text}');
    }
  }

  void _updateTextField(String value) {
    setState(() {
      _formattedText = value.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Widgets Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  labelText: 'TextField',
                  hintText: 'Enter some text',
                  helperText: 'Helper text for guidance',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.text_fields),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => _textFieldController.clear(),
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => print('TextField Submitted: $value'),
                onChanged: _updateTextField,
                maxLength: 20,
                textAlign: TextAlign.center,
                obscureText: false, // Set to true for password fields
              ),
              SizedBox(height: 16),
              Text('Formatted Text: $_formattedText',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _textFieldController.text =
                    "Button Value", // Pass value via button
                child: Text('Set TextField Value'),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _textFormFieldController,
                      decoration: InputDecoration(
                        labelText: 'TextFormField',
                        hintText: 'Enter validated text',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.edit),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        if (value.length < 3) {
                          return 'Must be at least 3 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit Form'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
