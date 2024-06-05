import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/pages/login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.20),
          child: Column(
            children: [
              Text(
                'Create a new account',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.01),
              Text(
                'Please fill in the form to continue',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: width * 0.03,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        hintStyle: TextStyle(
                            fontSize: width * 0.05,
                            color: Theme.of(context).colorScheme.secondary),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    TextField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontSize: width * 0.05,
                            color: Theme.of(context).colorScheme.secondary),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                          fontSize: width * 0.05,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    TextField(
                      obscureText: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: width * 0.05,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.visibility,
                            color: Theme.of(context).colorScheme.secondary,
                            size: width * 0.06),
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    TextField(
                      obscureText: true,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: width * 0.05,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.visibility,
                            color: Theme.of(context).colorScheme.secondary,
                            size: width * 0.06),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.2),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.1,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          padding: EdgeInsets.all(width * 0.05),
                          textStyle: TextStyle(fontSize: width * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: width * 0.06,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: width * 0.08,
                      ),
                      label: Text('Sign in with google',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: width * 0.05,
                          )),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: width * 0.03,
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
                              color: Theme.of(context).colorScheme.inverseSurface,
                              fontSize: width * 0.03,
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
