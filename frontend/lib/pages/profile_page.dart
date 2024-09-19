import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/inputs/phone_number_input.dart';
import 'package:frontend/components/quick_alerts/quick_alerts.dart';

import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'TN', dialCode: '216');
  bool validNumber = false;
  bool passwordVisible = false;
  bool isUpdateProcessing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null && _auth.currentUser != null) {
      _nameController.text = user.name;
      _emailController.text = _auth.currentUser!.email!;
      _phoneNumberController.text = user.phoneNumber;
      number = PhoneNumber(
          isoCode: user.isoCode,
          dialCode: user.dialCode,
          phoneNumber: user.phoneNumber == '' ? null : user.phoneNumber);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final userService = UserService();
    final networkStatus = Provider.of<NetworkStatus>(context);
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: "My Profile",
        scaffoldKey: _scaffoldKey,
        isFromDrawerMenu: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name:",
                      style: TextStyle(
                        fontSize: minDimension * 0.05,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    MyTextField(
                      hintText: "",
                      controller: _nameController,
                      filled: true,
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Email:",
                      style: TextStyle(
                        fontSize: minDimension * 0.05,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    MyTextField(
                      hintText: "",
                      controller: _emailController,
                      enabled: user?.providerId == 'password',
                      filled: true,
                    ),
                    SizedBox(height: height * 0.01),
                    SizedBox(height: height * 0.01),
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
                        controller: _phoneNumberController,
                        number: number,
                        validNumber: validNumber,
                        onValidChanged: onValidChanged,
                        onInputChanged: onInputChanged),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    user?.providerId == 'password'
                        ? Column(
                            children: [
                              Text(
                                "Password:",
                                style: TextStyle(
                                  fontSize: minDimension * 0.05,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              MyTextField(
                                hintText: "",
                                controller: _passwordController,
                                isPassword: true,
                                passwordVisible: passwordVisible,
                                onChanged: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: MyButton(
                  text: 'Save Changes',
                  onTap: () async {
                    if (isUpdateProcessing) return;
                    try {
                      if (networkStatus == NetworkStatus.offline) {
                        QuickAlerts.showErrorAlert(
                            context,
                            'No Internet Connection',
                            'Please check your internet connection and try again.',
                            () {});
                      } else {
                        QuickAlerts.showLoadingAlert(context, 'Processing',
                            'Your changes is being processed...');

                        setState(() {
                          isUpdateProcessing = true;
                        });
                        var updateUser = userService.updateUserDetails(
                            _nameController.text,
                            _emailController.text,
                            _phoneNumberController.text,
                            user!.providerId == 'password'
                                ? _passwordController.text
                                : null,
                            number.dialCode!,
                            number.isoCode!,
                            user.providerId,
                            context);
                        await Future.wait([
                          updateUser,
                          Future.delayed(const Duration(seconds: 2)),
                        ]);

                        if (_emailController.text !=
                            _auth.currentUser!.email!) {
                          QuickAlerts.showSuccessAlert(
                              context,
                              'Verify New Email',
                              'A verification email has been sent to your new email address. Please verify to complete the update.',
                              () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            userService.signOut(context);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const AuthPage()),
                              (Route<dynamic> route) => false,
                            );
                          });
                          Future.delayed(const Duration(seconds: 5), () {
                            if (mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              userService.signOut(context);
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const AuthPage()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          });
                        } else {
                          QuickAlerts.showSuccessAlert(
                              context, 'Success', 'User updated successfully!',
                              () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          });

                          Future.delayed(const Duration(seconds: 5), () {
                            if (mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      }
                    } catch (e) {
                      QuickAlerts.showErrorAlert(context, 'Error',
                          'Failed to save your changes. Please try again.', () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                      Future.delayed(const Duration(seconds: 5), () {
                        if (mounted) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
