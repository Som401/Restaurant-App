import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';

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
  final bool passwordVisible;
  final Function() onChanged;

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
      this.enabled = true,
      this.passwordVisible = false,
      this.onChanged = _defaultOnChanged});

  static void _defaultOnChanged() {}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return TextField(
      maxLength: 150,
      style: TextStyle(
        fontSize: minDimension * 0.05,
      ),
      controller: controller,
      obscureText: isPassword ? !passwordVisible : false,
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
        fillColor: isDarkMode
            ? filled
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surface,
        counterText: '',
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: minDimension * 0.04,
          color: Theme.of(context).colorScheme.secondary,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: isDarkMode
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.inverseSurface,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: isDarkMode
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.inverseSurface,
            width: 1.0,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: isDarkMode
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.inverseSurface,
            width: 1.0,
          ),
        ),
        suffixIcon: isPassword
            ? Padding(
                padding: EdgeInsets.only(right: width * 0.03),
                child: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.secondary,
                    size: minDimension * 0.06,
                  ),
                  onPressed: () {
                    onChanged();
                  },
                ),
              )
            : null,
      ),
    );
  }
}
