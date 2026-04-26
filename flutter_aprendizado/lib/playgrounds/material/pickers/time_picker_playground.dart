import 'package:flutter/material.dart';

class TimePickerPlayground extends StatefulWidget {
  const TimePickerPlayground({super.key});

  @override
  State<TimePickerPlayground> createState() => _TimePickerPlaygroundState();
}

class _TimePickerPlaygroundState extends State<TimePickerPlayground> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Picker')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );

            if (result != null) {
              setState(() => selectedTime = result);
            }
          },
          icon: const Icon(Icons.access_time),
          label: Text(
            selectedTime == null
                ? 'Selecionar horÃ¡rio'
                : selectedTime!.format(context),
          ),
        ),
      ),
    );
  }
}
