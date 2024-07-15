import 'dart:math';

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isEmail;
  final bool isNumber;
  final bool isPhone;
  final int multiline;
  final bool filled;
  final bool enabled;
  const MyTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.isEmail = false,
      this.isNumber = false,
      this.isPhone = false,
      this.filled = false,
      this.multiline = 1,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return TextField(
      maxLength: 150,
      style: TextStyle(
        fontSize: minDimension * 0.05,
      ),
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isNumber
              ? TextInputType.number
              : isPhone
                  ? TextInputType.phone
                  : TextInputType.text,
      textCapitalization: TextCapitalization.none,
      maxLines: multiline,
      enabled: enabled,
      decoration: InputDecoration(
        filled: filled,
        fillColor: filled
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.surface,
        counterText: '',
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: minDimension * 0.04,
          color: Theme.of(context).colorScheme.secondary,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
