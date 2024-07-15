import 'dart:math';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';

class MyCalendar extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;

  const MyCalendar(
      {super.key, required this.selectedDay, required this.onDaySelected});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return DatePicker(
      width: width * 0.15,
      height: width * 0.25,
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: Theme.of(context).colorScheme.inverseSurface,
      selectedTextColor: Colors.white,
      dayTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: minDimension * 0.03,
      ),
      monthTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: minDimension * 0.03,
      ),
      dateTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: minDimension * 0.05,
      ),
      onDateChange: (date) {
        widget.onDaySelected(date);
      },
    );
  }
}
