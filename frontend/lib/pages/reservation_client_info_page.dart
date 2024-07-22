import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/inputs/phone_number_input.dart';
import 'package:frontend/components/quick_alerts/wifi_error.dart';
import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class ReservationClientInfoPage extends StatefulWidget {
  final DateTime selectedDay;
  final String occasion;
  final int guestCounter;
  const ReservationClientInfoPage(
      {super.key,
      required this.selectedDay,
      required this.occasion,
      required this.guestCounter});

  @override
  State<ReservationClientInfoPage> createState() =>
      _ReservationClientInfoPageState();
}

class _ReservationClientInfoPageState extends State<ReservationClientInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RestaurantServices restaurantServices = RestaurantServices();
  bool isReservationProcessing = false;

  PhoneNumber number = PhoneNumber(isoCode: 'TN', dialCode: '216');
  bool validNumber = false;

  void onInputChanged(PhoneNumber value) {
    setState(() {
      number = value;
    });
  }

  void onValidChanged(bool value) {
    setState(() {
      validNumber = value;
    });
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final networkStatus = Provider.of<NetworkStatus>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: "Table Reservation",
        scaffoldKey: _scaffoldKey,
        isFromDrawerMenu: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Information Details",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: minDimension * 0.06,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: minDimension * 0.045,
                      ),
                    ),
                    MyTextField(
                      hintText: "Full Name",
                      controller: nameController,
                      filled: true,
                      enabled: !isReservationProcessing,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: minDimension * 0.045,
                      ),
                    ),
                    MyTextField(
                      hintText: "Email Address",
                      controller: emailController,
                      isEmail: true,
                      filled: true,
                      enabled: !isReservationProcessing,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      "Notes:",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: minDimension * 0.045,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    MyTextField(
                      hintText: "Enter your order notes here...",
                      controller: notesController,
                      multiline: 3,
                      filled: true,
                      enabled: !isReservationProcessing,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.045,
                          ),
                        ),
                        Text(
                          'Invalid phone number',
                          style: TextStyle(
                              color: number.phoneNumber != null &&
                                      !validNumber &&
                                      number.phoneNumber != number.dialCode
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.surface,
                              fontSize: minDimension * 0.03),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    PhoneNumberInput(
                        controller: phoneNumberController,
                        number: number,
                        validNumber: validNumber,
                        onValidChanged: onValidChanged,
                        onInputChanged: onInputChanged),
                    SizedBox(
                      height: height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: height * 0.02,
              ),
              child: MyButton(
                text: "Confirm Reservation",
                onTap: () async {
                  if (isReservationProcessing) return;
                  try {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneNumberController.text.isEmpty ||
                        !validNumber ||
                        !isValidEmail(emailController.text)) {
                      QuickAlerts.showErrorAlert(context, 'Invalid Input',
                          'Please fill all the fields correctly.', () {});
                    } else if (networkStatus == NetworkStatus.offline) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'No Internet Connection',
                          'Please check your internet connection and try again.',
                          () {});
                    } else {
                      QuickAlerts.showLoadingAlert(context, 'Processing',
                          'Your Reservation is being processed...');

                      setState(() {
                        isReservationProcessing = true;
                      });

                      var reservationFuture = restaurantServices.addReservation(
                        name: nameController.text,
                        email: emailController.text,
                        occasion: widget.occasion,
                        selectedDay: widget.selectedDay,
                        phoneNumber: number.phoneNumber!,
                        dialCode: number.dialCode!,
                        nbGuests: widget.guestCounter,
                        notes: notesController.text,
                      );
                      Map<String, dynamic> reservationData = {
                        'name': nameController.text,
                        'email': emailController.text,
                        'phoneNumber': number.phoneNumber!,
                        'occasion': widget.occasion,
                        'selectedDay': Timestamp.fromDate(widget.selectedDay),
                        'guestCounter': widget.guestCounter,
                        'notes': notesController.text,
                        'state': 'pending',
                      };
                      await Future.wait([
                        reservationFuture,
                        Future.delayed(const Duration(seconds: 2)),
                      ]);
                      QuickAlerts.showSuccessAlert(
                          context, 'Success', 'Reservation added successfully!',
                          () {
                        Navigator.of(context).pop();
                        Navigator.pop(context, reservationData);
                      });
                      Future.delayed(const Duration(seconds: 5), () {
                        if (mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.pop(context, reservationData);
                        }
                      });
                    }
                  } catch (e) {
                    QuickAlerts.showErrorAlert(context, 'Error',
                        'Failed to add reservation. Please try again.', () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                    Future.delayed(const Duration(seconds: 5), () {
                      if (mounted) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
