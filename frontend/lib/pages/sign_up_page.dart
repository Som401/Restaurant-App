import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/inputs/phone_number_input.dart';
import 'package:frontend/components/quick_alerts/quick_alerts.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

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
  bool isProcessing = false;
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
    try {
      await _userService.registerUser(
        emailController.text,
        passwordController.text,
        fullNameController.text,
        phoneNumberController.text,
        number.dialCode!,
        number.isoCode!,
      );
      if (context.mounted) {
        QuickAlerts.showSuccessAlert(
            context, 'Success', 'Account created successfully', () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthPage()),
              (Route route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isProcessing = false;
      });
      QuickAlerts.showErrorAlert(context, 'Error', e.message ?? '', () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final networkStatus = Provider.of<NetworkStatus>(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        toolbarHeight: height * 0.02,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: !kIsWeb && Platform.isIOS ? 0 : height * 0.1,
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
                      controller: fullNameController,
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
                      onTap: () async {
                        if (isProcessing) return;
                        if (networkStatus == NetworkStatus.offline) {
                          QuickAlerts.showErrorAlert(
                              context,
                              'No Internet Connection',
                              'Please check your internet connection and try again.',
                              () {});
                        } else if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty ||
                            fullNameController.text.isEmpty ||
                            phoneNumberController.text.isEmpty) {
                          QuickAlerts.showErrorAlert(context, 'Error',
                              'Please fill all the fields.', () {});
                        } else if (!emailController.text.contains('@') ||
                            !emailController.text.contains('.')) {
                          QuickAlerts.showErrorAlert(context, 'Error',
                              'Please enter a valid email address.', () {});
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          QuickAlerts.showErrorAlert(context, 'Error',
                              'Passwords do not match.', () {});
                        } else {
                          QuickAlerts.showLoadingAlert(
                              context, 'Processing', 'Signing Up...');
                          setState(() {
                            isProcessing = true;
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            registerUser();
                          });
                        }
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
