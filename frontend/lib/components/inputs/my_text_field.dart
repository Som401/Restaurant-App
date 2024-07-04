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

  const MyTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.isEmail = false,
      this.isNumber = false,
      this.isPhone = false,
      this.multiline = 1});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    return TextField(
      maxLength: 200,
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
      maxLines: multiline,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: minDimension * 0.04,
          color: Theme.of(context).colorScheme.secondary,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
