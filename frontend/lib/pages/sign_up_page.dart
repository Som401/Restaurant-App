import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/inputs/phone_number_input.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/verification_page.dart';
import 'package:frontend/services/user_services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final UserService _userService = UserService();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
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

  void registerUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(content: Text("Please fill all the fields")),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));
      if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(content: Text("Passwords do not match")),
        );
      } else {
        try {
          await _userService.registerUser(
            emailController.text,
            passwordController.text,
            fullNameController.text,
            phoneNumberController.text,
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => VerificationPage(
                        phoneNumber: phoneNumberController.text,
                      )),
              (Route route) => false);
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(content: Text(e.message ?? "An error occurred")),
          );
        } catch (e) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                content: Text("An unexpected error occurred")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: !kIsWeb && Platform.isIOS
                ? MediaQuery.of(context).size.shortestSide < 600
                    ? 0 // iPhone
                    : height * 0.1 // iPad
                : height * 0.1, // Android
          ),
          child: Column(
            children: [
              Text(
                'Create a new account',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: minDimension * 0.07,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Please fill in the form to continue',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: minDimension * 0.04,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full Name",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: minDimension * 0.045,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    MyTextField(
                      hintText: "Your Name",
                      controller: emailController,
                      isEmail: true,
                      filled: true,
                      // enabled: !isReservationProcessing,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      "Email Address",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: minDimension * 0.045,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    MyTextField(
                      hintText: "Your Email Address",
                      controller: emailController,
                      isEmail: true,
                      filled: true,
                      // enabled: !isReservationProcessing,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
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
                      height: height * 0.01,
                    ),
                    PhoneNumberInput(
                        controller: phoneNumberController,
                        number: number,
                        validNumber: validNumber,
                        onValidChanged: onValidChanged,
                        onInputChanged: onInputChanged),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: minDimension * 0.04,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    MyTextField(
                      hintText: "Your Password",
                      controller: passwordController,
                      isPassword: true,
                      filled: true,
                      passwordVisible: isPasswordVisible,
                      onChanged: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: minDimension * 0.04,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    MyTextField(
                      hintText: "confirm Password",
                      controller: confirmPasswordController,
                      isPassword: true,
                      filled: true,
                      passwordVisible: isConfirmPasswordVisible,
                      onChanged: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    MyButton(
                      text: 'Sign Up',
                      onTap: () {
                        registerUser();
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: minDimension * 0.045,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (Route route) => false);
                          },
                          child: Text(
                            " Login",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                              fontSize: minDimension * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
