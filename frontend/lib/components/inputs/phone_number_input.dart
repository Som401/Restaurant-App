import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final PhoneNumber number;
  final bool validNumber;
  final Function(bool) onValidChanged;
  final Function(PhoneNumber) onInputChanged;
  const PhoneNumberInput({
    super.key,
    required this.controller,
    required this.number,
    required this.validNumber,
    required this.onValidChanged,
    required this.onInputChanged,
  });

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  bool _isValid = false;
  PhoneNumber? _lastNumber;
  @override
  void initState() {
    super.initState();
    _isValid = widget.validNumber;
    _lastNumber = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return InternationalPhoneNumberInput(
      inputDecoration: InputDecoration(
        hintText: 'Phone Number',
        filled: true,
        fillColor: isDarkMode
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: widget.number.phoneNumber != null &&
                    !widget.validNumber &&
                    widget.number.phoneNumber != widget.number.dialCode
                ? Theme.of(context).colorScheme.inversePrimary
                : isDarkMode
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.inverseSurface,
            width: 1,
          ),
        ),
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: minDimension * 0.04,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: widget.number.phoneNumber != null &&
                    !widget.validNumber &&
                    widget.number.phoneNumber != widget.number.dialCode
                ? Theme.of(context).colorScheme.inversePrimary
                : isDarkMode
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.inverseSurface,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: isDarkMode
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.inverseSurface,
            width: 1,
          ),
        ),
      ),
      searchBoxDecoration: InputDecoration(
        hintText: 'Search by country name or dial code',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: minDimension * 0.035,
        ),
      ),
      onInputChanged: (PhoneNumber number) {
        if (_lastNumber != number) {
          _lastNumber = number;
          widget.onInputChanged(number);
        }
      },
      onInputValidated: (bool value) {
        if (_isValid != value) {
          setState(() {
            _isValid = value;
          });
          widget.onValidChanged(value);
        }
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: minDimension * 0.04,
      ),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: minDimension * 0.04,
      ),
      initialValue: widget.number,
      textFieldController: widget.controller,
      formatInput: false,
      keyboardType: TextInputType.phone,
      inputBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      onSaved: (PhoneNumber number) {
        // Save number logic here if needed
      },
    );
  }
}
