import 'package:flutter/material.dart';

class DatePickerPlayground extends StatefulWidget {
  const DatePickerPlayground({super.key});

  @override
  State<DatePickerPlayground> createState() => _DatePickerPlaygroundState();
}

class _DatePickerPlaygroundState extends State<DatePickerPlayground> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Picker')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDate: selectedDate ?? DateTime.now(),
            );

            if (result != null) {
              setState(() => selectedDate = result);
            }
          },
          icon: const Icon(Icons.date_range),
          label: Text(
            selectedDate == null
                ? 'Selecionar data'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
          ),
        ),
      ),
    );
  }
}
