import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.01;
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
                "assets/Lottie/Animation - 1717579815244.json"),
          ),
          Divider(
            color: Theme.of(context).colorScheme.inversePrimary,
            thickness: 5,
          ),
        ],
      ),
      nextScreen: LoginPage(),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      splashIconSize: iconSize,
      duration: 5000,
    );
  }
}
