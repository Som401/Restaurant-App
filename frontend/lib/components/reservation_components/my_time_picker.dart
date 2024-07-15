import 'dart:math';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

// ignore: must_be_immutable
class MyTimePicker extends StatefulWidget {
  int hour;
  int minute;
  String timeFormat;
  final Function(int) updateHour;
  final Function(int) updateMinute;
  final Function(String) updateTimeFormat;
  MyTimePicker(
      {super.key,
      required this.hour,
      required this.minute,
      required this.timeFormat,
      required this.updateHour,
      required this.updateMinute,
      required this.updateTimeFormat});

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return SizedBox(
      height: minDimension * 0.5,
      width: minDimension * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberPicker(
                  minValue: 0,
                  maxValue: 12,
                  value: widget.hour,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: minDimension * 0.18,
                  itemHeight: minDimension * 0.14,
                  onChanged: (value) {
                    widget.updateHour(value);
                  },
                  textStyle: TextStyle(
                      color: Colors.grey, fontSize: minDimension * 0.05),
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: minDimension * 0.07),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: widget.minute,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: minDimension * 0.18,
                  itemHeight: minDimension * 0.14,
                  onChanged: (value) {
                    widget.updateMinute(value);
                  },
                  textStyle: TextStyle(
                      color: Colors.grey, fontSize: minDimension * 0.05),
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: minDimension * 0.07),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        bottom: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.updateTimeFormat("AM");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: minDimension * 0.05,
                            vertical: minDimension * 0.025),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: widget.timeFormat == "AM"
                              ? Theme.of(context).colorScheme.inverseSurface
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        child: Text(
                          "AM",
                          style: TextStyle(
                              color: widget.timeFormat == "PM"
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              fontSize: minDimension * 0.06),
                        ),
                      ),
                    ),
                     SizedBox(
                      height: height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.updateTimeFormat("PM");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: minDimension * 0.05,
                            vertical: minDimension * 0.025),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: widget.timeFormat == "PM"
                              ? Theme.of(context).colorScheme.inverseSurface
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                        child: Text(
                          "PM",
                          style: TextStyle(
                              color: widget.timeFormat == "AM"
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white,
                              fontSize: minDimension * 0.06),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
