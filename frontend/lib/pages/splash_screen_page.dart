import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:frontend/auth/auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.7;
    return AnimatedSplashScreen(
      splash: Center(
        child:Image.asset("assets/images/delcapo_logo.png")
        // Divider(
        //   color: Theme.of(context).colorScheme.inversePrimary,
        //   thickness: 5,
        // ),
      ),
      nextScreen: const AuthPage(),
      backgroundColor: Theme.of(context).colorScheme.background,
      splashIconSize:iconSize,
      duration: 3000,
    );
  }
}
