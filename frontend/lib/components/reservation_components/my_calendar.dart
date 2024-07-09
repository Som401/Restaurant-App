import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;

  const MyCalendar(
      {super.key, required this.selectedDay, required this.onDaySelected});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    // print('focuded day');
    // print(_focusedDay);
    // print('selected day');
    // print(widget.selectedDay);
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365 * 5)),
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: minDimension * 0.04),
        leftChevronIcon: Icon(Icons.arrow_back_ios, size: minDimension * 0.04),
        rightChevronIcon:
            Icon(Icons.arrow_forward_ios, size: minDimension * 0.04),
      ),
      rowHeight: minDimension * 0.1,
      daysOfWeekHeight: minDimension * 0.05,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: minDimension * 0.03),
        weekendStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: minDimension * 0.03),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDay, day);
      },
      availableGestures: AvailableGestures.all,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = selectedDay;
        });
        widget.onDaySelected(selectedDay);
      },
      calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          defaultTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: minDimension * 0.04),
          weekendTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: minDimension * 0.04),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inverseSurface,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
              color: Colors.white,
              fontSize: minDimension * 0.04,
              fontWeight: FontWeight.bold),
          outsideTextStyle:
              TextStyle(color: Colors.grey, fontSize: minDimension * 0.03),
          disabledTextStyle:
              TextStyle(color: Colors.grey, fontSize: minDimension * 0.03)),
    );
  }
}
