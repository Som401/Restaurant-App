import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/appBar/my_app_bar.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/quick_alerts/quick_alerts.dart';
import 'package:frontend/providers/netwouk_status_provider.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool currentPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  bool isPasswordValid = false;
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                  Text(
                    'The new password must be different from the current password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: minDimension * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Text(
                    'Current Password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: minDimension * 0.04,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  MyTextField(
                    hintText: "",
                    controller: _currentPasswordController,
                    isPassword: true,
                    passwordVisible: currentPasswordVisible,
                    onChanged: () {
                      setState(() {
                        currentPasswordVisible = !currentPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'New Password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: minDimension * 0.04,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  MyTextField(
                    hintText: "",
                    controller: _newPasswordController,
                    isPassword: true,
                    passwordVisible: newPasswordVisible,
                    onChanged: () {
                      setState(() {
                        newPasswordVisible = !newPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Confirm New Password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: minDimension * 0.04,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  MyTextField(
                    hintText: "",
                    controller: _confirmPasswordController,
                    isPassword: true,
                    passwordVisible: confirmPasswordVisible,
                    onChanged: () {
                      setState(() {
                        confirmPasswordVisible = !confirmPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: height * 0.02),
                 
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: MyButton(
                onTap: () async {
                  if (isLoading) return;
                  try {
                    if (networkStatus == NetworkStatus.offline) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'No Internet Connection',
                          'Please check your internet connection and try again.',
                          () {});
                    } else if (_newPasswordController.text !=
                        _confirmPasswordController.text) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'Error',
                          'New password and confirm password do not match.',
                          () {});
                    } else if (_currentPasswordController.text ==
                        _newPasswordController.text) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'Error',
                          'New password must be different from the current password.',
                          () {});
                    } else if (_newPasswordController.text.length < 6) {
                      QuickAlerts.showErrorAlert(
                          context,
                          'Error',
                          'Password must be at least 6 characters long.',
                          () {});
                    } else {
                      QuickAlerts.showLoadingAlert(context, 'Processing',
                          'Your changes is being processed...');

                      setState(() {
                        isLoading = true;
                      });
                      var updatePassword = userService.updateUserPassword(
                          _currentPasswordController.text,
                          _newPasswordController.text);
                      await Future.wait([
                        updatePassword,
                        Future.delayed(const Duration(seconds: 2)),
                      ]);
                      QuickAlerts.showSuccessAlert(
                          context, 'Success', 'Password updated successfully!',
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
                  } on auth.FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      QuickAlerts.showErrorAlert(context, 'Wrong Password',
                          'The current password you entered is incorrect. Please try again.',
                          () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      QuickAlerts.showErrorAlert(context, 'Error',
                          'Failed to update password due to an unexpected error. Please try again.',
                          () {
                        Navigator.of(context).pop();
                      });
                    }
                  } catch (error) {
                    QuickAlerts.showErrorAlert(context, 'Error',
                        'Failed to save your changes. Please try again.', () {
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
                text: 'Save Changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
