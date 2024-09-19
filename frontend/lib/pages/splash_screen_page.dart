import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:frontend/auth/auth.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.7;
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    String logoPath = isDarkMode
        ? "assets/images/delcapo_logo.png"
        : "assets/images/light_mode_delcapo_logo.png";
    return AnimatedSplashScreen(
      splash: Center(child: Image.asset(logoPath)),
      nextScreen: const AuthPage(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      splashIconSize: iconSize,
      duration: 2000,
    );
  }
}
