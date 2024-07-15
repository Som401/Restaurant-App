// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final List<String> items;
  final String dropdownValue;
  final Function(String) updateDropdownValue;
  const MyDropdownButton({
    super.key,
    required this.items,
    required this.dropdownValue,
    required this.updateDropdownValue,
  });

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.01),
      width: width * 0.9,
      height: width * 0.12,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: widget.dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: widget.items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: TextStyle(
                  fontSize: minDimension * 0.04,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          }).toList(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
          onChanged: (String? newValue) {
            widget.updateDropdownValue(newValue!);
          },
        ),
      ),
    );
  }
}
