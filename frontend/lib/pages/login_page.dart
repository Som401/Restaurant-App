import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/button/my_button.dart';
import 'package:frontend/components/inputs/my_text_field.dart';
import 'package:frontend/pages/sign_up_page.dart';
import 'package:frontend/services/user_services.dart';

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

  bool isPasswordVisible = false;
  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
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
      try {
        await _userService.login(
            context, emailController.text, passwordController.text);
        if (context.mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(content: Text(e.message!)),
        );
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
                      filled: true ,
                      passwordVisible: isPasswordVisible,
                      onChanged: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: height * 0.01),
                    GestureDetector(
                      onTap: () {},
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
                      onTap: login,
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
                    Container(
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
