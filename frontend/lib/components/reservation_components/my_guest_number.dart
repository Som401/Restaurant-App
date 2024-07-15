import 'dart:math';

import 'package:flutter/material.dart';

class MyGuestNumber extends StatefulWidget {
final int guestCounter;
final Function() incrementGuestCounter;
final Function() decrementGuestCounter;
const MyGuestNumber({super.key, required this.guestCounter, required this.incrementGuestCounter, required this.decrementGuestCounter});

  @override
  State<MyGuestNumber> createState() => _MyGuestNumberState();
}

class _MyGuestNumberState extends State<MyGuestNumber> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    const maxGuests = 200;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            widget.decrementGuestCounter();
          },
          child: Container(
            height: width * 0.12,
            width: width * 0.12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: minDimension * 0.05,
            ),
          ),
        ),
        Container(
          width: width * 0.6,
          height: width * 0.12,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Center(
            child: Text(
              widget.guestCounter.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: minDimension * 0.06,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.guestCounter < maxGuests) {
              widget.incrementGuestCounter();
            }
          },
          child: Container(
            height: minDimension * 0.12,
            width: minDimension * 0.12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: minDimension * 0.05,
            ),
          ),
        ),
      ],
    );
  }
}
