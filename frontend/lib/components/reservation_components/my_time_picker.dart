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
      height: height * 0.2,
      width: width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //     "Pick Your Time! ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")} $timeFormat",
          //     style:
          //         const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    widget.updateHour(value);
                  },
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30),
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
                  itemWidth: 80,
                  itemHeight: 60,
                  onChanged: (value) {
                    widget.updateMinute(value);
                  },
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                  selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 30),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                              fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.updateTimeFormat("PM");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                              fontSize: 25),
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
