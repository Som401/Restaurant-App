import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/components/quick_alerts/quick_alerts.dart';
import 'package:frontend/pages/forgot_password_page.dart';
import 'package:frontend/pages/sign_up_page.dart';
import 'package:frontend/services/user_services.dart';
import 'package:provider/provider.dart';

import '../providers/netwouk_status_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserService _userService = UserService();
  bool isProcessing = false;
  bool isPasswordVisible = false;
  void login() async {
    try {
      await _userService.login(
          context, emailController.text, passwordController.text);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthPage()),
          (Route route) => false);
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
        child: Column(
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: minDimension * 0.07,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Please login to your account',
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: height * 0.01),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(isAuth: false,),
                        ),
                      );
                    },
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Forgot Password?',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: minDimension * 0.04,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  MyButton(
                    text: 'Sign In',
                    onTap: () async {
                      if (isProcessing) return;
                      if (networkStatus == NetworkStatus.offline) {
                        QuickAlerts.showErrorAlert(
                            context,
                            'No Internet Connection',
                            'Please check your internet connection and try again.',
                            () {});
                      } else {
                        QuickAlerts.showLoadingAlert(
                            context, 'Processing', 'Signing In...');
                        setState(() {
                          isProcessing = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          login();
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.1, vertical: height * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            thickness: minDimension * 0.003,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Text(
                            'Or connect with',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: minDimension * 0.04,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            thickness: minDimension * 0.003,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final user = await _userService.signInWithGoogle();
                      if (user != null) {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()),
                        );
                      } else {
                        print('Error: signInWithGoogle returned false');
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(35.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              height: minDimension * 0.13,
                            ),
                            SizedBox(width: width * 0.01),
                            Text('Continue with Google',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: minDimension * 0.05,
                                )),
                          ],
                        )),
                  ),
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: minDimension * 0.045,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()),
                              (Route route) => false);
                        },
                        child: Text(
                          " Sign Up",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontSize: minDimension * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
