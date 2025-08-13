import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../controllers/service_controller.dart';

class ServiceCalendarWidget extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const ServiceCalendarWidget({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _ServiceCalendarWidgetState createState() => _ServiceCalendarWidgetState();
}

class _ServiceCalendarWidgetState extends State<ServiceCalendarWidget> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final controller = GetIt.I<ServiceController>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _focusedDay = widget.initialDate;
    _selectedDay = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'pt_BR',
      focusedDay: _focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mês', // Apenas o formato "Mês" será permitido
      },
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
    );
  }
}
