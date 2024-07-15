import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/inputs/phone_number_input.dart';
import 'package:frontend/pages/menu_page.dart';
import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/services/restaurant_services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ReservationInfoDetails extends StatefulWidget {
  final DateTime selectedDay;
  final String occasion;
  final int guestCounter;
  const ReservationInfoDetails(
      {super.key,
      required this.selectedDay,
      required this.occasion,
      required this.guestCounter});

  @override
  State<ReservationInfoDetails> createState() => _ReservationInfoDetailsState();
}

class _ReservationInfoDetailsState extends State<ReservationInfoDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final networkStatus = Provider.of<NetworkStatus>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
          toolbarHeight: minDimension * 0.1,
          scrolledUnderElevation: 0,
          elevation: 0.0,
          title: Text(
            "Table Reservation",
            style: TextStyle(
              fontSize: minDimension * 0.05,
            ),
          ),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: minDimension * 0.08),
            onPressed: () => Navigator.of(context).pop(),
          )),
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
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Invalid Input',
                          text: 'Please fill all the fields correctly.',
                          barrierDismissible: false,
                          confirmBtnTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          confirmBtnColor:
                              Theme.of(context).colorScheme.tertiary,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          textColor: Theme.of(context).colorScheme.primary,
                          titleColor: Theme.of(context).colorScheme.primary,
                          onConfirmBtnTap: () {
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          });
                    } else if (networkStatus == NetworkStatus.offline) {
                      QuickAlert.show(
                          context: context,
                          barrierDismissible: false,
                          type: QuickAlertType.error,
                          title: 'Order Failed',
                          text:
                              'We were unable to process your order at this time. Please check your internet connection and try again.',
                          confirmBtnTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          confirmBtnColor:
                              Theme.of(context).colorScheme.tertiary,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          textColor: Theme.of(context).colorScheme.primary,
                          titleColor: Theme.of(context).colorScheme.primary,
                          onConfirmBtnTap: () {
                            setState(() {
                              isReservationProcessing = false;
                              Navigator.of(context).pop();
                            });
                          });
                    } else {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        barrierDismissible: false,
                        title: 'Processing',
                        text: 'Your Reservation is being processed...',
                        confirmBtnTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        confirmBtnColor: Theme.of(context).colorScheme.tertiary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        textColor: Theme.of(context).colorScheme.primary,
                        titleColor: Theme.of(context).colorScheme.primary,
                      );

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
                      );

                      await Future.wait([
                        reservationFuture,
                        Future.delayed(const Duration(seconds: 2)),
                      ]);
                      Navigator.of(context).pop();
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        barrierDismissible: false,
                        title: 'Success',
                        text: 'Reservation added successfully!',
                        confirmBtnTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        confirmBtnColor: Theme.of(context).colorScheme.tertiary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        textColor: Theme.of(context).colorScheme.primary,
                        titleColor: Theme.of(context).colorScheme.primary,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuPage(),
                            ),
                          );
                        },
                      );
                      Future.delayed(const Duration(seconds: 5), () {
                        if (mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuPage(),
                            ),
                          );
                        }
                      });
                    }
                  } catch (e) {
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Error',
                      text: 'Failed to add reservation. Please try again.',
                      confirmBtnTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      confirmBtnColor: Theme.of(context).colorScheme.tertiary,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      textColor: Theme.of(context).colorScheme.primary,
                      titleColor: Theme.of(context).colorScheme.primary,
                      onConfirmBtnTap: () {
                        Navigator.of(context).pop();
                      },
                    );
                    Future.delayed(const Duration(seconds: 5), () {
                      if (mounted) {
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
