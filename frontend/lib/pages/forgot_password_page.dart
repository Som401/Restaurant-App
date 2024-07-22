import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/quick_alerts/wifi_error.dart';
import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  bool isEmailProcessing = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final minDimension = min(width, height);
    final userService = UserService();
    final networkStatus = Provider.of<NetworkStatus>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: "Change Password",
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
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.secondary,
                            size: minDimension * 0.08,
                          ),
                          Expanded(
                              child: Text(
                            'We will send the OTP code to your email for security in forgetting your password',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: minDimension * 0.035,
                            ),
                          ))
                        ],
                      ),
                    ),
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
                    enabled: !isEmailProcessing,
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: MyButton(
                onTap: () async {
                  if (isEmailProcessing) return;
                  try {
                    if (networkStatus == NetworkStatus.offline) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'No Internet Connection',
                          'Please check your internet connection and try again.',
                          () {});
                    } else if (emailController.text.isEmpty) {
                      QuickAlerts.showErrorAlert(context, 'Error',
                          'Please enter your email address.', () {});
                    } else if (!emailController.text.contains('@') ||
                        !emailController.text.contains('.')) {
                      QuickAlerts.showErrorAlert(context, 'Error',
                          'Please enter a valid email address.', () {});
                    } else if (emailController.text !=
                        auth.FirebaseAuth.instance.currentUser!.email) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'Error',
                          'Please enter the email address associated with your account.',
                          () {});
                    } else {
                      QuickAlerts.showLoadingAlert(context, 'Sending Email',
                          'Please wait while we send the email...');
                      setState(() {
                        isEmailProcessing = true;
                      });
                      var resetPassword =
                          userService.resetUserPassword(emailController.text);
                      await Future.wait([
                        resetPassword,
                        Future.delayed(const Duration(seconds: 2))
                      ]);
                      QuickAlerts.showSuccessAlert(context, 'Success',
                          'Password reset email sent successfully to ${emailController.text}.',
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
                          Navigator.of(context).pop();
                          userService.signOut(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const AuthPage()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      });
                    }
                  } catch (error) {
                    QuickAlerts.showErrorAlert(context, 'Error',
                        'Failed to reset your password. Please try again.', () {
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
                },
                text: 'Submit',
              ),
            )
          ],
        ),
      ),
    );
  }
}
