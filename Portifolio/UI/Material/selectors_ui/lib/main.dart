import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(SelectorsDemoApp());
}

class SelectorsDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selectors Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SelectorsDemoPage(),
    );
  }
}

class SelectorsDemoPage extends StatefulWidget {
  @override
  _SelectorsDemoPageState createState() => _SelectorsDemoPageState();
}

class _SelectorsDemoPageState extends State<SelectorsDemoPage> {
  bool _isChecked = false;
  bool _isSwitched = false;
  String _selectedRadio = 'Option 1';
  double _sliderValue = 0;
  double _rating = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selectors Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CheckboxListTile(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
                title: Text('Checkbox'),
              ),
              SwitchListTile(
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
                title: Text('Switch'),
              ),
              Column(
                children: [
                  ListTile(
                    title: Text('Option 1'),
                    leading: Radio<String>(
                      value: 'Option 1',
                      groupValue: _selectedRadio,
                      onChanged: (value) {
                        setState(() {
                          _selectedRadio = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Option 2'),
                    leading: Radio<String>(
                      value: 'Option 2',
                      groupValue: _selectedRadio,
                      onChanged: (value) {
                        setState(() {
                          _selectedRadio = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                min: 0,
                max: 100,
                divisions: 10,
                label: _sliderValue.round().toString(),
              ),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _selectDate,
                child: Text('Select Date'),
              ),
              if (_selectedDate != null)
                Text(
                    'Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
              ElevatedButton(
                onPressed: _selectTime,
                child: Text('Select Time'),
              ),
              if (_selectedTime != null)
                Text('Selected Time: ${_selectedTime!.format(context)}'),
            ],
          ),
        ),
      ),
    );
  }
}
