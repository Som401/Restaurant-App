import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/drawer/my_drawer.dart';
import 'package:frontend/components/reservation_components/my_calendar.dart';
import 'package:frontend/components/reservation_components/my_guest_number.dart';
import 'package:frontend/components/reservation_components/my_time_picker.dart';

class TableReservationPage extends StatefulWidget {
  const TableReservationPage({super.key});

  @override
  State<TableReservationPage> createState() => _TableReservationPageState();
}

class _TableReservationPageState extends State<TableReservationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _selectedDay = DateTime.now();
  int _hour = DateTime.now().hour % 12 == 0 ? 12 : DateTime.now().hour % 12;
  int _minute = DateTime.now().minute;
  String _timeFormat = DateTime.now().hour < 12 ? "AM" : "PM";
  int _guestCounter = 1;

  void updateSelectedDay(DateTime newSelectedDay) {
    setState(() {
      _selectedDay = newSelectedDay;
    });
  }

  void incrementGuestCounter() {
    setState(() {
      _guestCounter++;
    });
  }

  void decrementGuestCounter() {
    setState(() {
      if (_guestCounter > 1) {
        _guestCounter--;
      }
    });
  }

  void updateHour(int newHour) {
    setState(() {
      _hour = newHour;
    });
  }

  void updateMinute(int newMinute) {
    setState(() {
      _minute = newMinute;
    });
  }

  void updateTimeFormat(String newTimeFormat) {
    setState(() {
      _timeFormat = newTimeFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return Scaffold(
        key: _scaffoldKey,
        drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: MyAppBar(
          title: "Table Reservation",
          scaffoldKey: _scaffoldKey,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date:",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.06,
                  ),
                ),
                SizedBox(height: height * 0.01),
                MyCalendar(
                  selectedDay: _selectedDay,
                  onDaySelected: updateSelectedDay,
                ),
                SizedBox(height: height * 0.01),
                Text(
                  "Time:",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.06,
                  ),
                ),
                SizedBox(height: height * 0.01),
                MyTimePicker(
                    hour: _hour,
                    minute: _minute,
                    timeFormat: _timeFormat,
                    updateHour: updateHour,
                    updateMinute: updateMinute,
                    updateTimeFormat: updateTimeFormat),
                Text(
                  "Guests:",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: minDimension * 0.06,
                  ),
                ),
                SizedBox(height: height * 0.01),
                MyGuestNumber(
                    guestCounter: _guestCounter,
                    incrementGuestCounter: incrementGuestCounter,
                    decrementGuestCounter: decrementGuestCounter),
                SizedBox(height: height * 0.01),
              ],
            ),
          ),
        ));
  }
}
